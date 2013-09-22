module Converter

  class << self

    def convert(from, to, value)
      method_name = "#{from}_to_#{to}"
      raise(ArgumentError, "undefined conversion from '#{from}' to '#{to}'") unless respond_to?(method_name) 
      public_send(method_name, value)
    end

    def fahrenheit_to_celsius(value)
      (value - 32)*5.0/9.0
    end

    def celsius_to_fahrenheit(value)
      value*9.0/5.0 + 32
    end

  end
end

