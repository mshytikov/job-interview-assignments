require 'nokogiri'
require 'open-uri'
require "assignment1/version"
require "assignment1/uri_helper"
require "assignment1/node"

module Assignment1

  class << self

    def build_tree(url, deep = 3, limit = 50)
      visit_node(url, 0, deep, limit, {})
    end



    private
    def visit_node(url, level, deep, limit, visited_nodes)
      node = Node.new(url)

      #return node if already  visited
      return visited_nodes[node.id] if visited_nodes.has_key?(node.id)

      # crawl web page
      node.build

      visited_nodes[node.id] = node

      if level < deep
        node.links.each{|link|
            break if visited_nodes.size > limit
            child = visit_node(link, level + 1, deep, limit, visited_nodes)
            node.add_child(child)
        }
      end
      node
    end
  end

end
