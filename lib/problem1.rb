module Problem1

  NUMBER_TO_WORD= {
    0 => "",
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
    90 => "ninety"
  }

  NUMBER_TO_LETTERS_COUNT  = Hash[NUMBER_TO_WORD.map{|k,v| [k, v.size]}]

  HUNDRED_COUNT = "hundred".size
  THOUSAND_COUNT = "thousand".size

  AND_COUNT= 3

  class << self

    def letters_count(number)

      case 
      when number > 1000
        raise ArgumentError, "Number must be <= 1000"

      when predefined_count(number)
        predefined_count(number)

      when number == 1000
        thousands_count = (number / 1000)
        letters_count(thousands_count) + THOUSAND_COUNT

      when number >= 100 
        hundreds_count = (number / 100)
        result  = letters_count(hundreds_count) + HUNDRED_COUNT

        unless (number % 100).zero? 
          result += AND_COUNT + letters_count(number - hundreds_count*100)
        end
        result

      when number > 20
        tens_count = (number / 10)
        predefined_count(tens_count*10) + letters_count(number - tens_count*10)
      end
    end

    def predefined_count(number)
      NUMBER_TO_LETTERS_COUNT[number]
    end
  end

end

