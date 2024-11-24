class AddHeldReasonToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :held_reason, :integer
    add_column :comments, :held_reason, :integer
    add_column :media_reactions, :held_reason, :integer
  end
end
