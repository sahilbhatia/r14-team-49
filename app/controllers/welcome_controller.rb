class WelcomeController < ApplicationController
  def index
    @members = TEAM_MEMBERS
  end
end
