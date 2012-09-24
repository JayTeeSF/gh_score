class RequireEventChecksumAndActor < ActiveRecord::Migration
  def change
    change_column :events, :actor_id, :integer, :null => false
    change_column :events, :checksum, :string, :null => false, :default => ""
  end
end
