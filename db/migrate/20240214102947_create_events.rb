class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :email
      t.integer :user_id
      t.string :event_name
      t.timestamps
    end
  end
end