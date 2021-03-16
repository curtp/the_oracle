module Oracle
  module CommandProcessors
    class FilterCommandProcessor < BaseCommandProcessor

      def child_process(result)

        result = display_server_lists_matching(command.name)

        OracleLogger.log.debug {"FilterCommandProcessor.process: returning result: #{result}"}
      end

      private

      def display_server_lists_matching(name)
        OracleLogger.log.debug {"FilterCommandProcessor: displaying server lists matching #{command.name}"}
        result = {success: true, error_message: nil}
        OracleLogger.log.debug {"FilterCommandProcessor: retrieving server lists"}
        lists = server_lists.where(["name like ?", "#{name}%"])
        if !lists.present?
          OracleLogger.log.debug {"FilterCommandProcessor: no lists... returning an error"}
          result[:success] = false
          result[:error_message] = "No lists found"
          return result
        end
        OracleLogger.log.debug {"FilterCommandProcessor: got server lists: #{lists.size}"}
        print_server_lists(lists)
        return result
      end

    end
  end
end
