class SoftwaresController < ApplicationController
  before_action :set_software, only: %i[ show update destroy ]

  # GET /softwares
  def index
    @softwares = Software.all

    render json: @softwares
  end

  # GET /softwares/1
  def show
    render json: @software
  end

  # POST /softwares
  def create
    @software = Software.new(software_params)

    if @software.save
      render json: @software, status: :created, location: @software
    else
      render json: @software.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /softwares/1
  def update
    if @software.update(software_params)
      render json: @software
    else
      render json: @software.errors, status: :unprocessable_content
    end
  end

  # DELETE /softwares/1
  def destroy
    @software.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_software
      @software = Software.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def software_params
      params.expect(software: [ :resume_id, :name, :level ])
    end
end
