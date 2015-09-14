class NominationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @nominees = User.nominees(current_user)
  end

  def create
    @team = Team.find(params[:team_id])
    @nomination = Nomination.new(nomination_params)
    @nomination.nominator = current_user
    if @nomination.save
      flash[:notice] = "Nomination Created!"
      redirect_to team_path(@team)
    else
      flash[:alert] = "Nomination Not Created."
      @nominee_options = @team.memberships.all_except(current_user).select_options
      @nominations = @team.nominations.current_week.visible_to(current_user)
      render :'teams/show'
    end
  end

  private

  def nomination_params
    params.require(:nomination).permit(:nominee_membership_id, :body)
  end
end
