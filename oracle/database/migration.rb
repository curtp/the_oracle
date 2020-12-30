module Oracle
  module Database
    class Migration < ActiveRecord::Migration[5.2]
      def up
        if !table_exists?(:lists)
          create_table :lists do |table|
            table.string :name
            table.string :server_id
            table.text :entries
            table.integer :lock_version
            table.timestamps
            table.index :server_id
            table.index :name
          end
        end
      end

      def down
        drop_table :lists
      end
    end
  end
end
