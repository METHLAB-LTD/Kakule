class ActiveSupport::TimeWithZone
  def date
    return "#{year}/#{month}/#{day}"
  end
end