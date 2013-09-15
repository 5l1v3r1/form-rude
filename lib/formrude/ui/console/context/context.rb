#
#
# 


module FormRude
module Ui
module Console
module Shell

  #
  # [Context] class controls console activity stack
  #
  class Context
    attr_accessor :current_context
    attr_accessor :parent_context

    def initialize
      self.current_context = []
      self.parent_context  = []
    end

    def item

    end


  end # Context

end # Shell
end # Console
end # UI
end # FormRude
