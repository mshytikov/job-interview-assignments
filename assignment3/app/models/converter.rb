module Converter

  @@types = []
  class << self

    def convert(from, to, value)
      raise(ArgumentError, "undefined conversion from '#{from}' to '#{to}'") unless convert?(from, to)
      public_send(conversion_method_name(from, to), value)
    end

    def conversion(from, to, formula)
      @@types << [from.to_s, to.to_s]
      method_name = conversion_method_name(from, to)
      define_method(method_name, formula)
      module_function method_name
    end

    def types
      @@types
    end

    private 
    def convert?(from, to)
      @@types.include?([from, to])
    end

    def conversion_method_name(from, to)
      "#{from}_to_#{to}"
    end
  end

  conversion :fahrenheit, :celsius, ->(value){ (value - 32)*5.0/9.0 }
  conversion :celsius, :fahrenheit, ->(value){ value*9.0/5.0 + 32 }
end

