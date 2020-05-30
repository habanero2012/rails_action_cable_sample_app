module RequestMacros
  def login_as(user)
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: user.id)
  end
end

RSpec.configure do |config|
  config.include RequestMacros, type: :request
end