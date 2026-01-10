class Conversation < ApplicationRecord
  belongs_to :user
  has_many :chat_messages, dependent: :destroy

  validates :language, inclusion: { in: %w[en ja ne] }

  scope :recent, -> { order(updated_at: :desc) }

  SUPPORTED_LANGUAGES = {
    'en' => 'English',
    'ja' => '日本語',
    'ne' => 'नेपाली'
  }.freeze

  def display_title
    title.presence || "Conversation ##{id}"
  end

  def add_message(role:, content:)
    chat_messages.create!(role: role, content: content)
  end

  def messages_for_ai
    chat_messages.order(:created_at).map do |msg|
      { role: msg.role, content: msg.content }
    end
  end
end
