class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :registerable
  
  before_create :add_admin

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :password, :password_confirmation, :remember_me, :role, :first, :last, :role_id
  # attr_accessible :title, :body
  
  belongs_to :role
  has_and_belongs_to_many :projects,
    :join_table => "users_projects"
    
  def full_name
    [first, last].join ' '
  end
  
  private
    def add_admin
      ap = Project.find_by_name("ADMIN_PROJECT")
      raise "Admin Project not found" unless ap
      projects << ap unless projects.include? ap
    end
end
