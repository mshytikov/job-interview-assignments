module Assignment1
  class Node

    attr_reader :id, :inputs_count, :total_inputs_count, :childrens, :links
    def initialize(id)
      @id = id
      @uri = URI.parse(id)
    end

    def build
      doc = Nokogiri::HTML(open(id))
      @inputs_count = doc.css('input').count
      @links = doc.css('a').map{|e| URIHelper.absolute_uri(id, e['href'])}.compact
      true
    end

    def absolute_uri(href)
      @uri.merge(URI.parse(href)).to_s
    end


    def add_child
    end
  end
end
