class IndexHeldReasons < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :posts, :held_reason, algorithm: :concurrently
    add_index :comments, :held_reason, algorithm: :concurrently
    add_index :media_reactions, :held_reason, algorithm: :concurrently
  end
end
