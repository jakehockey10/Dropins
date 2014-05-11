require "spec_helper"

describe RinksController do
  describe "routing" do

    it "routes to #index" do
      get("/rinks").should route_to("rinks#index")
    end

    it "routes to #new" do
      get("/rinks/new").should route_to("rinks#new")
    end

    it "routes to #show" do
      get("/rinks/1").should route_to("rinks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rinks/1/edit").should route_to("rinks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rinks").should route_to("rinks#create")
    end

    it "routes to #update" do
      put("/rinks/1").should route_to("rinks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rinks/1").should route_to("rinks#destroy", :id => "1")
    end

  end
end
