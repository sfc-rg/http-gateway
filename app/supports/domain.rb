class Domain
  BASE_DOMAIN = Rails.env.production? ? 'gw.sfc.wide.ad.jp' : 'lvh.me'

  def initialize(request)
    @request = request
  end

  def original_url(path, options = {})
    options = {
      ssl: @request.ssl?
    }.merge(options)

    "#{options[:ssl] ? 'https' : 'http'}://#{BASE_DOMAIN}:#{@request.server_port}#{path}"
  end

  def subdomain
    @request.host.gsub(/\.?#{BASE_DOMAIN}/, '')
  end

  def subdomain_request?
    self.subdomain.present?
  end
end
