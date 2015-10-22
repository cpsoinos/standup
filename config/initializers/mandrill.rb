ActionMailer::Base.smtp_settings = {
  address: ENV["SMTP_ADDRESS"],
  port: 587,
  enable_starttls_auto: true,
  user_name: ENV["SMTP_USERNAME"],
  password: ENV["SMTP_PASSWORD"],
  authentication: :plain
}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default charset: "utf-8"
