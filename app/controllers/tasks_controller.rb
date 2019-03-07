class TasksController < ApplicationController
  before_action :load_recruit
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete, :uncomplete]
  before_action :authenticate_user!

  # dont know if i will need to use this page
  def index
    @tasks = @recruit.tasks.all
  end

  def show
  end

  def edit
  end

  def new
    @task = @recruit.tasks.new
  end

  def create
    @task = @recruit.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to recruit_path(@recruit, tab: 'uncomplete_tasks'), notice: 'task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to recruit_path(@recruit, tab: 'uncomplete_tasks'), notice: 'task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete
    @task.completed_at = DateTime.now
    @task.save
    if @recruit.tasks.where(completed_at: nil).count == 0
      redirect_to new_recruit_task_path(@recruit)
    else
      redirect_to recruit_path(@recruit, tab: 'uncomplete_tasks')
    end
  end

  def uncomplete
    @task.completed_at = nil
    @task.save
    redirect_to recruit_path(@recruit, tab: 'complete_tasks')
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def load_recruit
      @recruit = Recruit.find(params[:recruit_id])
    end

    def task_params
      params.require(:task).permit(:name, :due_date, :recruit_id)
    end

end
