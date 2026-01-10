class Document < ApplicationRecord
  belongs_to :user
  has_many :chunks, dependent: :destroy
  has_one_attached :file

  validates :title, presence: true
  validates :status, inclusion: { in: %w[pending processing completed failed] }

  enum :status, { pending: 'pending', processing: 'processing', completed: 'completed', failed: 'failed' }, prefix: true

  scope :processed, -> { where(status: 'completed') }
  scope :recent, -> { order(created_at: :desc) }

  def process_document!
    update!(status: 'processing')
    DocumentProcessingService.new(self).process
    update!(status: 'completed')
  rescue StandardError => e
    update!(status: 'failed')
    Rails.logger.error "Document processing failed: #{e.message}"
    raise e
  end
end
