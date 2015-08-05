Rails.application.routes.draw do
  scope constraints: lambda { |r| !sub_domain?(r) }, via: :all do
    root 'static#index'
    match '/auth/:provider', to: lambda{ |env| [404, {}, ['Not Found']] }, as: 'auth'
    get '/auth/slack/callback' => 'session#slack_callback'

    resources :proxy_rules
  end

  scope constraints: lambda { |r| sub_domain?(r) }, via: :all do
    get '/' => 'proxy_rules#filter'
    match '/*path', to: 'proxy_rules#filter'
  end

  def sub_domain?(request)
    Domain.new(request).subdomain_request?
    # domain = request.subdomain.gsub(ProxyRule::SFC_GATEWAY_DOMAIN_REGEX, '') # sfc.widead.jp
    # if domain.present? || domain == 'www'
    #   true
    # else
    #   false
    # end
  end
end
