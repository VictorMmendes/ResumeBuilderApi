class ResumesController < ApplicationController
  before_action :set_resume, only: %i[ show update destroy export avatar ]

  # GET /resumes
  def index
    resumes = Resume.with_attached_avatar
    resumes = resumes.joins(:user).where(users: { email: params[:email] }) if params[:email].present?

    render json: resumes.map { |resume| resume_resource_payload(resume) }
  end

  # GET /resumes/1
  def show
    render json: resume_payload(@resume)
  end

  # GET /resumes/1/export
  def export
    pdf = PdfGeneratorService.new("resumes/show", {
      resume: @resume,
      payload: resume_payload(@resume)
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
      render json: resume_resource_payload(@resume), status: :created, location: @resume
    else
      render json: @resume.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /resumes/1
  def update
    if @resume.update(resume_params)
      render json: resume_resource_payload(@resume)
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
    @resume = Resume.with_attached_avatar.includes(
      :educations,
      :top_skills,
      :certifications,
      experience_groups: { experience_positions: :experience_position_bullets }
    ).find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def resume_params
    params.expect(resume: [ :user_id, :full_name, :headline, :summary, :email, :phone, :street_address, :city, :region, :country, :linkedin_url, :github_url, :portfolio_label, :avatar ])
  end

  def resume_payload(resume)
    ResumePayloadBuilder.new(resume).call
  end

  def resume_resource_payload(resume)
    resume.attributes.slice(
      "id",
      "user_id",
      "full_name",
      "headline",
      "summary",
      "email",
      "phone",
      "street_address",
      "city",
      "region",
      "country",
      "linkedin_url",
      "github_url",
      "portfolio_label"
    ).merge("avatar_url" => resume.avatar_url)
  end
end
