class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :action
      t.string :url
      t.references :actor
      t.text :body
      t.string :checksum
      t.datetime :recorded_at

      t.timestamps
    end
    add_index :events, :actor_id
  end
end
