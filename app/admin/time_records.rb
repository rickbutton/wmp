ActiveAdmin.register TimeRecord do
  index do
    column :date do |tr|
      tr.date.to_date
    end
    column :hours
    column :user do |tr|
      link_to tr.user.full_name, admin_user_path(tr.user)
    end
    column :task do |tr|
      link_to tr.task.name, admin_task_path(tr.task)
    end
    column :project do |tr|
      link_to tr.task.project.name, admin_project_path(tr.task.project)
    end
    column :client do |tr|
      link_to tr.task.project.client.name, admin_client_path(tr.task.project.client)
    end
    default_actions
  end
  
  show do |tr|
    attributes_table do
      row :hours
      row :date do
        tr.date.to_date
      end
      row :task
      row :project do
        link_to tr.task.project.name, admin_project_path(tr.task.project)
      end
      row :client do
        link_to tr.task.project.client.name, admin_client_path(tr.task.project.client)
      end
    end
    active_admin_comments
  end
  
  filter :task
  filter :user
  filter :date
  filter :hours

end
