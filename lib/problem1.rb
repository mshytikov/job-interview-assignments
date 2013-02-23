$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'problem1/constants'

module Problem1
  extend Constants

  class << self

    def predefined_count(number)
      NUMBER_TO_LETTERS_COUNT[number]
    end

    def letters_count(number)

      case 
      when number > 1000 || number < 1 
        raise ArgumentError, "Number must be in range (1..1000)"

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


  end

end

