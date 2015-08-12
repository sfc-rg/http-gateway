class User < ActiveRecord::Base
  has_one :slack_credential
  has_many :proxy_rules

  enum role: { normal_user: 0, manage_user: 1, super_user: 2 }
end
