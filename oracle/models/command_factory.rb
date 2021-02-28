# frozen_string_literal: true
module Oracle
  module Models
    class CommandFactory

      def self.create_command_for_event(event)

        OracleLogger.log.debug {"CommandFactory: Creating command object for command: #{event.message.content.downcase.strip.split(" ")[1]}"}
        case event.message.content.downcase.strip.split(" ")[1]
        when "add"
          return AddCommand.new(event)
        when "remove"
          return RemoveCommand.new(event)
        when "display", "list"
          return DisplayCommand.new(event)
        when "ask"
          return AskCommand.new(event)
        when "rename"
          return RenameCommand.new(event)
        when "renumber"
          return RenumberCommand.new(event)
        when "stats"
          return StatsCommand.new(event)
        else
          return HelpCommand.new(event)
        end
      end

    end
  end
end
