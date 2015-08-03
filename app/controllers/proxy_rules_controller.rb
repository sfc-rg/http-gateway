class ProxyRulesController < ApplicationController
  include ReverseProxy::Controller

  before_action :require_current_user, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_proxy_rule, only: [:show, :edit, :update, :destroy]

  def index
    @proxy_rules = ProxyRule.active.all
  end

  def new
    @proxy_rule = ProxyRule.new
  end

  def create
    @proxy_rule = ProxyRule.new(proxy_rule_params.merge(user: current_user))
    if @proxy_rule.save
      redirect_to proxy_rules_path, notice: 'ユーザ登録しました'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if ProxyRule.update(proxy_rule_params)
      redirect_to proxy_rules_path, notice: 'ユーザ登録しました'
    else
      render 'edit'
    end
  end

  def destroy
  end

  def filter
    @proxy_rule = ProxyRule.find_by(domain: request.subdomain)

    require 'addressable/template'
    reverse_proxy @proxy_rule.url do |config|
      config.on_missing do |code, response|
        redirect_to root_url and return
      end
    end
  end

  private

  def require_current_user
    if current_user.blank?
      redirect_to auth_path(:slack)
    end
  end

  def set_proxy_rule
    @proxy_rule = ProxyRule.find_by(id: params[:id])

    if @proxy_rule.blank?
      redirect_to status: :not_found
      return
    end

    if @proxy_rule.user != current_user
      redirect_to status: :forbidden
      return
    end
  end

  def proxy_rule_params
    params.require(:proxy_rule).permit(:name, :domain, :url, :expired_at)
  end
end
