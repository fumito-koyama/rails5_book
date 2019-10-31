class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @user = current_user
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(15)
    #scopeを用い、新しい順のエイリアスを作成(ransackによるソートに変更)
    #Task.where(user_id: current_user.id)と結果は同じ
    respond_to do |format|
      format.html
      format.csv{ send_data @tasks.generate_csv,
                  filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"}
    end
  end

  def show
    SampleJob.perform_later
  end

  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    @task = current_user.tasks.new(task_params)
    #ログインしたユーザーに紐づいた(同じuser_idを持つ)taskを生成

    # if params[:back]
    #   render :new
    #   return
    # end 確認画面

    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      SampleJob.perform_later
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
    #head :no_content
    #SJRを用いるため不要
  end

  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: 'タスクを追加しました'
  end


  private

    def task_params
      params.require(:task).permit(:name, :description, :image)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end
end
