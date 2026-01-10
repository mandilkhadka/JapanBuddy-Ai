class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :documents, dependent: :destroy
  has_many :conversations, dependent: :destroy

  def current_conversation
    conversations.order(updated_at: :desc).first
  end

  def preferred_language
    conversations.order(updated_at: :desc).first&.language || 'en'
  end
end
