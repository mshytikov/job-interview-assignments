require 'nokogiri'
require 'open-uri'
require "assignment1/version"
require "assignment1/uri_helper"
require "assignment1/node"

module Assignment1

  class << self

    def build_tree(url, deep = 3, limit = 50)
      visit_node(url, 0, 0, deep, limit)
    end

    def visit_node(url, level, nodes_count, deep, limit)
      node = Node.new(url).build
      nodes_count += 1
      if level < deep
        node.links.each{|link|
            break if nodes_count >= limit
            child = visit_node(link, level + 1, nodes_count, deep, limit)
            node.add_child(child)
            nodes_count += 1
        }
      end
      node
    end
  end

end
