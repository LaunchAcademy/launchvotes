class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      @user.update_from_omniauth(request.env["omniauth.auth"])
      flash[:notice] = "Signed in as #{@user.name}"
      sign_in_and_redirect @user
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      flash[:alert] = "Invalid credentials returned from Github"
      redirect_to root_path
    end
  end
end
