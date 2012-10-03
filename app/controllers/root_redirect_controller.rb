class RootRedirectController < ApplicationController

  def redirect
    period = Date.today.day < 16 ? 1 : 2
    redirect_to payperiod_path(:month => Date.today.month, :year => Date.today.year, :period => period)
  end
  
end
