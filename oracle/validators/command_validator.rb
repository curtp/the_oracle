# frozen_string_literal: true
module Oracle
  module Validators
    class CommandValidator

      def self.validate(command)

        # Help command is always valid
        if command.help_command?
          return {valid: true, error_message: nil}
        end

        OracleLogger.log.debug {"CommandValidator: instruction size: #{command.instructions.size}"}
        if command.instructions.size < 1
          return {valid: false, error_message: "Unknown command"}
        end

        OracleLogger.log.debug {"CommandValidator: creating validator for command: #{command.base_instruction.downcase.strip}"}
        case command.base_instruction.downcase.strip
        when "add"
          validator = AddValidator.new(command)
        when "remove"
          validator = RemoveValidator.new(command)
        when "display", "list"
          validator = DisplayValidator.new(command)
        when "ask"
          validator = AskValidator.new(command)
        when "rename"
          validator = RenameValidator.new(command)
        when "renumber"
          validator = RenumberValidator.new(command)
        when "stats"
          validator = StatsValidator.new(command)
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

      def is_owner?
        command.event.server.owner.id.eql?(command.event.user.id)
      end

      def validate
        return {valid: true, error_message: ""}
      end
    end

    class AddValidator < BaseValidator

      def validate
        if !is_owner?
          return {valid: false,
            error_message: "Only server owners can add answers."}
        end

        if command.instructions.size != 5
          return {valid: false, error_message: "To add an answer to the list: add 'new entry' [weight] to 'list name'"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class RemoveValidator < BaseValidator

      def validate
        if !is_owner?
          return {valid: false,
            error_message: "Only server owners can remove answers or lists."}
        end

        if command.instructions.size != 4 && command.instructions.size != 2
          return {valid: false,
            error_message: "To remove an answer from the list: remove 'old entry' from 'list name'"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class DisplayValidator < BaseValidator

      def validate
        if command.instructions.size != 2 && command.instructions.size != 1
          return {valid: false,
            error_message: "To display a list: display 'list name'"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class AskValidator < BaseValidator

      def validate
        if command.instructions.size != 2 && command.instructions.size != 3
          return {valid: false,
            error_message: "To ask the Oracle a question: !oracle ask 'list name' ['question']"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class RenameValidator < BaseValidator

      def validate
        if !is_owner?
          return {valid: false,
            error_message: "Only server owners can rename lists."}
        end

        if command.instructions.size != 4
          return {valid: false, error_message: "To rename a list: !oracle rename 'old name' to 'new name'"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class RenumberValidator < BaseValidator

      def validate
        if !is_owner?
          return {valid: false,
            error_message: "Only server owners can renumber lists."}
        end

        if command.instructions.size != 1
          return {valid: false, error_message: "To renumber lists: !oracle renumber"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class StatsValidator < BaseValidator

      def validate
        OracleLogger.log.debug("instructions.size: #{command.instructions.size}")

        if !command.bot_owner?
          return {valid: false, error_message: "Command not available"}
        end
        return {valid: true, error_message: ""}
      end
    end

  end
end
