class RequireEventAction < ActiveRecord::Migration
  def change
    change_column :events, :action, :string, :null => false, :default => ""
  end
end
