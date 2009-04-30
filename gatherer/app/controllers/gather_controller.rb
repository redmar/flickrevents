class GatherController < ApplicationController
  def index
    @gather_sessions = GatherSession.find(:all)
    @photo_count = Photo.count(:all)
  end

end
