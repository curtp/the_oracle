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

      def list_required?
        return false
      end

      def display_list?
        return false
      end

      # Returns true if the user executing the command is the bot owner
      def bot_owner?
        return self.event.user.id.to_s.eql?(ENV["BOT_OWNER_ID"].to_s)
      end
      
    end
  end
end
