class CertificationsController < ApplicationController
  before_action :set_resume, only: %i[ index create ]
  before_action :set_certification, only: %i[ show update destroy ]

  # GET /resumes/:resume_id/certifications
  def index
    render json: @resume.certifications
  end

  # GET /certifications/1
  def show
    render json: @certification
  end

  # POST /resumes/:resume_id/certifications
  def create
    @certification = @resume.certifications.new(certification_params)

    if @certification.save
      render json: @certification, status: :created, location: @certification
    else
      render json: @certification.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /certifications/1
  def update
    if @certification.update(certification_params)
      render json: @certification
    else
      render json: @certification.errors, status: :unprocessable_content
    end
  end

  # DELETE /certifications/1
  def destroy
    @certification.destroy!
  end

  private

  def set_resume
    @resume = Resume.find(params.expect(:resume_id))
  end

  def set_certification
    @certification = Certification.find(params.expect(:id))
  end

  def certification_params
    params.expect(certification: [ :name, :display_order ])
  end
end
