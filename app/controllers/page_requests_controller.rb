class PageRequestsController < ApplicationController

  # GET /page_requests
  # GET /page_requests.json
  def index
    @page_requests = PageRequest.all
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_request_params
      params.require(:page_request).permit(:path, :page_duration, :view_duration, :db_duration, :index)
    end
end
