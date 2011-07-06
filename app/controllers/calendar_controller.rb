class CalendarController < ApplicationController
  def render_calendar 
    render :json => {
        :html => (render_to_string :partial => "calendar/calendar", :locals => {:month => params[:month].to_i, :year => params[:year].to_i})
    }
  end

  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = CalendarEvent.event_strips_for_month(@shown_month)
  end
  
end
