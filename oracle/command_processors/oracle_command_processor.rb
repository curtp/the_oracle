require_relative "../validators/command_validator"
require_relative "./add_command_processor"
require_relative "./remove_command_processor"
require_relative "./display_command_processor"
require_relative "./ask_command_processor"
require_relative "./help_command_processor"

module Oracle
  module CommandProcessors
    class OracleCommandProcessor

      def self.execute(command)
        if command.help_command?
          processor = HelpCommandProcessor.new(command)
          result = processor.process
        else
          case command.base_instruction
          when "add"
            processor = AddCommandProcessor.new(command)
            result = processor.process
          when "remove"
            processor = RemoveCommandProcessor.new(command)
            result = processor.process
          when "display"
            processor = DisplayCommandProcessor.new(command)
            result = processor.process
          when "ask"
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
      end

      def original
        response = ""
        puts "Message"
        puts event.message.inspect
        puts ""
        puts "Server"
        puts event.server.inspect
        puts ""
        puts "User"
        puts event.user.inspect

        result = Oracle::Validators::CommandValidator.validate(event)
        if result[:valid]
          response = "will soon manage a oracle!"
        else
          build_help_message(event)
        end
      end
    end
  end
end
