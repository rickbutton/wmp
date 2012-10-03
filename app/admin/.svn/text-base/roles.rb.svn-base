ActiveAdmin.register Role do
  index do
    column :name
    [:admin, :can_run_reports, :can_setup].each do |flag|
      column flag do |role|
        if role.send(flag)
          status_tag("YES", :ok)
        else
          status_tag("NO", :error)
        end
      end
    end
    column :pay_rate
    default_actions
  end
  
  show do |role|
    attributes_table do
      row :name
      [:admin, :can_run_reports, :can_setup].each do |flag|
        row flag do |role|
          if role.send(flag)
            status_tag("YES", :ok)
          else
            status_tag("NO", :error)
          end
        end
      end
      row :pay_rate
    end
    active_admin_comments
  end
  
  filter :name
  filter :pay_rate
    
end
