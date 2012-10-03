ActiveAdmin.register Task do
  index do 
    column :name
    column :project do |task|
      link_to task.project.name, admin_project_path(task.project)
    end
    column :client do |task|
      link_to task.project.client.name, admin_client_path(task.project.client)
    end
    default_actions
  end
  
  show do |task|
    attributes_table do
      row :name
      row :project
      row :client do 
        link_to task.project.client.name, admin_client_path(task.project.client)
      end
    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :project
    end
    f.buttons
  end
  
  filter :name
  filter :project
end
