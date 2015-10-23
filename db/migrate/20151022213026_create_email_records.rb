class CreateEmailRecords < ActiveRecord::Migration
  def change
    create_table :email_records do |t|
      t.string :remote_id
      t.string :to_email
      t.string :status
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
