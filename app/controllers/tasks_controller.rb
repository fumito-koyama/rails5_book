class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @tasks = current_user.tasks.recent#scopeを用い、新しい順のエイリアスを作成
    #Task.where(user_id: current_user.id)と結果は同じ
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    #ログインしたユーザーに紐づいた(同じuser_idを持つ)taskを生成

    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to task_url, notice: "タスク「#{@task.name}」に変更しました"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました"
  end


  private

    def task_params
      params.require(:task).permit(:name, :description)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end
end
