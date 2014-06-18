require 'spec_helper'

describe ReservationsController do

  describe "GET 'express_checkout'" do
    it "returns http success" do
      get 'express_checkout'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

end
