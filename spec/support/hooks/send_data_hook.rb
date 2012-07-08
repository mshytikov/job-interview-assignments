module SuperUpload
  module SendDataHook

    def self.extended(obj)
      origin_send_data = obj.class.instance_method(:send_data)
      define_method(:origin_send_data) do |*args|
        origin_send_data.bind(self).call(*args)
      end
    end


    def send_data(data)
      if @headers.nil?
        @headers = data
        origin_send_data(data)
      else
        l = data.bytesize
        first_part = data.byteslice(0, l/2)
        @second_part = data.byteslice(l/2, l-l/2)
        origin_send_data(first_part)
      end
    end

    def release_send_data!
      origin_send_data(@second_part)
    end
  end
end
