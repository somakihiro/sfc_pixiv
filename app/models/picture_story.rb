class PictureStory < ActiveRecord::Base
  has_many :picture_story_orders
  accepts_nested_attributes_for :picture_story_orders, allow_destroy: true
end
