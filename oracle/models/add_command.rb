module Oracle
  module Models
    class AddCommand < BaseListManagementCommand
      def display_list?
        return true
      end

      # The 3rd element in the instructions is the entry to add
      def weight
        instructions[2]
      end
      
    end
  end
end
