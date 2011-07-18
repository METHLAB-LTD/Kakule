#run fetch_eventful in console

require 'eventful/api'
def fetch_eventful(date = Date.today, page_number = 1)
  eventful = Eventful::API.new EVENTFUL_APPLICATION_KEY
  (0..30).each do |i|
    result = eventful.call 'events/search', :date => date + i.day, :page_size => 100, :page_number => page_number
    break if result["events"].nil?
    Event.store_eventful_data(result["events"]["event"])
    
    #puts "Fetched #{page_number*100} events..."
    #page_number += 1
  end
end

