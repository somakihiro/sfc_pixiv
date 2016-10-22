class CreatePictureStories < ActiveRecord::Migration
  def change
    create_table :picture_stories do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
