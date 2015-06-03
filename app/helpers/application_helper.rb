module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title = '')
    base_title = 'Dropins Beta'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def truncate(s, max=70, elided = ' ...')
    s.match( /(.{1,#{max}})(?:\s|\z)/ )[1].tap do |res|
      res << elided unless res.length == s.length
    end
  end
end
