class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :category
      t.references :contact, index: true, foreign_key: true
      t.text :content
      t.timestamps
      t.references :user, index: true, foreign_key: true
    end
  end
end
