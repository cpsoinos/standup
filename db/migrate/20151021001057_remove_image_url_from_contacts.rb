class RemoveImageUrlFromContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :image_url, :string
  end
end
