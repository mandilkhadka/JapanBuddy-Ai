class CreateChunks < ActiveRecord::Migration[7.1]
  def change
    create_table :chunks do |t|
      t.text :content, null: false
      t.references :document, null: false, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_column :chunks, :embedding, :vector, limit: 1536
    add_index :chunks, :embedding, using: :ivfflat, opclass: :vector_cosine_ops
  end
end
