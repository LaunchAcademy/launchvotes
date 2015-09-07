module Admin
  class TeamsController < AdminController
    def index
      @teams = Team.all
    end

    def show
      @team = Team.find(params[:id])
    end
  end
end
