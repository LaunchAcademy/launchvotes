class TeamsController < ApplicationController
  before_action :authenticate_user!

  def show
    @team = Team.find(params[:id])
    @nominations = @team.nominations.current_week.visible_to(current_user)
  end
end
