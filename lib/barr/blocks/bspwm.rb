require 'barr/block'


module Barr
  module Blocks

    class Bspwm < Block

      attr_reader :monitor
      def initialize opts={}
        super
        @monitor = opts[:monitor] || first_monitor["name"]
      end

      def update!
        @tree = nil
        op = []
        focused = ""
        
        bsp_tree["monitors"].each do |monitor|
          next if monitor["name"] != @monitor
          focused = monitor["focusedDesktopName"]
          monitor["desktops"].each do |desktop|
            thisop =  desktop["name"] + " "
            thisop += "<<" if desktop["name"] == focused

            op << thisop
          end
          
        end

        @output = op.join(" ")
      end

      def bsp_tree
        @tree ||= JSON.parse(`bspc wm -d`)
      end

      def first_monitor
        bsp_tree["monitors"].first
      end
    end
  end
end
