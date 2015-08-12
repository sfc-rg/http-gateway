class SessionController < ApplicationController
  def slack_callback
    auth = request.env['omniauth.auth']

    credential = SlackCredential.find_or_initialize_by(slack_user_id: auth.info.user_id)
    user = if credential.new_record?
      User.create(email: auth.info.email,
                  name: auth.info.name,
                  nickname: auth.info.nickname,
                  icon_url: auth.extra.user_info.user.profile.image_192,
                  slack_credential: credential)
    else
      credential.user
    end

    session[:user_id] = user.id

    state = request.env['omniauth.params']['state']
    if state
      proxy_rule = ProxyRule.active.find_by(domain: state)
      redirect_to proxy_rule.link_url
    else
      redirect_to root_path
    end
  end
end
