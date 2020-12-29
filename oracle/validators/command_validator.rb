module Oracle
  module Validators
    class CommandValidator
      def self.validate(command)
        puts "instruction size: #{command.instructions.size}"
        if command.instructions.size < 1
          return {valid: false, error_message: "Unknown command"}
        end

        case command.base_instruction
        when "add"
          validator = AddValidator.new(command)
        when "remove"
          validator = RemoveValidator.new(command)
        when "display"
          validator = DisplayValidator.new(command)
        when "ask"
          validator = AskValidator.new(command)
        else
          return {valid: false, error_message: "Unknown command"}
        end
        return validator.validate
      end

    end

    private

    class BaseValidator
      attr_accessor :command

      def initialize(command)
        self.command = command
      end

      def validate
        return {valid: true, error_message: ""}
      end
    end

    class AddValidator < BaseValidator
      def validate
        puts "validating instructions: #{command.instructions}"
        puts "content: #{command.content}"
        if command.instructions.size != 4
          return {valid: false, error_message: "To add an answer to the list: add 'new entry' to 'list name'"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class RemoveValidator < BaseValidator
      def validate
        puts "validating instructions: #{command.instructions}"
        puts "content: #{command.content}"
        puts "instructions size: #{command.instructions.size}"
        if command.instructions.size != 4 && command.instructions.size != 2
          return {valid: false,
            error_message: "To remove an answer from the list: remove 'old entry' from 'list name'"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class DisplayValidator < BaseValidator
      def validate
        puts "validating instructions: #{command.instructions}"
        puts "content: #{command.content}"
        puts ""
        if command.instructions.size != 2 && command.instructions.size != 1
          return {valid: false,
            error_message: "To display a list: display 'list name'"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class AskValidator < BaseValidator
      def validate
        puts "validating instructions: #{command.instructions}"
        puts "content: #{command.content}"
        if command.instructions.size != 2 && command.instructions.size != 3
          return {valid: false,
            error_message: "To ask the Oracle a question: !oracle ask 'list name' ['question']"}
        end
        return {valid: true, error_message: ""}
      end
    end

  end
end
