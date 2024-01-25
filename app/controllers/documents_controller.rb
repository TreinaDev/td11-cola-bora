class DocumentsController < ApplicationController
  before_action :set_project, only: %i[index new create]
  before_action :set_document, only: %i[show archive]
  before_action -> { authorize_member(@project) }, only: %i[create]

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

  def authorize_member(project)
    redirect_to root_path, alert: t('.unauthorized') unless project.member? current_user
  end
end
