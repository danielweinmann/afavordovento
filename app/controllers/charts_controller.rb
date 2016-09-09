class ChartsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_chart, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  # GET /charts
  def index
    @charts = policy_scope(Chart).order(:name).all
  end

  # GET /charts/1
  def show
    authorize @chart
  end

  # GET /charts/new
  def new
    @chart = Chart.new
    authorize @chart
  end

  # GET /charts/1/edit
  def edit
    authorize @chart
  end

  # POST /charts
  def create
    @chart = Chart.new(chart_params)
    @chart.user = current_user
    authorize @chart

    if @chart.save
      redirect_to @chart, notice: t('flash.actions.create.notice', resource_name: @chart.class.model_name.human)
    else
      render :new
    end
  end

  # PATCH/PUT /charts/1
  def update
    authorize @chart
    if @chart.update(chart_params)
      redirect_to @chart, notice: t('flash.actions.update.notice', resource_name: @chart.class.model_name.human)
    else
      render :edit
    end
  end

  # DELETE /charts/1
  def destroy
    authorize @chart
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
