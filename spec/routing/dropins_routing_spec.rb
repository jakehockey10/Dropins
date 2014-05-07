require "spec_helper"

describe DropinsController do
  describe "routing" do

    it "routes to #index" do
      get("/dropins").should route_to("dropins#index")
    end

    it "routes to #new" do
      get("/dropins/new").should route_to("dropins#new")
    end

    it "routes to #show" do
      get("/dropins/1").should route_to("dropins#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dropins/1/edit").should route_to("dropins#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dropins").should route_to("dropins#create")
    end

    it "routes to #update" do
      put("/dropins/1").should route_to("dropins#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dropins/1").should route_to("dropins#destroy", :id => "1")
    end

  end
end
