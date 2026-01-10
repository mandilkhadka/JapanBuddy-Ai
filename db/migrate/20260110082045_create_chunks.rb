class CreateChunks < ActiveRecord::Migration[7.1]
  def change
    create_table :chunks do |t|
      t.text :content, null: false
      t.references :document, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.text :embedding_json

      t.timestamps
    end
  end
end
