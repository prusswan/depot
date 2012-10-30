class ErrorNotifier < ActionMailer::Base
  default from: "from@example.com"
  default to: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.occurred.subject
  #
  def occurred(message)
    @message = message
    mail subject: 'Pragmatic Store Error Occurred'
  end
end
