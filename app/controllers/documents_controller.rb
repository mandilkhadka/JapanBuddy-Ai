class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :destroy]

  def index
    @documents = current_user.documents.recent
  end

  def show
  end

  def new
    @document = current_user.documents.new
  end

  def create
    @document = current_user.documents.new(document_params)

    if @document.save
      if @document.file.attached? || @document.content.present?
        ProcessDocumentJob.perform_later(@document.id)
      end
      redirect_to documents_path, notice: t('flash.document_uploaded')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_path, notice: t('flash.document_deleted')
  end

  private

  def set_document
    @document = current_user.documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :content, :file)
  end
end
