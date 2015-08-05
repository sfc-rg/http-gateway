class AddForceHtmlToProxyRule < ActiveRecord::Migration
  def change
    add_column :proxy_rules, :https, :boolean, null: false, default: false
  end
end
