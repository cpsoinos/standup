class StandupsController < ApplicationController

  def create
    @standup = Standup.new(standup_params)
  end

  protected

  def standup_params
    params.require(:standup).permit([:personal_updates, :work_updates])
  end

end
