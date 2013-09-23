require 'uri'

module Assignment1
  module URIHelper

    def absolute_uri(root, href)
      return nil if (href.nil? || href == '' || href=~ /^#|\s+$/ )
      URI.parse(root).merge(URI.parse(href)).to_s rescue nil
    end

    module_function :absolute_uri
  end
end
