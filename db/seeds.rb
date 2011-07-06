# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Geocode.create({:name => "San Francisco", :latitude => 37.7793, :longitude => -122.4192})
Geocode.create({:name => "South San Francisco", :latitude => 37.656111, :longitude => -122.425556})



Event.create({
  :eventful_id => "E0-001-023664161-4@2011070221", 
  :name => "Dominion : Ireland's only weekly goth, industrial", 
  :description => "", 
  :start_time => "2011-07-03 04:30:00", 
  :end_time => "2011-07-03 09:30:00", 
  :venue => "The Cellar, Murrays Bar", 
  :street => "33-34 O Connell Street", 
  :city => "Dublin", 
  :state => "Dublin", 
  :postal => nil, 
  :country => "IRL", 
  :latitude => 53.3498283, 
  :longitude => -6.260115, 
  :picture_url => "http =>//static.eventful.com/images/small/I0-001/002/"})
  
Event.create({
  :eventful_id => "E0-001-004212190-4@2011070218", 
  :name => "Party at Amber's", 
  :description => "", 
  :start_time => "2011-07-10 04:30:00", 
  :end_time => "2011-07-10 09:30:00", 
  :venue => "Amber's House", 
  :street => "123 Somestreet", 
  :city => "Sunnyvale", 
  :state => "CA", 
  :postal => "94087", 
  :country => "USA", 
  :latitude => 37.7793, 
  :longitude => -122.4192, 
  :picture_url => ""})