module Oracle
  module CommandProcessors
    class RenumberCommandProcessor < BaseCommandProcessor

      def child_process(result)
        server.renumber_lists

        command.event << "Lists have been renumbered"
        OracleLogger.log.debug {"RemoveCommandProcessor.process: returning result: #{result}"}
      end

    end
  end
end
