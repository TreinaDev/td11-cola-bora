class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.references :user_role, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :title, null: false
      t.string :description
      t.date :date, null: false
      t.time :time, null: false
      t.integer :duration, null: false
      t.string :address, null: false

      t.timestamps
    end
  end
end
