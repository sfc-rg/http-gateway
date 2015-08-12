module ProxyRulesHelper
  def editable_rule?(rule)
    rule.user == current_user || !current_user.normal_user?
  end
end
