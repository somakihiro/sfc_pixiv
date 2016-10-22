class AddPictureStoriesRefToPictureStoryOrders < ActiveRecord::Migration
  def change
    add_reference :picture_story_orders, :picture_story, index: true, foreign_key: true
  end
end
