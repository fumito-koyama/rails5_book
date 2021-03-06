class SessionsController < ApplicationController
  skip_before_action :login_required
  
  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])#&はnilガード(中身がnilのの場合、メソッドを実行せずnilを返す)
      session[:user_id] = user.id
      redirect_to root_url, notice: 'ログインしました'
    else
      flash.now[:notice] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'ログアウトしました'
  end

  private

    def session_params
      params.require(:session).permit(:email, :password)
    end
end
