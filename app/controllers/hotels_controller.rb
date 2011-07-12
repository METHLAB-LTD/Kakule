class HotelsController < ApplicationController
  
  
  def autocomplete
    
    url = "http://www.hotelscombined.com/AutoComplete.ashx?query=#{param[:query]}&languageCode=EN&format=text&limit=10"
    
    
    
  end
end
