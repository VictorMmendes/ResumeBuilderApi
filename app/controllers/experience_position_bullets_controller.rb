class ExperiencePositionBulletsController < ApplicationController
  before_action :set_experience_position, only: %i[ index create ]
  before_action :set_experience_position_bullet, only: %i[ show update destroy ]

  # GET /experience_positions/:experience_position_id/experience_position_bullets
  def index
    render json: @experience_position.experience_position_bullets
  end

  # GET /experience_position_bullets/1
  def show
    render json: @experience_position_bullet
  end

  # POST /experience_positions/:experience_position_id/experience_position_bullets
  def create
    @experience_position_bullet = @experience_position.experience_position_bullets.new(experience_position_bullet_params)

    if @experience_position_bullet.save
      render json: @experience_position_bullet, status: :created, location: @experience_position_bullet
    else
      render json: @experience_position_bullet.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /experience_position_bullets/1
  def update
    if @experience_position_bullet.update(experience_position_bullet_params)
      render json: @experience_position_bullet
    else
      render json: @experience_position_bullet.errors, status: :unprocessable_content
    end
  end

  # DELETE /experience_position_bullets/1
  def destroy
    @experience_position_bullet.destroy!
  end

  private

  def set_experience_position
    @experience_position = ExperiencePosition.find(params.expect(:experience_position_id))
  end

  def set_experience_position_bullet
    @experience_position_bullet = ExperiencePositionBullet.find(params.expect(:id))
  end

  def experience_position_bullet_params
    params.expect(experience_position_bullet: [ :content, :display_order ])
  end
end
