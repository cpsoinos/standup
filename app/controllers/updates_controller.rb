class UpdatesController < ApplicationController

  def create
    @update = Update.new(update_params)
  end

  protected

  def update_params
    params.require(:update).permit([:category, :contact_id, :content, :user_id, :photo, :remote_photo_url])
  end

end
