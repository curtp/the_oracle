# frozen_string_literal: true

module Oracle
  module CommandProcessors
    class OracleCommandProcessor

      def self.execute(command)

        begin
          OracleLogger.log.info("OracleCommandProcessor: Server: #{command.event.server.id}, User: #{command.event.user.name} issued command: #{command.event.message.content}")

          if command.help_command?
            processor = HelpCommandProcessor.new(command)
          else
            case command.base_instruction
            when "add"
              processor = AddCommandProcessor.new(command)
            when "remove"
              processor = RemoveCommandProcessor.new(command)
            when "display", "list"
              processor = DisplayCommandProcessor.new(command)
            when "ask"
              processor = AskCommandProcessor.new(command)
            when "rename"
              processor = RenameCommandProcessor.new(command)
            when "renumber"
              processor = RenumberCommandProcessor.new(command)
            when "stats"
              processor = StatsCommandProcessor.new(command)
            when "filter"
              processor = FilterCommandProcessor.new(command)
            else
              processor = HelpCommandProcessor.new(command)
            end
          end

          result = processor.process

          if !result[:success]
            command.event << "Sorry! #{result[:error_message]}"
            command.event << ""
            command.event << "See !oracle help for usage information"
          end
        rescue Exception => e
          OracleLogger.log.error("OracleCommandProcessor: Issue processing request: #{e}")
          OracleLogger.log.error(e.backtrace.join("\n"))
        end
      end
    end
  end
end
