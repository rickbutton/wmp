class CreateTimeRecords < ActiveRecord::Migration
  def change
    create_table :time_records do |t|
      t.integer :hours
      t.datetime :date
      t.references :task
      t.references :user

      t.timestamps
    end
  end
end
