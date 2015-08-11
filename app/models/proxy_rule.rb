class ProxyRule < ActiveRecord::Base
  VALID_DOMAIN_REGEX = /\A(?:[A-Za-z0-9][A-Za-z0-9\-]{0,61}[A-Za-z0-9]|[A-Za-z0-9])\z/
  TARGET_IPADDR_RANGE = '2001:200:0:889c::/64'

  belongs_to :user

  validates :name, presence: true
  validates :domain, format: { with: VALID_DOMAIN_REGEX }, uniqueness: true
  validates :url, format: { with: /\Ahttps?:/ }
  validate do
    require 'addressable/uri'
    target_addr = IPAddr.new(Addressable::URI.parse(self.url).hostname)
    unless IPAddr.new(TARGET_IPADDR_RANGE).include?(target_addr)
      errors.add(:url, :has_invalid_target)
    end
  end
  enum auth_type: { open: 0, intranet: 1, slack_auth: 2 }

  scope :active, -> { where('expired_at IS NULL OR expired_at < ?', Time.now) }

  def link_url
    "#{self.https? ? 'https' : 'http'}://#{self.domain}.#{Domain::BASE_DOMAIN}"
  end
end
