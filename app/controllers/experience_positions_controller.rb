class ExperiencePositionsController < ApplicationController
  before_action :set_experience_group, only: %i[ index create ]
  before_action :set_experience_position, only: %i[ show update destroy ]

  # GET /experience_groups/:experience_group_id/experience_positions
  def index
    render json: @experience_group.experience_positions
  end

  # GET /experience_positions/1
  def show
    render json: @experience_position
  end

  # POST /experience_groups/:experience_group_id/experience_positions
  def create
    @experience_position = @experience_group.experience_positions.new(experience_position_params)

    if @experience_position.save
      render json: @experience_position, status: :created, location: @experience_position
    else
      render json: @experience_position.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /experience_positions/1
  def update
    if @experience_position.update(experience_position_params)
      render json: @experience_position
    else
      render json: @experience_position.errors, status: :unprocessable_content
    end
  end

  # DELETE /experience_positions/1
  def destroy
    @experience_position.destroy!
  end

  private

  def set_experience_group
    @experience_group = ExperienceGroup.find(params.expect(:experience_group_id))
  end

  def set_experience_position
    @experience_position = ExperiencePosition.find(params.expect(:id))
  end

  def experience_position_params
    params.expect(experience_position: [ :title, :start_date, :end_date, :current, :summary, :display_order ])
  end
end
