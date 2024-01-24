class DocumentsController < ApplicationController
  before_action :set_project, only: %i[index new create]
  before_action :set_document, only: %i[show archive]

  def index
    @documents = @project.documents.where(archived: false)
  end

  def new
    @document = @project.documents.build
  end

  def create
    @document = @project.documents.build(document_params)
    if @document.save
      redirect_to project_documents_path(@project), notice: t('.success')
    else
      # debugger
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def archive
    @document.update(archived: true)
    redirect_to project_documents_path(@document.project), notice: t('.success')
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document)
          .permit(:title, :description, :file)
          .merge(user: current_user)
  end
end
