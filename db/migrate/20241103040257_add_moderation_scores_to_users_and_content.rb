class AddModerationScoresToUsersAndContent < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :moderation_scores, :jsonb
    add_column :posts, :moderation_scores, :jsonb
    add_column :comments, :moderation_scores, :jsonb
    add_column :media_reactions, :moderation_scores, :jsonb
  end
end
