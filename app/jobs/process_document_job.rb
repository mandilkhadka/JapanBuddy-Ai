class ProcessDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
    document.process_document!
  rescue ActiveRecord::RecordNotFound
    Rails.logger.warn "Document #{document_id} not found for processing"
  end
end
