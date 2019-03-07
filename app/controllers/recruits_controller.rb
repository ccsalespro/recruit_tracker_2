include ActionView::Helpers::NumberHelper

class RecruitsController < ApplicationController
  before_action :set_recruit, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!


  def index
    search_recruits_params = {}

    if params[:search_recruits].present?
      search_recruits_params.merge! params[:search_recruits].permit!
    end

    @search_recruits = SearchRecruits.execute search_recruits_params
    @recruits = @search_recruits.rows
    @recruits = @recruits.uniq

    @recruits.each do |recruit|
      if recruit.percent_complete >= 100
        recruit.closed = true
        recruit.save
      end
    end
  end

  def show
    @tab = params[:tab] || 'details'
    @uncomplete_tasks = @recruit.tasks.where completed_at: nil
    @complete_tasks = @recruit.tasks.where.not completed_at: nil
  end

  def edit
    params[:phone_number] = @recruit.phone_number
  end

  def new
    @recruit = Recruit.new
    @recruit.tasks.build
  end

  def create
    @recruit = Recruit.new(recruit_params)
    @recruit.phone_number = ToPhoneNumber.new.convert(@recruit.phone_number)

    respond_to do |format|
      if @recruit.save

        general_messages = GeneralMessage.where(number: @recruit.phone_number)
        general_messages.each do |general_message|
          @recruit.messages.create(body: general_message.body, from_recruit: true)
        end
        general_messages.destroy_all

        format.html { redirect_to recruit_path(@recruit), notice: 'Recruit was successfully created.' }
        format.json { render :show, status: :created, location: @recruit }
      else
        format.html { render :new }
        format.json { render json: @recruit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @recruit.update(recruit_params)
        format.html { redirect_to recruit_path(@recruit), notice: 'Recruit was successfully updated.' }
        format.json { render :show, status: :ok, location: @recruit }
      else
        format.html { render :edit }
        format.json { render json: @recruit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recruit.destroy
    respond_to do |format|
      format.html { redirect_to recruits_path, notice: 'Recruit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_recruit
      @recruit = Recruit.find(params[:id])
    end

    def recruit_params
      params.require(:recruit).permit(:name, :phone_number, :email, :description, :start_date, :closed, tasks_attributes: [:id, :name, :due_date])
    end

end
