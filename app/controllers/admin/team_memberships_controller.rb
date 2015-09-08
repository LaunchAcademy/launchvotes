module Admin
  class TeamMembershipsController < AdminController
    def create
      @team = Team.find(params[:team_id])
      @team_membership = @team.team_memberships.new(team_membership_params)
      @team_membership.save
      flash[:notice] = "Team Membership Created!"
      redirect_to admin_team_path(@team)
    end

    private

    def team_membership_params
      params.require(:team_membership).permit(:user_id)
    end
  end
end
