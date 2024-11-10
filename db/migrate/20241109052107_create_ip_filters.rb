class CreateIPFilters < ActiveRecord::Migration[6.1]
  def change
    create_table :ip_filters do |t|
      t.integer :type, null: false
      t.text :pattern, null: false
      t.integer :actions, null: false
      t.timestamps null: false
    end
  end
end
