require 'nokogiri'
require 'faraday'
require "assignment1/version"
require "assignment1/uri_helper"
require "assignment1/visitable"
require "assignment1/node"

module Assignment1

  class << self

    #DFS traversal
    def build_tree(url, deep = 3, limit = 50)
      visit_node(url, 0, deep, limit, {})
    end

    def solve(url, &block)
      bfs(build_tree(url), &block)
    end

    private

    def bfs(root, &block)
      queue = []
      queue << root

      while !queue.empty? do
        node = queue.shift
        node.visit!(&block) unless node.visited?
        node.children.each{ |child| queue << child unless child.visited? }
      end
    end

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
