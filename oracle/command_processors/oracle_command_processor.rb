require_relative "../validators/command_validator"
require_relative "./add_command_processor"
require_relative "./remove_command_processor"
require_relative "./display_command_processor"
require_relative "./ask_command_processor"
require_relative "./help_command_processor"

module Oracle
  module CommandProcessors
    class OracleCommandProcessor
      include EasyLogging

      def self.execute(command)
        begin
          logger.info("Server: #{command.event.server.id}, User: #{command.event.user.name} issued command: #{command.event.message.content}")
          if command.help_command?
            processor = HelpCommandProcessor.new(command)
            result = processor.process
          else
            case command.base_instruction
            when "add".freeze
              processor = AddCommandProcessor.new(command)
              result = processor.process
            when "remove".freeze
              processor = RemoveCommandProcessor.new(command)
              result = processor.process
            when "display".freeze, "list".freeze
              processor = DisplayCommandProcessor.new(command)
              result = processor.process
            when "ask".freeze
              processor = AskCommandProcessor.new(command)
              result = processor.process
            else
              processor = HelpCommandProcessor.new(command)
              result = processor.process
            end
          end

          if !result[:success]
            command.event << "Error: #{result[:error_message]}"
            command.event << ""
            HelpCommandProcessor.build_help_message(command.event)
          end
        rescue Exception => e
          logger.error("Issue processing request: #{e}")
          logger.error(e.backtrace.join("\n"))
        end
      end
    end
  end
end
