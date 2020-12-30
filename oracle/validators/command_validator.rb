module Oracle
  module Validators
    class CommandValidator
      include EasyLogging

      def self.validate(command)
        logger.debug {"instruction size: #{command.instructions.size}"}
        if command.instructions.size < 1
          return {valid: false, error_message: "Unknown command"}
        end

        logger.debug {"creating validator for command: #{command.base_instruction.downcase.strip}"}
        case command.base_instruction.downcase.strip
        when "add".freeze
          validator = AddValidator.new(command)
        when "remove".freeze
          validator = RemoveValidator.new(command)
        when "display".freeze, "list".freeze
          validator = DisplayValidator.new(command)
        when "ask".freeze
          validator = AskValidator.new(command)
        when "rename".freeze
          validator = RenameValidator.new(command)
        else
          return {valid: false, error_message: "Unknown command"}
        end
        return validator.validate
      end

    end

    private

    class BaseValidator
      include EasyLogging

      attr_accessor :command

      def initialize(command)
        self.command = command
      end

      def validate
        return {valid: true, error_message: ""}
      end
    end

    class AddValidator < BaseValidator
      include EasyLogging

      def validate
        logger.debug {"validating instructions: #{command.instructions}"}
        logger.debug {"content: #{command.content}"}
        if command.instructions.size != 4
          return {valid: false, error_message: "To add an answer to the list: add 'new entry' to 'list name'"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class RemoveValidator < BaseValidator
      include EasyLogging

      def validate
        logger.debug {"validating instructions: #{command.instructions}"}
        logger.debug {"content: #{command.content}"}
        logger.debug {"instructions size: #{command.instructions.size}"}
        if command.instructions.size != 4 && command.instructions.size != 2
          return {valid: false,
            error_message: "To remove an answer from the list: remove 'old entry' from 'list name'"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class DisplayValidator < BaseValidator
      include EasyLogging

      def validate
        logger.debug {"validating instructions: #{command.instructions}"}
        logger.debug {"content: #{command.content}"}
        if command.instructions.size != 2 && command.instructions.size != 1
          return {valid: false,
            error_message: "To display a list: display 'list name'"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class AskValidator < BaseValidator
      include EasyLogging

      def validate
        logger.debug {"validating instructions: #{command.instructions}"}
        logger.debug {"content: #{command.content}"}
        if command.instructions.size != 2 && command.instructions.size != 3
          return {valid: false,
            error_message: "To ask the Oracle a question: !oracle ask 'list name' ['question']"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class RenameValidator < BaseValidator
      include EasyLogging

      def validate
        logger.debug {"validating instructions: #{command.instructions}"}
        logger.debug {"content: #{command.content}"}
        if command.instructions.size != 4
          return {valid: false, error_message: "To rename a list: !oracle rename 'old name' to 'new name'"}
        end

        return {valid: true, error_message: ""}
      end
    end

  end
end
