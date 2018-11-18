class TasksController < ApplicationController
  
  # アクション(show, edit, update, destroy)で共通のタスク取得処理を「set_task」で行う
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = current_user.tasks.recent
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    
    if @task.save 
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました"
    else
      render :new
    end
    
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました"
    else
      render :edit
    end
    
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました"    
  end
  
  private
    def task_params
      params.require(:task).permit(:name, :description)
    end
    
    # タスク取得共通処理[:show, :edit, :update, :destroy]
    def set_task
      @task = current_user.tasks.find(params[:id]) 
    end
end