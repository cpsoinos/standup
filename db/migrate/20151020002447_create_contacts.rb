class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :source
      t.string :uid
      t.string :name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email
      t.string :image_url
      t.string :phone
    end
  end
end
