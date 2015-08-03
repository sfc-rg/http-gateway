class User < ActiveRecord::Base
  has_one :slack_credential
  has_many :proxy_rules
end
