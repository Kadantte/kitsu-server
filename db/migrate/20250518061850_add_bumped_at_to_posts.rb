class AddBumpedAtToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :bumped_at, :datetime
  end
end
