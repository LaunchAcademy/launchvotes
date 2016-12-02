class NominationsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_team, only: [:index, :create]
  before_action :get_nomination, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:index, :edit, :update, :destroy]

  def index
    @awards = []
    @team.nominations.current_week.awards.each { |award| @awards << award if award.votes.count > 3}
  end

  def edit
    @nominee_options = @nomination.
      team.memberships.all_except(current_user).select_options
  end

  def create
    @nomination = Nomination.new(nomination_params)
    @nomination.nominator = current_user
    if @nomination.save
      flash[:notice] = "Nomination Created!"
      redirect_to team_path(@team)
    else
      flash[:alert] = "Nomination Not Created."
      @nominee_options = @team.
        memberships.all_except(current_user).select_options
      @nominations = @team.nominations.current_week.visible_to(current_user)
      render :'teams/show'
    end
  end

  def update
    if @nomination.update(nomination_params)
      flash[:notice] = "Nomination Updated!"
      redirect_to team_path(@nomination.team)
    else
      flash[:alert] = "Nomination Not Updated."
      @nominee_options = @nomination.
        team.memberships.all_except(current_user).select_options
      render :edit
    end
  end

  def destroy
    @nomination.destroy
    flash[:notice] = "Nomination Deleted!"
    redirect_to team_path(@nomination.team)
  end

  private

  def get_team
    @team = Team.find(params[:team_id])
  end

  def get_nomination
    @nomination = Nomination.find(params[:id])
  end

  def authorize_user!
    unless user_authorized?
      flash[:alert] = "You Are Not Authorized To View The Page"
      redirect_to after_sign_in_path_for(current_user)
    end
  end

  def user_authorized?
    current_user.admin? ||
      (@nomination && @nomination.nominator == current_user)
  end

  def nomination_params
    params.require(:nomination).permit(:nominee_membership_id, :body)
  end
end
