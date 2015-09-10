module Admin
  class TeamsController < AdminController
    before_action :get_team, only: [:show, :edit, :update, :destroy]

    def index
      @teams = Team.all
    end

    def show
      @team_membership = TeamMembership.new
    end

    def new
      @team = Team.new
    end

    def edit
    end

    def create
      @team = Team.new(team_params)

      if @team.save
        flash[:notice] = "Team Created!"
        redirect_to admin_team_path(@team)
      else
        flash[:alert] = "Team Not Created"
        render :new
      end
    end

    def update
      if @team.update(team_params)
        flash[:notice] = "Team Updated!"
        redirect_to admin_team_path(@team)
      else
        flash[:alert] = "Team Not Updated"
        render :edit
      end
    end

    def destroy
      if @team.destroy
        flash[:notice] = "Team Destroyed!"
      else
        flash[:alert] = "Team Not Destroyed. You Cannot Destroy An Enrolling Team"
      end
      redirect_to admin_teams_path
    end

    private

    def get_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :enrolling)
    end
  end
end
