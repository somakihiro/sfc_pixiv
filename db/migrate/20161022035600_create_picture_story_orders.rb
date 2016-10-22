class CreatePictureStoryOrders < ActiveRecord::Migration
  def change
    create_table :picture_story_orders do |t|

      t.timestamps null: false
    end
  end
end
