class AdminRedirectController < ApplicationController
  def redirect
    redirect_to admin_clients_path
  end
end