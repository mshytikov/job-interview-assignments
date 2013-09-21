require "assignment2/version"

module Assignment2
  FIZZ =   'Fizz'.freeze
  BUZZ =   'Buzz'.freeze
  FIZZBUZZ = 'FizzBuzz'.freeze

  class << self
    def fizz_buzz(i)
      raise(ArgumentError, "Is not an Integer") unless i.kind_of?(Integer)

      case 
      when (i%15).zero? then FIZZBUZZ
      when (i%3).zero?  then FIZZ
      when (i%5).zero?  then BUZZ
      else i.to_s
      end
    end
  end
end
