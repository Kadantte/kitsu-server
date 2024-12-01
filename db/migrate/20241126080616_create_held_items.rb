class CreateHeldItems < ActiveRecord::Migration[6.1]
  def change
    create_view :held_items
  end
end
