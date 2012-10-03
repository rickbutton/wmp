class Task < ActiveRecord::Base
  attr_accessible :end, :name, :start, :project, :project_id
  
  after_initialize :default_start
  
  belongs_to :project
  
  private 
    def default_start
      self.start ||= DateTime.now
    end
end
