class ExperienceGroupsController < ApplicationController
  before_action :set_resume, only: %i[ index create ]
  before_action :set_experience_group, only: %i[ show update destroy ]

  # GET /resumes/:resume_id/experience_groups
  def index
    render json: @resume.experience_groups
  end

  # GET /experience_groups/1
  def show
    render json: @experience_group
  end

  # POST /resumes/:resume_id/experience_groups
  def create
    @experience_group = @resume.experience_groups.new(experience_group_params)

    if @experience_group.save
      render json: @experience_group, status: :created, location: @experience_group
    else
      render json: @experience_group.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /experience_groups/1
  def update
    if @experience_group.update(experience_group_params)
      render json: @experience_group
    else
      render json: @experience_group.errors, status: :unprocessable_content
    end
  end

  # DELETE /experience_groups/1
  def destroy
    @experience_group.destroy!
  end

  private

  def set_resume
    @resume = Resume.find(params.expect(:resume_id))
  end

  def set_experience_group
    @experience_group = ExperienceGroup.find(params.expect(:id))
  end

  def experience_group_params
    params.expect(experience_group: [ :company_name, :location, :display_order ])
  end
end
