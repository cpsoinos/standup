class UpdatesController < ApplicationController

  def create
    binding.pry
    @update = Update.new(update_params)
    if @update.save
      flash[:notice] = "Sent!"
      redirect_to home_path
    else
      flash[:alert] = "ERROR!"
      redirect_to :back
    end
  end

  protected

  def update_params
    params.require(:update).permit([:category, :contact_id, :content, :user_id, :photo, :remote_photo_url])
  end

end
