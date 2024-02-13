class CreateMeetingParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :meeting_participants do |t|
      t.references :meeting, null: false, foreign_key: true
      t.references :user_role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
