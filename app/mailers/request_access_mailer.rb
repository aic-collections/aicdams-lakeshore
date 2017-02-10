# frozen_string_literal: true
class RequestAccessMailer < ActionMailer::Base
  def request_access(presenter)
    @presenter = presenter
    @host = ENV["LAKESHORE_DOMAIN"]
    mail(to: @presenter.depositor_email.to_s, from: @presenter.requester_email.to_s, subject: "LAKE Access request for asset " + @presenter.uid.to_s)
  end
end
