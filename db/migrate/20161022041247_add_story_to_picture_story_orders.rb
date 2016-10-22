class AddStoryToPictureStoryOrders < ActiveRecord::Migration
  def change
    add_column :picture_story_orders, :story, :text
    add_column :picture_story_orders, :image, :string
  end
end
