class ProxyRule < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :domain, format: { with: /\A[a-z]([a-z0-9\.][a-z0-9])?\Z/ }
  validates :url, format: { with: /\Ahttp:/ }
  enum auth_type: { open: 0, intranet: 1, slack_auth: 2 }

  scope :active, -> { where('expired_at IS NULL OR expired_at < ?', Time.now) }
end
