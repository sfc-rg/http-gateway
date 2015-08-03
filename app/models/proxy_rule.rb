class ProxyRule < ActiveRecord::Base
  belongs_to :user

  enum :auth_type, { none: 0, intranet: 1, slack: 2 }
end
