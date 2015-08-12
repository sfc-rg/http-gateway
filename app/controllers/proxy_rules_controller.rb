class ProxyRulesController < ApplicationController
  include ReverseProxy::Controller

  before_action :require_current_user, except: :filter
  before_action :set_proxy_rule, only: [:show, :edit, :update, :destroy]

  WIDE_IPADDR_RANGE = '203.178.0.0/16'

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
    if @proxy_rule.update(proxy_rule_params)
      redirect_to proxy_rules_path, notice: 'ユーザ登録しました'
    else
      render 'edit'
    end
  end

  def destroy
  end

  def filter
    @proxy_rule = ProxyRule.active.find_by(domain: domain.subdomain)
    if @proxy_rule.blank?
      redirect_to domain.original_url(proxy_rules_path)
      return
    end

    if @proxy_rule.intranet? && !request_from_wide?
      redirect_to domain.original_url(root_path)
      return
    end

    if @proxy_rule.slack_auth? && current_user.blank?
      redirect_to domain.original_url(auth_path(:slack))
      return
    end

    if @proxy_rule.https? != request.ssl?
      redirect_to @proxy_rule.link_url + request.path
      return
    end

    require 'addressable/template'
    reverse_proxy @proxy_rule.url
  end

  private

  def require_current_user
    redirect_to domain.original_url(auth_path(:slack)) if current_user.blank?
  end

  def set_proxy_rule
    @proxy_rule = ProxyRule.active.find_by(id: params[:id])

    if @proxy_rule.blank?
      redirect_to status: :not_found
      return
    end

    if @proxy_rule.user != current_user && current_user.normal_user?
      redirect_to status: :forbidden
      return
    end
  end

  def proxy_rule_params
    params.require(:proxy_rule).permit(:name, :domain, :url, :auth_type, :https, :expired_at)
  end

  def request_from_wide?
    IPAddr.new(WIDE_IPADDR_RANGE).include?(IPAddr.new(request.ip))
  end
end
