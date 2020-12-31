module Oracle
  module Database
    class Migration < ActiveRecord::Migration[5.2]
      def up
        if !table_exists?(:lists)
          create_table :lists do |table|
            table.string :name
            table.integer :number
            table.string :server_id
            table.text :entries
            table.integer :lock_version
            table.timestamps
            table.index :server_id
            table.index :name
          end
          add_index :lists, [:server_id, :name]
        end

        if !table_exists?(:servers)
          create_table :servers do |table|
            table.string :server_id
            table.string :server_name
            table.string :added_by_user
            table.datetime :removed_on
            table.string :removed_by_user
            table.index :server_id
            table.index :removed_on
            table.timestamps
          end
        end
      end

      def down
        drop_table :lists
        drop_table :servers
      end
    end
  end
end
