class CreateStandupNotes < ActiveRecord::Migration
  def change
    create_table :standup_notes do |t|
      t.timestamps
      t.integer :created_by_id
      t.text :personal_updates
      t.text :work_updates
    end
  end
end
