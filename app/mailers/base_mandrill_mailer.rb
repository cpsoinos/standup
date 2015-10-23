require "mandrill"
require "certified"

class BaseMandrillMailer < ActionMailer::Base
  default(
    from: "coreypsoinos@gmail.com",
    reply_to: "coreypsoinos@gmail.com"
  )

  private

  def send_mail(template_name, template_content, message)
    # binding.pry
    mandrill.messages.send_template(template_name, template_content, message, false, nil, nil)

    # mail(to: email, subject: subject, body: body, content_type: "text/html")
  end

  # def mandrill_template(template_name, attributes)
  #   template_content =
  #   merge_vars = attributes.map do |key, value|
  #     { name: key, content: value }
  #   end
  #
  #   mandrill.templates.render(template_name, [], merge_vars)["html"]
  # end

  def mandrill
    if Rails.env == "test"
      @_mandrill = Mandrill::API.new(ENV["MANDRILL_TEST_API_KEY"])
    else
      @_mandrill = Mandrill::API.new(ENV["SMTP_PASSWORD"])
    end
  end

  def log_response(response, user)
    record = EmailRecord.new(
      remote_id: response["_id"],
      to_email: response["email"],
      status: response["status"],
      user_id: user.id
    )
    record.save!
  end

end
