require_relative "./base_command"
module Oracle
  module Models
    class BaseListManagementCommand < BaseCommand
      # The list name is the last entry in the instructions
      def list_name
        instructions.last
      end

      # The 2nd element in the instructions is the entry to add
      def entry
        instructions[1]
      end
    end
  end
end
