module Oracle
  module Database
    class Seeder

      def seed(server_id)
        # Add the even odds list
        list_hash = {server_id: server_id, name: "Odds - Even",
          entries: ["No, and complication",
            "No", "No, but benefit", "Yes, but complication", "Yes", "Yes, and benefit"]
        }
        add_list(list_hash)

        # Create the Likely list
        list_hash = {server_id: server_id, name: "Odds - Likely",
          entries: ["No",
            "No, but benefit", "Yes, but complication", "Yes", "Yes", "Yes, and benefit"]
        }
        add_list(list_hash)

        # Create the Unlikely list
        list_hash = {server_id: server_id, name: "Odds - Unlikely",
          entries: ["No, and complication",
            "No", "No", "No, but benefit", "Yes, but complication", "Yes"]
        }
        add_list(list_hash)
      end

      private

      def add_list(list_hash)
        list = Oracle::Models::List.new(server_id: list_hash[:server_id],
          name: list_hash[:name])
        list_hash[:entries].each do |entry|
          list.add_entry(entry)
        end
        list.save
      end

    end
  end
end
