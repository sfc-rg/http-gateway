class ProxyRulesController < ApplicationController
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
      redirect_to @proxy_rule, notice: 'ユーザ登録しました'
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if ProxyRule.update(proxy_rule_params)
      redirect_to @proxy_rule, notice: 'ユーザ登録しました'
    else
      render 'edit'
    end
  end

  def destroy
  end

  private

  def set_proxy_rule
    @proxy_rule = ProxyRule.find_by(id: params[:id])
    redirect_to status: :not_found if @proxy_rule.blank?
    redirect_to status: :forbidden if @proxy_rule.user != current_user
  end

  def proxy_rule_params
    params.require(:proxy_rule).permit(:name, :domain, :url, :expired_at)
  end
end
