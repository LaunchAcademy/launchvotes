module Admin
  class TeamMembershipsController < AdminController
    def create
      @team = Team.find(params[:team_id])
      @team_membership = @team.memberships.new(team_membership_params)
      @team_membership.save
      flash[:notice] = "Team Membership Created!"
      redirect_to admin_team_path(@team)
    end

    def destroy
      @team_membership = TeamMembership.find(params[:id])
      @team = @team_membership.team
      @user = @team_membership.user
      if @user.teams.count == 1
        flash[:alert] = "User Not Removed From Team. User Must Belong To At Least One Team"
      else
        @team_membership.destroy
        flash[:notice] = "User Removed From Team"
      end
      redirect_to admin_team_path(@team)
    end

    private

    def team_membership_params
      params.require(:team_membership).permit(:user_id)
    end
  end
end
