require_relative "./add_command"
require_relative "./remove_command"
require_relative "./display_command"
require_relative "./ask_command"
require_relative "./help_command"
module Oracle
  module Models
    class CommandFactory

      def self.create_command_for_event(event)
        case event.message.content.downcase.split(" ")[1]
        when "add"
          return AddCommand.new(event)
        when "remove"
          return RemoveCommand.new(event)
        when "display"
          return DisplayCommand.new(event)
        when "ask"
          return AskCommand.new(event)
        else
          puts "creating the help command"
          return HelpCommand.new(event)
        end
      end

    end
  end
end
