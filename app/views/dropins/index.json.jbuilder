json.array!(@dropins) do |dropin|
  json.extract! dropin, :id, :rink, :skaters
  json.title 'Dropin ' + dropin.id.to_s
  json.start dropin.date
  json.end dropin.date + 90.minutes
  json.allDay false
  # json.url dropin_url(dropin, format: :html)
end