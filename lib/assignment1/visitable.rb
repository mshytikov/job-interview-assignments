module Assignment1
  module Visitable

    def visited?
      @visited || false
    end

    def visit!(&block)
      @visited = true
      block.call(self)
    end

  end
end
