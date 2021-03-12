module Oracle
  module Models
    class List < ActiveRecord::Base

      LIST_NAME_MAX_LENGTH = 50
      ENTRY_MAX_LENGTH = 100

      serialize :entries, Array

      before_save :before_save_processing
      after_initialize :add_missing_attributes

      def add_entry(entry, weight)
        if entries.nil?
          self.entries = []
        end
        entries.push({name: entry.slice(0...Oracle.config[:max_entry_length]), weight: weight})
        entries.sort_by! {|entry| entry[:name]}
      end

      def remove_entry_by_number(number)
        # Subtract 1 from the number so it is 0 based
        number -= 1
        return if number > entries.size || number < 0
        entries.delete_at(number)
      end

      def remove_entry(entry)
        if !entries.nil?
          entries.reject! {|list_entry| list_entry[:name].strip.downcase.eql?(entry.strip.downcase)}
        end
      end

      # Removes all lists associated to a server
      def self.remove_all_lists_for_server(server_id)
        Oracle::Models::List.where(server_id: server_id).destroy_all
      end

      def select_answer
        blown_out_entries = []
        entries.each do |entry|
          entry[:weight].to_i.times do
            blown_out_entries.push(entry[:name])
          end
        end
        OracleLogger.log.debug(blown_out_entries.inspect)
        blown_out_entries.shuffle.sample
      end

      private

      def next_number
        max_number = List.where(server_id: self.server_id).maximum(:number) || 0
        max_number + 1
      end

      def before_save_processing
        self.name = self.name.slice(0...LIST_NAME_MAX_LENGTH)
        # Count the number of lists for the server
        if new_record?
          self.number = next_number
        end
      end

      def add_missing_attributes
        return if entries.empty?
        return if entries.first.is_a?(Hash)
        entries.map! {|entry| entry = {name: entry, weight: 1}}
      end

    end
  end
end
