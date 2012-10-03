ActiveAdmin.register Project do
  index do
    column :name
    column :client do |client|
      link_to client.name, admin_client_path(client)
    end
    default_actions
  end
  
  show do |f|
    attributes_table do
      row :name
      row :client
    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :client
      
    end
    
    f.buttons
  end
  
  filter :name
  filter :client
end
