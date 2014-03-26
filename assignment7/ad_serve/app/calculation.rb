require 'securerandom'

module Calculation


  #
  # This function accepts weighted hash like {'key1' => weight1, 'key2' => weitght2,...}
  # It picks the key with weighted probability
  #
  def pick_random_weighted_key(weights)
    return nil if weights.empty?
    # Convert string weights to integer
    weights.each{|k, w| weights[k] = w.to_i}

    total_weight = weights.values.inject(:+)
    return pick_random_key(weights) if total_weight == 0

    random_weight = SecureRandom.random_number(total_weight)
    s = 0
    weights.each do |k, w|
      s += w
      break k if s > random_weight
    end
  end

  def pick_random_key(weights)
    weights.keys.sample
  end

  #
  # Accepts hash like { index1 => v1, index2 => v2, ...}, and bitmask 
  # Returns hash without keys with corresponding bit '1' in bitmask
  #
  def filter_indexed_hash(indexed_hash, bitmask)
    bitmask = bitmask.unpack('B*').first
    indexed_hash.select{|idx, w| idx.to_i >= bitmask.size ||  bitmask[idx.to_i] == '0'}
  end

end
