class UserMailer < BaseMandrillMailer
  helper :application

  def standup_email(updates)
    options = {
      subject: "Standup for #{DateTime.now.strftime('%A, %B %e, %Y')}",
      email: "team@promoboxx.com",
      # first_name: record.first_name,
      # confirmation_url: confirmation_url(record, confirmation_token: record.confirmation_token),
      template: "standup"
    }
    mandrill_send(options)
  private

  def mandrill_send(opts={})
    message = {
      subject: opts[:subject],
      to: [
        { name: opts[:name],
          email: opts[:email],
          type: "to" }
      ],
      fname: opts[:first_name],
      confirmation_url: opts[:confirmation_url],
      reset_password_url: opts[:reset_password_url]
    }

    body = mandrill_template(opts[:template], message)
    send_mail(opts[:email], opts[:subject], body)
    rescue Mandrill::Error => e
      Rails.logger.debug("#{e.class}: #{e.message}")
      raise
  end
end
