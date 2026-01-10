class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :language, default: 'en'

      t.timestamps
    end

    add_index :conversations, :created_at
  end
end
