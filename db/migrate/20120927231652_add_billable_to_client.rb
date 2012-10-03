class AddBillableToClient < ActiveRecord::Migration
  def change
    add_column :clients, :billable, :boolean, :default => true
  end
end
