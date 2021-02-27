module Oracle
  module Models
    class AddCommand < BaseListManagementCommand
      def display_list?
        return true
      end
    end
  end
end
