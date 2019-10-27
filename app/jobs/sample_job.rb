class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #Sidekiq::Logging.logger.info "サンプルジョブを実行しました"
    #NameError: uninitialized constantとなり失敗する
    p 'hello,job'
  end
end
