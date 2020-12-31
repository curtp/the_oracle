require_relative "./base_command_processor"
require_relative "../models/server"

module Oracle
  module CommandProcessors
    class RenumberCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        OracleLogger.log.debug { "RenumberCommandProcessor.process: validation result: #{validation_result}" }
        if validation_result[:valid]
          server = Oracle::Models::Server.where(server_id: command.event.server.id).first

          if !server.present?
            result[:success] = false
            result[:error_message] = "Server not found"
            return result
          end

          server.renumber_lists

          command.event << "Lists have been renumbered"
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        OracleLogger.log.debug {"RemoveCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
