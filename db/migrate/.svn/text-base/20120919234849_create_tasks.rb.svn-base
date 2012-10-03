class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.references :project

      t.timestamps
    end
  end
end
