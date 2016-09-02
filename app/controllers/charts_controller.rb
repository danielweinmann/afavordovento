class ChartsController < ApplicationController
  before_action :authenticate_user!, except: []
  before_action :set_chart, only: [:show, :edit, :update, :destroy]

  # GET /charts
  def index
    @charts = current_user.charts.all
  end

  # GET /charts/1
  def show
  end

  # GET /charts/new
  def new
    @chart = Chart.new
  end

  # GET /charts/1/edit
  def edit
  end

  # POST /charts
  def create
    @chart = Chart.new(chart_params)
    @chart.user = current_user

    if @chart.save
      redirect_to @chart, notice: t('flash.actions.create.notice', resource_name: @chart.class.model_name.human)
    else
      render :new
    end
  end

  # PATCH/PUT /charts/1
  def update
    if @chart.update(chart_params)
      redirect_to @chart, notice: t('flash.actions.update.notice', resource_name: @chart.class.model_name.human)
    else
      render :edit
    end
  end

  # DELETE /charts/1
  def destroy
    @chart.destroy
    redirect_to charts_url, notice: t('flash.actions.destroy.notice', resource_name: @chart.class.model_name.human)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chart
      @chart = Chart.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chart_params
      params.require(:chart).permit(:name, :birth_date, :is_female)
    end
end
