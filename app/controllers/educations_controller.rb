class EducationsController < ApplicationController
  before_action :set_resume, only: %i[ index create ]
  before_action :set_education, only: %i[ show update destroy ]

  # GET /resumes/:resume_id/educations
  def index
    render json: @resume.educations
  end

  # GET /educations/1
  def show
    render json: @education
  end

  # POST /resumes/:resume_id/educations
  def create
    @education = @resume.educations.new(education_params)

    if @education.save
      render json: @education, status: :created, location: @education
    else
      render json: @education.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /educations/1
  def update
    if @education.update(education_params)
      render json: @education
    else
      render json: @education.errors, status: :unprocessable_content
    end
  end

  # DELETE /educations/1
  def destroy
    @education.destroy!
  end

  private
  def set_resume
    @resume = Resume.find(params.expect(:resume_id))
  end

  def set_education
    @education = Education.find(params.expect(:id))
  end

  def education_params
    params.expect(education: [ :institution, :degree_name, :field_of_study, :start_date, :end_date, :current, :display_order ])
  end
end
