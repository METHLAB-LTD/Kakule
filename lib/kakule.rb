require 'eventful/api'
module Kakule
  def self.fetch_eventful(date = Date.today, page_number = 1)
    eventful = Eventful::API.new EVENTFUL_APPLICATION_KEY
    while(true)
      result = eventful.call 'events/search', :date => date, :page_size => 100, :page_number => page_number
      break if result["events"].nil?
      Event.store_eventful_data(result["events"]["event"])
      page_number += 1
    end
  end
  
  
  
end