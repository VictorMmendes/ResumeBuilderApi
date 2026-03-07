class ResumesController < ApplicationController
  before_action :set_resume, only: %i[ show update destroy export avatar ]

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
      :softwares,
      :technical_skills,
      :projects,
      :hobbies
    ], methods: [ :avatar_url ]
  end

  # GET /resumes/1/export
  def export
    pdf = PdfGeneratorService.new("resumes/show", {
      resume: @resume
    }).call
    send_data pdf, type: "application/pdf", disposition: "inline", filename: "#{@resume.full_name.parameterize}_resume.pdf"
  end

  # POST /resumes/1/avatar
  def avatar
    if params[:avatar].present?
      @resume.avatar.attach(params[:avatar])
      render json: { avatar_url: @resume.avatar_url }, status: :ok
    else
      render json: { error: "No avatar provided" }, status: :bad_request
    end
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
    params.expect(resume: [ :user_id, :title, :full_name, :job_title, :summary, :email, :phone, :address, :linkedin_url, :website_url, :github_url, :old_experiences_summary, :avatar ])
  end
end
