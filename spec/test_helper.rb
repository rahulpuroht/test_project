require 'rails_helper'

RSpec.describe "Welcome", type: :request do
  

  	it "should have the right title" do
      get '/'
    end

    it "should have the right url" do
      get '/home'
    end

end
