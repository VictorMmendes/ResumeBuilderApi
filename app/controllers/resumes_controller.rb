class ResumesController < ApplicationController
  before_action :set_resume, only: %i[ show update destroy ]

  # GET /resumes
  def index
    if params[:email].present?
      @resumes = Resume.joins(:user).where(users: { email: params[:email] })
    else
      @resumes = Resume.all
    end

    render json: @resumes
  end

  # GET /resumes/1
  def show
    render json: @resume, include: [
      :experiences,
      :educations,
      :skills,
      :languages,
      :softwares
    ]
  end

  # POST /resumes
  def create
    @resume = Resume.new(resume_params)

    if @resume.save
      render json: @resume, status: :created, location: @resume
    else
      render json: @resume.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /resumes/1
  def update
    if @resume.update(resume_params)
      render json: @resume
    else
      render json: @resume.errors, status: :unprocessable_content
    end
  end

  # DELETE /resumes/1
  def destroy
    @resume.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_resume
    @resume = Resume.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def resume_params
    params.expect(resume: [:user_id, :title, :full_name, :job_title, :summary, :email, :phone, :address, :linkedin_url, :website_url])
  end
end
