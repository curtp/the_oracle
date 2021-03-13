module Oracle
  module Models
    class RenameCommand < BaseCommand

      def list_name
        instructions[instructions.size - 3]
      end

      def new_name
        instructions.last
      end

      def list_required?
        true
      end
    end
  end
end
