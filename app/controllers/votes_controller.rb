class VotesController < ApplicationController
  def create
    @nomination = Nomination.find(params[:nomination_id])
    Vote.find_or_create_by(nomination: @nomination, voter: current_user)
    flash[:notice] = "Vote Cast!"
    redirect_to team_path(@nomination.team)
  end
end
