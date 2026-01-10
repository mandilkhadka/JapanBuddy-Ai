class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :title, null: false
      t.text :content
      t.string :file_type, default: 'text'
      t.string :status, default: 'pending'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :documents, :status
    add_index :documents, :file_type
  end
end
