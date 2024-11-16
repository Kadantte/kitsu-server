require 'update_in_batches'

class AddFlagsToUsers < ActiveRecord::Migration[6.1]
  using UpdateInBatches

  self.disable_ddl_transaction!

  def up
    add_column :users, :flags, :integer
    say_with_time 'Filling flags column' do
      User.all.update_in_batches(flags: 0)
    end
    change_column_null :users, :flags, false, 0
    change_column_default :users, :flags, 0
  end

  def down
    remove_column :users, :flags
  end
end
