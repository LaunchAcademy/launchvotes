module Admin
  class AdminController < ApplicationController
    abstract!

    before_action :authorize_user!

    def authorize_user!
      unless current_user && current_user.admin?
        render file: 'public/404.html', status: :not_found, layout: false
      end
    end
  end
end
