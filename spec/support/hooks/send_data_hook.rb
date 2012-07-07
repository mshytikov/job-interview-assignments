module SuperUpload
  module SendDataHook

    def self.extended(obj)
      @origin_send_data = obj.method(:send_data)
    end


    def send_data(data)
      l = data.bytesize/2
      first_part = data.byteslice(0, l)
      @second_part = data.byteslice(l, -1)
      super(first_part)
    end

    def release_send_data!
      @origin_send_data.call(@second_part)
    end
  end
end
