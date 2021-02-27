module Oracle
  module Models
    class RemoveCommand < BaseListManagementCommand
      def list_required?
        return true
      end
    end
  end
end
