require_relative "./base_command"
module Oracle
  module Models
    class DisplayCommand < BaseCommand
      # The list name is the last entry in the instructions
      def list_name
        instructions.last
      end
    end
  end
end
