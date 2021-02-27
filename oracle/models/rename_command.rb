module Oracle
  module Models
    class RenameCommand < BaseCommand

      def list_name
        instructions[instructions.size - 3]
      end

      def new_name
        instructions.last
      end

    end
  end
end
