module ItinerariesHelper
  def format_time(time)
    time.strftime("%I:%M %p")
  end
end
