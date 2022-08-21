class EmailConfirmationsController < Devise::ConfirmationsController
  skip_authorization_check

  def new; end

  def create
    password = Devise.friendly_token[0, 20]
    user = User.create(email: email, password: password, password_confirmation: password)

    if user.persisted?
      user.send_confirmation_instructions
    else
      render :new
    end
  end

  private

  def email
    params.require(:email)
  end

  def after_confirmation_path_for(resource_name, user)
    user.authorizations.create(auth)
    sign_in user, event: :authentication
    signed_in_root_path user
  end

  def auth
    @auth ||= { provider: session['devise.provider'], uid: session['devise.uid'] }
  end
end
