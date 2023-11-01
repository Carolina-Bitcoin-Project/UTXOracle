require 'typhoeus'

class Request
  def self.send(domain, method = :get, body = '', params = {}, headers = {})
    request = Typhoeus::Request.new(
      domain,
      method:,
      body:,
      params:,
      headers:
    )

    request.run
    request.response
  end
end
