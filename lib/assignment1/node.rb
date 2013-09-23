module Assignment1
  class Node

    attr_reader :id, :inputs_count, :children_inputs_count, :children, :links
    def initialize(id)
      @id = id
      @uri = URI.parse(id)
      @children_inputs_count = 0
      @children = []
    end

    def build
      doc = Nokogiri::HTML(open(id))
      @inputs_count = doc.css('input').count
      @links = doc.css('a').map{|e| URIHelper.absolute_uri(id, e['href'])}.compact
      self
    end

    def absolute_uri(href)
      @uri.merge(URI.parse(href)).to_s
    end


    def add_child(child)
      @children << child
      @children_inputs_count += child.inputs_count
    end
  end
end
