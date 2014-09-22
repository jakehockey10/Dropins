json.array!(@page_requests) do |page_request|
  json.extract! page_request, :id, :path, :page_duration, :view_duration, :db_duration, :index
  json.url page_request_url(page_request, format: :json)
end
