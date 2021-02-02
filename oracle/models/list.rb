require_relative "./base_model"

module Oracle
  module Models
    class List < ActiveRecord::Base

      LIST_NAME_MAX_LENGTH = 50
      ENTRY_MAX_LENGTH = 100

      serialize :entries, Array

      before_save :before_save_processing
      after_initialize :convert_entries_to_hash

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

      def total_weight
        @total_weight ||= entries.inject(0){|sum,x| sum + x[:weight] }
      end

      # Selects a random entry from the list of entries
      def select_entry
        exploded_entries = []
        OracleLogger.log.debug("looping over entries: #{entries.inspect}")
        entries.each do |entry|
          OracleLogger.log.debug("entry: #{entry}")
          (1..entry[:weight]).each do
            exploded_entries.push entry
          end
        end
        OracleLogger.log.debug("exploded_entries: #{exploded_entries.inspect}")
        exploded_entries.shuffle.sample
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

      # When loading the list, convert all entries to a hash if they haven't
      # been converted already
      def convert_entries_to_hash
        return if entries.empty?
        return if entries.first.is_a?(Hash)
        # Default the weight to 1.0. Users can add entries with a different
        # weight
        entries.map! {|entry| {value: entry, weight: rand(1..5).to_f}}
      end

    end
  end
end
