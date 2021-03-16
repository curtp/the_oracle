module Oracle
  module Database
    class Seeder

      def seed(server_id)
        # Add the even odds list
        list_hash = {server_id: server_id, name: "Odds - Even",
          entries: [{name: "No, and complication", weight: 1},
            {name: "No", weight: 1}, {name: "No, but benefit", weight: 1},
            {name: "Yes, but complication", weight: 1}, {name: "Yes", weight: 1}, 
            {name: "Yes, and benefit", weight: 1}]
        }
        add_list(list_hash)

        # Create the Likely list
        list_hash = {server_id: server_id, name: "Odds - Likely",
          entries: [{name: "No", weight: 1}, {name: "No, but benefit", weight: 1},
            {name: "Yes, but complication", weight: 1}, {name: "Yes", weight: 2}, 
            {name: "Yes, and benefit", weight: 1}]
        }
        add_list(list_hash)

        # Create the Unlikely list
        list_hash = {server_id: server_id, name: "Odds - Unlikely",
          entries: [{name: "No, and complication", weight: 1}, {name: "No", weight: 2},
            {name: "No, but benefit", weight: 1}, {name: "Yes, but complication", weight: 1},
            {name: "Yes", weight: 1}]
        }
        add_list(list_hash)
      end

      private

      def add_list(list_hash)
        list = Oracle::Models::List.new(server_id: list_hash[:server_id],
          name: list_hash[:name])
        list_hash[:entries].each do |entry|
          OracleLogger.log.debug("adding entry to list: #{entry}")
          list.add_entry(entry[:name], entry[:weight])
        end
        list.save
      end

    end
  end
end
