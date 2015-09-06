class NominationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @nominees = User.nominees(current_user)
  end
end
