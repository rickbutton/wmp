ActiveAdmin.register Client do
  index do
    column :name
    column :code
    column :billable do |client|
      if client.billable
        status_tag("YES", :ok)
      else
        status_tag("NO", :error)
      end
    end
    default_actions
  end
  
  show do |client|
    attributes_table do
      row :name
      row :code
      row :billable do
        if client.billable
          status_tag("YES", :ok)
        else
          status_tag("NO", :error)
        end 
      end
    end
    active_admin_comments
  end
  
  filter :name
  filter :code
end
