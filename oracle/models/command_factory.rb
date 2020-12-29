require_relative "./add_command"
require_relative "./remove_command"
require_relative "./display_command"
require_relative "./ask_command"
require_relative "./help_command"
module Oracle
  module Models
    class CommandFactory
      include EasyLogging

      def self.create_command_for_event(event)
        logger.debug {"Creating command object for command: #{event.message.content.downcase.strip.split(" ")[1]}"}
        case event.message.content.downcase.strip.split(" ")[1]
        when "add".freeze
          return AddCommand.new(event)
        when "remove".freeze
          return RemoveCommand.new(event)
        when "display".freeze
          return DisplayCommand.new(event)
        when "ask".freeze
          return AskCommand.new(event)
        else
          return HelpCommand.new(event)
        end
      end

    end
  end
end
