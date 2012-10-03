require 'date'
require 'pry'
class PayperiodController < ApplicationController
  
  def index
    month = params[:month].to_i
    year  = params[:year].to_i
    period = params[:period].to_i
    days_in_month = Date.new(year, month, -1).day
    if period == 1
      day_range = 1..15
    elsif period == 2
      day_range = 16..days_in_month
    else
      raise "period must be 1 or 2"
    end
    
    @day_range = day_range
    @period = period
    @month = month
    @year = year
    
    
    if current_user.projects.empty?
      add_projects = Project.all
    else
      add_projects = Project.where("id not in (?)", current_user.projects)
    end
    
    @client_hash = {}
    add_projects.map { |p| p.client }.uniq.each do |client|
      @client_hash[client.id] = {name: client.name, projects: (client.projects & add_projects).map { |p| {name: p.name, id: p.id }}}
    end
    
    @read_only = Date.today > Date.new(year, month, day_range.end)
    #handle read only notice
    flash[:alert] = "This pay period has already passed and is read only." if @read_only
  end
  
  def time_records
    month = params[:month].to_i
    year  = params[:year].to_i
    period = params[:period].to_i
    
    range = calc_range(month, year, period)
    
    days_in_month = Date.new(year, month, -1).day
    
    tasks = []
    hash = { "aaData" => tasks }
    
    Task.where(:end => nil, :project_id => current_user.projects).order(:project_id).each do |task|
      row = []
      p = task.project
      c = p.client
      row += [task.id, "#{c.code}:#{c.name}", p.name, task.name]
      hours = [0]*(period==1 ? 15 : days_in_month - 15)
      #binding.pry
      TimeRecord.where(:user_id => current_user, :task_id => task, :date => range).each do |tr|
        #binding.pry
        hours[tr.date.day % 15 - 1] = tr.hours
      end
      row += hours
      row += ["", ""]
      if p.name == "ADMIN_PROJECT"
        tasks <<row
      else
        tasks.unshift row
      end
    end
    
    @tasks = hash.to_json.html_safe
    
    
    respond_to do |format|
      format.json { render :layout => false, :json => @tasks }
    end
  end
  
  def update
    puts params
    month = params[:month].to_i
    year  = params[:year].to_i
    period = params[:period].to_i
    day = params[:day].to_i
    task = params[:task_id].to_i
    new_value = params[:hours].to_i
    
    date = Date.new(year, month, day).to_time
    
    day_range = date.beginning_of_day..date.end_of_day
    
    tr = TimeRecord.where(:user_id => current_user, :task_id => task, :date => day_range).limit(1).first
    if tr
      tr.hours = new_value
      tr.save
    else
      tr = TimeRecord.new(:date => date, :hours => new_value, :task_id => task, :user => current_user)
      puts "MAKING NEW ONE"
      tr.save
    end
    
    render :nothing => true
  end
end
