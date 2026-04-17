class TopSkillsController < ApplicationController
  before_action :set_resume, only: %i[ index create ]
  before_action :set_top_skill, only: %i[ show update destroy ]

  # GET /resumes/:resume_id/top_skills
  def index
    render json: @resume.top_skills
  end

  # GET /top_skills/1
  def show
    render json: @top_skill
  end

  # POST /resumes/:resume_id/top_skills
  def create
    @top_skill = @resume.top_skills.new(top_skill_params)

    if @top_skill.save
      render json: @top_skill, status: :created, location: @top_skill
    else
      render json: @top_skill.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /top_skills/1
  def update
    if @top_skill.update(top_skill_params)
      render json: @top_skill
    else
      render json: @top_skill.errors, status: :unprocessable_content
    end
  end

  # DELETE /top_skills/1
  def destroy
    @top_skill.destroy!
  end

  private

  def set_resume
    @resume = Resume.find(params.expect(:resume_id))
  end

  def set_top_skill
    @top_skill = TopSkill.find(params.expect(:id))
  end

  def top_skill_params
    params.expect(top_skill: [ :name, :display_order ])
  end
end
