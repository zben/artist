#encoding: UTF-8
class ErrorMailer < ActionMailer::Base
  default from: "support@canvvas.com"

  def send_error
    mail(:from=>"Canvvas <support@canvvas.com>",
         :to => "ben@canvvas.com",
         :subject => "Error email")
  end
end
