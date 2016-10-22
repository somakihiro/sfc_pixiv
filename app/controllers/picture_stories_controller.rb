class PictureStoriesController < ApplicationController
  def new
    @picture_story = PictureStory.new
    3.times { @picture_story.picture_story_orders.build }
  end

  def create
    @picture_story = PictureStory.create(picture_story_params)
    binding.pry
    redirect_to @picture_story
  end

  def show
    @picture_story = PictureStory.find(params[:id])
  end

  private

    def picture_story_params
      params.require(:picture_story).permit(:title, picture_story_orders_attributes: [:id, :story, :image, :_destroy])
    end
end
