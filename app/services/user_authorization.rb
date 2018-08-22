class UserAuthorization
  AUTHORIZATION_KEY = 'HTTP_API_TOKEN'.freeze

  attr_reader :errors, :result

  def initialize(request_header)
    @request_header = request_header
    @errors = []
  end

  def self.call(request_header)
    new(request_header).tap do |service|
      service.instance_variable_set("@result", service.call)
      service.instance_variable_set("@error", service.errors)
    end
  end

  def call
    user
  end

  private

  attr_reader :request_header

  def user
    @user ||= User.find_by(token: auth_header_token)
    unless @user
      errors << 'Not Authorized'
    end
    @user
  end

  def auth_header_token
    if request_header[AUTHORIZATION_KEY].present?
      return request_header[AUTHORIZATION_KEY]
    else
      errors << 'Missing token'
    end
  end
end
