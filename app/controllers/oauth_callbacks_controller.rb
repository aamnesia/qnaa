class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('GitHub')
  end

  def vkontakte
    oauth('VK')
  end

  def oauth(provider)
    unless request.env['omniauth.auth'].info[:email]
      redirect_to new_user_confirmation_path
      return
    end

    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
