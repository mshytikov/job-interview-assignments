
module Problem1

  NUMBER_TO_WORD= {
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 =>  "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety",
    100 => "hundred",
    1000 => "thousand",
  }

  NUMBER_TO_LETTERS_COUNT  = Hash[NUMBER_TO_WORD.map{|k,v| [k, v.size]}]


  AND_COUNT= 3

  def self.letters_count(number)
    return 0 if number.zero?

    letters_count = NUMBER_TO_LETTERS_COUNT[number]
    return letters_count if letters_count

    if number > 1000 and number < 9999
      thousands_count = (number / 1000)
      letters_count(thousands_count) + NUMBER_TO_LETTERS_COUNT[1000]  + AND_COUNT + letters_count(number - thousands_count*1000)
    elsif number > 100 
      hundreds_count = (number / 100)
      letters_count(hundreds_count) + NUMBER_TO_LETTERS_COUNT[100]  + AND_COUNT + letters_count(number - hundreds_count*100)
    elsif number > 20
      tens_count = (number / 10)
      letters_count(tens_count) + NUMBER_TO_LETTERS_COUNT[10] + letters_count(number - tens_count*10)
    end
  end
end

