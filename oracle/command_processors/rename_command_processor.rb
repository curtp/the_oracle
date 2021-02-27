module Oracle
  module CommandProcessors
    class RenameCommandProcessor < BaseCommandProcessor

      def child_process(result)
        list.name = command.new_name
        list.save

        command.event << "Renamed #{command.list_name} to #{command.new_name}"
        OracleLogger.log.debug {"RemoveCommandProcessor.process: returning result: #{result}"}
      end

    end
  end
end
