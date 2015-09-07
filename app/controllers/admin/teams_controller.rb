module Admin
  class TeamsController < AdminController
    before_action :get_team, only: [:show, :edit, :update]

    def index
      @teams = Team.all
    end

    def show
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

    private

    def get_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :enrolling)
    end
  end
end
