heroku ps:scale worker=1
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default
