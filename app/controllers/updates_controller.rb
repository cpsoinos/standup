class UpdatesController < ApplicationController

  def create
    MailerJob.perform_later(collect_updates)
    redirect_to root_path
  end

  protected

  def update_params
    params.require(:update).permit(category: [], contact_id: [], content: [], user_id: [], photo: [], remote_photo_url: [])
  end

  def parse_update_params
    count = update_params[:category].count
    update_count = 0
    updates = []

    until update_count == count
      updates << Update.new(
        category: update_params[:category][update_count],
        contact_id: update_params[:contact_id][update_count],
        content: update_params[:contact_id][update_count]
      )
      update_count += 1
    end
    updates
  end

  def collect_updates
    ids = []
    parse_update_params.each do |update|
      update.save!
      ids << update.id
    end
  end

end
