class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!

  def show
    @awards = current_user.nominations.previous_weeks.awards
  end

  private

  def authorize_user!
    user = User.find(params[:id])
    unless current_user == user || current_user.admin?
      flash[:alert] = "You Are Not Authorized To View The Page"
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
