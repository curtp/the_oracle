require_relative "./base_model"
require "dynamoid"

module Oracle
  module Models
    class List < BaseModel
      include Dynamoid::Document
      include EasyLogging

      LIST_NAME_MAX_LENGTH = 50
      ENTRY_MAX_LENGTH = 50

      # Sort index on name
      field :name
      range :search_name, :string
      field :server_id
      field :entries, :array, of: :string
      field :lock_version, :integer

      # Secondary index on server_id
      global_secondary_index hash_key: :server_id, projected_attributes: :all

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

      private

      def before_save_processing
        logger.debug {"name before slice: #{self.name}"}
        self.name = self.name.slice(0...LIST_NAME_MAX_LENGTH)
        logger.debug {"name after slice: #{self.name}"}
        self.search_name = self.name.strip.downcase
        logger.debug {"search name: #{self.search_name}"}
      end

    end
  end
end
