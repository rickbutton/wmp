class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :admin
      t.boolean :can_setup
      t.boolean :can_run_reports
      t.integer :pay_rate

      t.timestamps
    end
  end
end
