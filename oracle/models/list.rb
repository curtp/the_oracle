require_relative "./base_model"
require "dynamoid"

module Oracle
  module Models
    class List < BaseModel
      include Dynamoid::Document
      include EasyLogging

      # Sort index on name
      field :name
      range :search_name, :string
      field :server_id
      field :entries, :array, of: :string
      field :lock_version, :integer

      # Secondary index on server_id
      global_secondary_index hash_key: :server_id, projected_attributes: :all

      before_save :set_search_name

      def add_entry(entry)
        if entries.nil?
          self.entries = []
        end
        entries.push(entry)
      end

      def remove_entry(entry)
        if !entries.nil?
          entries.reject! {|list_entry| list_entry.strip.downcase.eql?(entry.strip.downcase)}
        end
      end

      private

      def set_search_name
        logger.debug("setting search name")
        self.search_name = self.name.strip.downcase
      end

    end
  end
end
