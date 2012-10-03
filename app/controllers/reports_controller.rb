class ReportsController < ApplicationController
  
  before_filter :authorize_reports!
  
  def index
    @users = User.all
    @clients = Client.all
    
    @month = Date.today.month
    @year = Date.today.year
    @period = Date.today.day < 16 ? 1 : 2
  end
  
  def consultant
    id = params[:id]
    month = params[:month].to_i
    year = params[:year].to_i
    period = params[:period].to_i
    range = calc_range(month, year, period)
    output = Reports.new.consultant_pdf id, range
    
    send_data output, :filename => "report.pdf",
                      :type => "application/pdf",
                      :disposition => "inline"
  end
  
  def client
    id = params[:id]
    month = params[:month].to_i
    year = params[:year].to_i
    period = params[:period].to_i
    range = calc_range(month, year, period)
    output = Reports.new.client_pdf id, range
    
    send_data output, :filename => "report.pdf",
                      :type => "application/pdf",
                      :disposition => "inline"
  end
  
  
  private
    class Reports < Prawn::Document
      def consultant_pdf(id, range)
        list = ActiveRecord::Base.connection.execute("
        SELECT
          ((users.first || ' ') || users.last) AS consultant,
          clients.name AS 'cname',
          projects.name AS 'pname',
          roles.name AS 'rname',
    		  SUM(time_records.hours) AS 'hours',
    		  SUM(time_records.hours)*roles.pay_rate*(CASE WHEN clients.billable = 't' THEN 1 ELSE 0 END) AS 'fees'
    		FROM time_records

    		INNER JOIN tasks ON time_records.task_id = tasks.id
    		INNER JOIN projects ON tasks.project_id = projects.id
    		INNER JOIN users ON time_records.user_id = users.id
    		INNER JOIN clients ON projects.client_id = clients.id
    		INNER JOIN roles ON users.role_id = roles.id
    		WHERE users.id = #{ActiveRecord::Base.sanitize(id)} AND
    		time_records.date BETWEEN #{ActiveRecord::Base.sanitize(range.begin.to_formatted_s(:db))} AND
    		  #{ActiveRecord::Base.sanitize(range.end.to_formatted_s(:db))}
    		GROUP BY projects.id")
    		clients = {}
    		list.each do |hash|
    		  clients[hash["cname"]] ||= {}
    		  clients[hash["cname"]][hash["pname"]] = {"hours" => hash["hours"], "fees" => hash["fees"]}
    		end
    		#{C=>{ P=> 1, P2=> 3}}
    		if list.empty?
    		  header(range, "Consultant")
    		  move_down(100)
    		  text "There is no data to show for this time period", :align => :center
    		  return render
    		end
    		
    		header(range, "Consultant", "#{list[0]["consultant"]} - #{list[0]['rname']}")
    		
    		overall_total_hours = 0
    		overall_total_fees = 0
    		
    		clients.each do |name, projects|
    	    if name == "ADMIN_CLIENT"
    	      text "Admin:"
    	    else
    	      text "#{name}:"
    	    end
    	    move_down(10)
    	    total_hours = 0
    	    total_fees = 0
    	    t = [["Project", "Hours", "Fees"]]
    		  t += projects.map do |name, project|
    		    total_hours += project["hours"].to_i
    		    total_fees += project["fees"].to_i
    		    
    		    name = name == "ADMIN_PROJECT" ? "Admin" : name
    		    
    		    [name, project["hours"], "$" + project["fees"].to_s]
    		  end
    		  t << ["Total", total_hours, "$" + total_fees.to_s]
    		  
    		  overall_total_hours += total_hours
    		  overall_total_fees += total_fees
    		  
    		  table t
    		  
    		  move_down(40)
    		end
    		
    		text "Total Hours: #{overall_total_hours}"
    		text "Total Fees: $#{overall_total_fees}"
    		
    		render
      end
      
      def client_pdf(id, range)
        list = ActiveRecord::Base.connection.execute("
        SELECT
          ((users.first || ' ') || users.last) AS consultant,
          projects.name AS 'pname',
          clients.name AS 'cname',
    		  SUM(time_records.hours) AS 'hours',
    		  SUM(time_records.hours)*roles.pay_rate*(CASE WHEN clients.billable = 't' THEN 1 ELSE 0 END) AS 'fees'
    		FROM time_records

    		INNER JOIN tasks ON time_records.task_id = tasks.id
    		INNER JOIN projects ON tasks.project_id = projects.id
    		INNER JOIN users ON time_records.user_id = users.id
    		INNER JOIN clients ON projects.client_id = clients.id
    		INNER JOIN roles ON users.role_id = roles.id
    		WHERE clients.id = #{ActiveRecord::Base.sanitize(id)} AND
    		time_records.date BETWEEN #{ActiveRecord::Base.sanitize(range.begin.to_formatted_s(:db))} AND
    		  #{ActiveRecord::Base.sanitize(range.end.to_formatted_s(:db))}
    		GROUP BY projects.id")
    		projects = {}
    		list.each do |hash|
    		  projects[hash["pname"]] ||= {}
    		  projects[hash["pname"]][hash["consultant"]] = {"hours" => hash["hours"], "fees" => hash["fees"]}
    		end
    		#{C=>{ P=> 1, P2=> 3}}
    		if list.empty?
    		  header(range, "Client")
    		  move_down(100)
    		  text "There is no data to show for this time period", :align => :center
    		  return render
    		end
    		
    		header(range, "Client", list[0]["cname"])
    		
    		overall_total_hours = 0
    		overall_total_fees = 0
    		
        projects.each do |name, users|
    	    text "#{name}:"
    	    move_down(10)
    	    total_hours = 0
    	    total_fees = 0
    	    t = [["Consultant", "Hours", "Fees"]]
    		  t += users.map do |name, hash|
    		    total_hours += hash["hours"].to_i
    		    total_fees += hash["fees"].to_i
    		    [name, hash["hours"], "$" + hash["fees"].to_s]
    		  end
    		  t << ["Total", total_hours, "$" + total_fees.to_s]
    		  
    		  overall_total_hours += total_hours
    		  overall_total_fees += total_fees
    		  
    		  table t
    		  
    		  move_down(40)
    		end
    		
    		text "Total Hours: #{overall_total_hours}"
    		text "Total Fees: $#{overall_total_fees}"
    		
    		render
      end
      
      private
        def header(range, name, sub = "")
          text "Goodwin Consulting", :align => :center, :size => 28
          text "#{name} Pay Period Report", :align => :center, :size => 26
          text "#{range.begin.strftime("%B %d, %Y")} - #{range.end.strftime("%B %d, %Y")}", :align => :center, :size => 18
          text "Generated on #{DateTime.now.strftime("%B %d, %Y at %I:%M %p")}", :align => :center, :size => 10
          move_down(10)
          text sub, :align => :center, :size => 18
          move_down(20)
        end
    end
end