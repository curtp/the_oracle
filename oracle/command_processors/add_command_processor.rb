module Oracle
  module CommandProcessors
    class AddCommandProcessor < BaseCommandProcessor

      def child_process(result)
        # Look for an existing list
        self.list = find_list
        # If there isn't an existing list, create a new one
        self.list = new_list if !self.list.present?
        self.list.add_entry(command.entry)
        self.list.save
        OracleLogger.log.debug {"AddCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
