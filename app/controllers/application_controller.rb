class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  def calc_range(month, year, period)
	  if period == 1
      start_p = Date.new(year, month, 1).to_time.beginning_of_day
      end_p   = Date.new(year, month, 15).to_time.end_of_day
    elsif period == 2
      start_p = Date.new(year, month, 16).to_time.beginning_of_day
      end_p   = Date.new(year, month, -1).to_time.end_of_day
    else
      raise "period must be 1 or 2"
    end
    start_p..end_p
	end
	
	def authorize_reports!
	  authorize! :create, :reports
	end
end
