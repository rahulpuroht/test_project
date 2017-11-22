require 'rails_helper'

RSpec.describe "Welcome", type: :request do
  

  it "should have the right title" do
      get '/home'
    end

end
