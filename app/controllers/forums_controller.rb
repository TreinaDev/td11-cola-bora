class ForumsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
  end
end
