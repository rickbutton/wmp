class ProjectsController < ApplicationController
  
  def add_to_user
    id = params[:id]
    project = Project.find(id)
    current_user.projects << project if project
    current_user.save
    
    render :nothing => true
  end
  
end