class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
