ActiveAdmin.register User do
  
  index do
    column :username
    column :full_name do |user|
      user.full_name
    end
    column :role do |user|
      link_to user.role.name, admin_role_path(user.role)
    end
    
    default_actions
  end
  
  show do |user|
    attributes_table do
      row :full_name do
        user.full_name
      end
      row :username
      row :role
    end
    active_admin_comments
  end
  
  form do |f|
  	f.inputs 'Details' do
  		f.input :first, :label => "First Name"
  		f.input :last, :label => "Last Name"
  		f.input :username
  		f.input :role
  	end
		f.buttons
	end
	
	filter :username
	filter :first, :label => "First Name"
	filter :last, :label => "Last Name"
	filter :role
	
end
