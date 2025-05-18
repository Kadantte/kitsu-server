class MakeBumpedAtOnPostsNonNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_default :posts, :bumped_at, -> { 'CURRENT_TIMESTAMP' }
    change_column_null :posts, :bumped_at, false
  end
end
