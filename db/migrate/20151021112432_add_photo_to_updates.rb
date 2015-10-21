class AddPhotoToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :photo, :string
  end
end
