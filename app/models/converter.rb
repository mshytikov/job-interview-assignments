module Converter

  class << self
    def convert(from, to, value)
      method_name = "#{from}_to_#{to}"
      raise(ArgumentError, "undefined conversion from '#{from}' to '#{to}'") unless respond_to?(method_name) 
      public_send(method_name, value)
    end

    def fahrenheit_to_celcius(value)

    end

    def celcius_to_fahrenheit(value)
    end


  end
end

