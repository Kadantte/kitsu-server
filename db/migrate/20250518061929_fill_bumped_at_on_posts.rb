class FillBumpedAtOnPosts < ActiveRecord::Migration[6.1]
  using UpdateInBatches
  disable_ddl_transaction!

  def up
    Post.unscoped.all.update_in_batches(<<~SQL.squish)
      bumped_at = coalesce(
        (
          SELECT created_at
          FROM comments
          WHERE comments.post_id = posts.id
            AND comments.parent_id IS NULL
            AND comments.deleted_at IS NULL
          ORDER BY id DESC LIMIT 1
        ),
        posts.created_at
      )
    SQL
  end

  def down
    Post.all.update_in_batches(bumped_at: nil)
  end
end
