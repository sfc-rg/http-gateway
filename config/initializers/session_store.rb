# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Rails.application.config.session_store :cookie_store, key: '_http-gateway_session', domain: '.sfc.widead.jp'
else
  Rails.application.config.session_store :cookie_store, key: '_http-gateway_session'
end
