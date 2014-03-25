require 'securerandom'

module Calculation


  #
  # This function accepts weighted hash like {'key1' => weight1, 'key2' => weitght2,...}
  # It picks the key with weighted probability
  #
  def self.pick_random_weighted_key(weights)
    total_weight = weights.values.inject(:+)
    random_weight = SecureRandom.random_number(total_weight)
    s = 0
    weights.each_pair do |k, w|
      s += w
      break k if s > random_weight
    end
  end

  def self.pick_random_key(weights)
    weights.keys().sample()
  end

  #
  # Accepts hash like { index1 => v1, index2 => v2, ...}, and bitmask 
  # Returns hash without keys with corresponding bit '1' in bitmask
  #
  def self.filter_indexed_hash(indexed_hash, bitmask)
    bitmask.unpack('B*').map
    indexed_hash.select{|idx, w| idx >= bitmask.size ||  bitmask[idx] == '0'}
  end

end
