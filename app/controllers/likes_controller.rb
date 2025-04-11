class LikesController < ApplicationController
  before_action :authenticate_user!  # Make sure only signed-in users can like/unlike

  def create
    @photo = Photo.find(params[:photo_id])
    @like = @photo.likes.build(fan_id: current_user.id)
    if @like.save
      redirect_back fallback_location: feed_path(current_user.username)
    else
      redirect_back fallback_location: feed_path(current_user.username), alert: "Unable to like photo."
    end
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @like = @photo.likes.find(params[:id])
    @like.destroy
    redirect_back fallback_location: feed_path(current_user.username)
  end
end
