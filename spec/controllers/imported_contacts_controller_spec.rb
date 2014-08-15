require 'spec_helper'

describe ImportedContactsController do

  describe "GET 'authenticate'" do
    it "returns http success" do
      get 'authenticate'
      response.should be_success
    end
  end

  describe "GET 'authorise'" do
    it "returns http success" do
      get 'authorise'
      response.should be_success
    end
  end

  describe "GET 'import'" do
    it "returns http success" do
      get 'import'
      response.should be_success
    end
  end

end
