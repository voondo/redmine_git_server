require "spec_helper"

describe GitServerController, :type => :controller do

  fixtures :roles, :users

  before do
    @request.session[:user_id] = 1 # Admin
    User.current = User.find(1)
    Setting.default_language = 'en'
  end

  it "should be tested (FIXME)" do
  end

end
