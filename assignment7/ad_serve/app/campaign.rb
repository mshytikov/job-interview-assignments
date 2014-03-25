class Campaign
  include Redis::Objects
  include Calculation

  # This lua script needed to fully delete campaign which
  # can have millions keys with users data this is most efficient way
  LUA_SCRIPT_DELETE = "for _,k in ipairs(redis.call('keys', KEYS[1])) do redis.call('del',k) end"

  lock :campaign, :expiration => 5, :timeout => 0.1

  # This counter keeps size of the campaign
  # It needed because keys in 'weights' can be deleted but size 
  # should not decrease.
  counter :size

  hash_key :ratio

  # Keeps mapping banner_index -> weight
  hash_key :weights

  # Keeps mapping banner_index -> banner_id
  hash_key :banners

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def save(random, weighted)
    self.ratio.update({
      random: random,
      weighted: weighted
    })
  end

  # Delete all keys with  prefix campaign:<id>
  def delete
    redis.eval(LUA_SCRIPT_DELETE, :keys => ["#{self.class.redis_prefix}:#{id}:*"])
  end

  def get_banner(banner_id)
    Redis::HashKey.new("#{self.class.redis_prefix}:#{id}:banner:#{banner_id}")
  end

  def save_banner(banner_id, url, weight)
    campaign_lock.lock do
      banner = get_banner(banner_id)
      index = self.size.value
      banner.update({url: url , index: index})
      self.weights[index] = weight
      self.banners[index] = banner_id
      self.size.increment
    end
  end

  # Delete banner without decremeting the size
  # The functionality like cleanup (vacuum) for rebuilding the index
  # should be done in separate method 
  def delete_banner(id, url, weight)
    campaign_lock.lock do 
      banner = get_banner(id)
      index = banner[:index]
      weights.delete(index)
      banners.delete(index)
      banner.clear
    end
  end

  def user_key(user_id)
    "#{redix_prefix}:user:#{user_id}"
  end

  def get_next_banner_url(user_id)
    key = user_key(user_id)
    bitmask = redis.get(key) || ''
    available = Calculation.filter_indexed_hash(weights.all, bitmask)

    mechanisms= pick_random_weighted_key(ratio)
    if mechanisms.to_sym == :weighted
      banner_index = pick_random_weighted_key(available)
    else
      banner_index = pick_random_key(available)
    end

    url = nil

    if banner_index
      redis.setbit(key, banner_index, 1) # set bit to 1 means banner was showed
      banner_id = banners[banner_index]
      url = get_banner(banner_id)[:url]
    end

    reutrn url 
  end
end
