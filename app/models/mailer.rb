class Mailer < ActionMailer::Base

  def feedback(feedback)
      recipients    "info@0-one.net"
      from          "#{feedback[:name]} <#{feedback[:email]}>"
      subject       "Gowane Map Feedback"
      body          feedback
  end

  def info_request(email)
    recipients "olivier.kouame@0-one.net"
    from "olivier.kouame@0-one.net"
    content_type "text/html"
    subject "Someone wants more info about 0-one!"
    body :message => email
  end

end