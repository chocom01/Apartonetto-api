class CheckIfAcceptedWorker
  include Sidekiq::Worker

  def perform(booking_id)
    # do something
  end
end
