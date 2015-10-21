class HomeController < ApplicationController

  def index
    @standup = StandupNote.new
  end

end
