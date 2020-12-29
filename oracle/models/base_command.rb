module Oracle
  module Models
    class BaseCommand
      attr_accessor :event

      def initialize(event)
        self.event = event
      end

      def content
        event.message.content
      end

      def instructions
        content.tokenize.drop(1)
      end

      def base_instruction
        instructions[0]
      end

      def help_command?
        return false
      end
    end
  end
end
