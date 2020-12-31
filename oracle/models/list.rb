require_relative "./base_model"

module Oracle
  module Models
    class List < ActiveRecord::Base

      LIST_NAME_MAX_LENGTH = 50
      ENTRY_MAX_LENGTH = 50

      serialize :entries, Array

      before_save :before_save_processing

      def add_entry(entry)
        if entries.nil?
          self.entries = []
        end
        entries.push(entry.slice(0...ENTRY_MAX_LENGTH))
      end

      def remove_entry(entry)
        if !entries.nil?
          entries.reject! {|list_entry| list_entry.strip.downcase.eql?(entry.strip.downcase)}
        end
      end

      # Removes all lists associated to a server
      def self.remove_all_lists_for_server(server_id)
        Oracle::Models::List.where(server_id: server_id).destroy_all
      end

      private

      def before_save_processing
        self.name = self.name.slice(0...LIST_NAME_MAX_LENGTH)
        # Count the number of lists for the server
        if new_record?
          count = List.where(server_id: self.server_id).count + 1
          self.number = count
        end
      end

    end
  end
end
