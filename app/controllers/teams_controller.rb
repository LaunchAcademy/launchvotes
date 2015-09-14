class TeamsController < ApplicationController
  before_action :authenticate_user!

  def show
    @team = Team.find(params[:id])
    @nomination = Nomination.new
    @nominee_options = @team.memberships.all_except(current_user).select_options
    @nominations = @team.nominations.current_week.visible_to(current_user)
  end
end
