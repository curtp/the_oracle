module Oracle
  module CommandProcessors
    class RemoveCommandProcessor < BaseCommandProcessor

      def child_process(result)

        if command.instructions.size == 2
          remove_entire_list(list)
          command.event << "Removed list #{list.name} from the Oracle"
        elsif command.instructions.size == 4
          remove_entry_from_list(list)
          command.event << "Removed #{command.entry} from the list #{command.list_name}"
          print_list(list)
        end
      end

      private

      def remove_entire_list(list)
        Oracle::Models::List.where(id: list.id).destroy_all
      end

      def remove_entry_from_list(list)
        number = number_or_nil(command.entry)
        if number.present?
          list.remove_entry_by_number(command.entry.to_i)
        else
          list.remove_entry(command.entry)
        end
        list.save
      end

    end
  end
end
