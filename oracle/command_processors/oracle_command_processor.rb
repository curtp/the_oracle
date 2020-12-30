require_relative "../validators/command_validator"
require_relative "./add_command_processor"
require_relative "./remove_command_processor"
require_relative "./display_command_processor"
require_relative "./ask_command_processor"
require_relative "./help_command_processor"
require_relative "./rename_command_processor"

module Oracle
  module CommandProcessors
    class OracleCommandProcessor
      include EasyLogging

      def self.execute(command)
        logger = EasyLogging.configure_logger_for(self.class.name)

        begin
          logger.info("Server: #{command.event.server.id}, User: #{command.event.user.name} issued command: #{command.event.message.content}")

          if command.help_command?
            processor = HelpCommandProcessor.new(command)
          else
            case command.base_instruction
            when "add".freeze
              processor = AddCommandProcessor.new(command)
            when "remove".freeze
              processor = RemoveCommandProcessor.new(command)
            when "display".freeze, "list".freeze
              processor = DisplayCommandProcessor.new(command)
            when "ask".freeze
              processor = AskCommandProcessor.new(command)
            when "rename".freeze
              processor = RenameCommandProcessor.new(command)
            else
              processor = HelpCommandProcessor.new(command)
            end
          end

          result = processor.process

          if !result[:success]
            command.event << "Error: #{result[:error_message]}"
            command.event << ""
            command.event << "See !oracle help for usage information"
          end
        rescue Exception => e
          logger.error("Issue processing request: #{e}")
          logger.error(e.backtrace.join("\n"))
        end
      end
    end
  end
end
