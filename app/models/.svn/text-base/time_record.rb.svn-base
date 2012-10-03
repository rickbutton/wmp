class TimeRecord < ActiveRecord::Base
  
  attr_accessible :date, :hours, :task, :user, :task_id, :user_id
  
  validates_inclusion_of :hours, :in => 0..24
  
  belongs_to :task
  belongs_to :user
  
end
