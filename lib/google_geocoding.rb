
# Implement this later. Might not need it.
# 
# require 'curl'
# module GoogleGeocoding
#   def geocode(str)
#     response = Curl::Easy.http_get("http://maps.googleapis.com/maps/api/geocode/json?address=#{str}&sensor=false")
#     result = JSON.parse(response.body_str)["results"][0]
#     location = result["geometry"]["location"]
#     
#     country = ""
#     addresses = result["address_components"]
#     do 
#       addr = addresses.pop
#       if (addr["types"].include?("country"))
#         c = addr["types"]["country"]
#         c == "US" ? country = c 
#       
#       
#     name = 
#     Geocode.create({:name => "San Francisco", :latitude => location["lat"], :longitude => location["lng"]})
#     
#   end
# end
