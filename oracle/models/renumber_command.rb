module Oracle
  module Models
    class RenumberCommand < BaseListManagementCommand
      def server_required?
        return true
      end
    end
  end
end
