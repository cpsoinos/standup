class StandupMailer < BaseMandrillMailer
  helper :application

  def send_standup_email(updates, user)
    options = {
      subject: "Standup for #{DateTime.now.strftime('%A, %B %e, %Y')}",
      email: "coreypsoinos@gmail.com",
      name: "Promoboxx Team",
      template: "standup_2",
      updates: updates,
      user: user
    }
    mandrill_send(options)
    @user = user
  end

  private

  def mandrill_send(opts={})
    updates = Update.find(opts[:updates])

    template_name = opts[:template]
    template_content = [
      {
        name: "personal",
        content: personal_content(updates)
      },
      {
        name: "professional",
        content: professional_content(updates)
      }
    ]
    message = {
      subject: opts[:subject],
      to: [
        { name: opts[:name],
          email: opts[:email],
          type: "to" }
      ],
      from_email: opts[:user].email,
      from_name: opts[:user].name
    }

    response = send_mail(template_name, template_content, message).first
    log_response(response, opts[:user])

    rescue Mandrill::Error => e
      Rails.logger.debug("#{e.class}: #{e.message}")
      raise
  end

  def personal_content(updates)
    html = updates.map do |update|
      if update.category == "personal"
        email_html(update)
      end
    end
    html.join
  end

  def professional_content(updates)
    html = updates.map do |update|
      if update.category == "professional"
        email_html(update)
      end
    end
    html.join
  end

  def email_html(update)
    <<-eos
      <table cellpadding="10">
        <tr>
          <td>
            <img src='#{update.contact.photo_url}'></br>
            #{update.contact.name}
          </td>
          <td>
            #{update.content}
          </td>
        </tr>
      </table>
      </br>
    eos
  end

end
