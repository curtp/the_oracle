module Oracle
  module Models
    class AskCommand < BaseCommand
      # The list name is the last entry in the instructions
      def list_name
        instructions.size == 3 ? instructions[1] : instructions.last
      end

      # THere may or may not be a question on the command
      def question
        instructions.size == 3 ? instructions.last : nil
      end

      def list_required?
        true
      end
    end
  end
end
