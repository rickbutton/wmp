class Project < ActiveRecord::Base
  attr_accessible :client, :name, :client_id
  
  
  belongs_to :client
  has_many :tasks
  has_and_belongs_to_many :users,
      :join_table => "users_projects"
  
  
end
