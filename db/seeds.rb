require 'nokogiri'
require 'open-uri'

#specify the number of contacts you need
MAX_RESULTS = 3000
CLIENT_ID = ENV["GOOGLE_CLIENT_ID"]

#get and parse the contacts with your access token
def get(token)
  url = "https://www.google.com/m8/feeds/contacts/#{User.first.email}/full?access_token=#{token}&max-results=#{MAX_RESULTS}"

  doc = Nokogiri::HTML(open(url))
  doc.css('entry').each do |item|

    #get external id
    base_uri = item.xpath('./id')[0].children.inner_text
    external_id = base_uri.gsub(/^.*\/(\w+)$/,'\1')

    #get contact name
    first_name = ''
    middle_name = ''
    last_name = ''
    name = item.xpath('./title')[0].children.inner_text
    formatted_name_array = name.split
    if formatted_name_array.size == 2
      first_name = formatted_name_array[0]
      last_name = formatted_name_array[1]
    elsif formatted_name_array.size == 3
      first_name = formatted_name_array[0]
      middle_name = formatted_name_array[1]
      last_name = formatted_name_array[2]
    elsif formatted_name_array.size == 1
      first_name = formatted_name_array[0]
    else
      first_name = formatted_name_array[0]
      middle_name = formatted_name_array[1]
      last_name = formatted_name_array[-1]
    end

    email = item.xpath('./email').attr('address').inner_text

    if item.xpath('./phonenumber') != nil
      phone = item.xpath('./phonenumber').inner_text
    end

    image_url = "#{item.xpath('./link').first.attr('href')}?access_token=#{token}"

    contact = Contact.new({
      source: 'google',
      uid: external_id,
      name: name,
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
      email: email,
      phone: phone,
      remote_photo_url: image_url
    })
    # unless contact.save
      # binding.pry
    # end
    contact.save
    puts "#{contact.name} - #{contact.email}"
  end
end

get(User.first.token)



require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'
require 'certified'
require 'pry'

APPLICATION_NAME = 'Standup'
CLIENT_SECRETS_PATH = "https://s3.amazonaws.com/standup-app/client_secret.json"
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "standup.json")
SCOPE = 'https://www.googleapis.com/auth/admin.directory.user.readonly'

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization request via InstalledAppFlow.
# If authorization is required, the user's default browser will be launched
# to approve the request.
#
# @return [Signet::OAuth2::Client] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
  storage = Google::APIClient::Storage.new(file_store)
  auth = storage.authorize

  if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
    # app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
    flow = Google::APIClient::InstalledAppFlow.new({
      :client_id => ENV["GOOGLE_CLIENT_ID"],
      :client_secret => ENV["GOOGLE_CLIENT_SECRET"],
      :scope => SCOPE})
    auth = flow.authorize(storage)
    # puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
  end
  auth
end

# Initialize the API
client = Google::APIClient.new(:application_name => APPLICATION_NAME)
client.authorization = authorize
directory_api = client.discovered_api('admin', 'directory_v1')

# List the first 10 users in the domain
results = client.execute!(
  :api_method => directory_api.users.list,
  :parameters => { :customer => 'my_customer',
                   :maxResults => 500,
                   :orderBy => 'email',
                   :viewType => 'domain_public' })

domain_results = results.data.users
nameless_contacts = Contact.where(name: "")

domain_results.each do |result|
  contact = nameless_contacts.find_by(email: result.emails.first["address"])
  next unless contact
  contact.name = result.name.fullName
  contact.first_name = result.name.givenName
  contact.last_name = result.name.familyName
  contact.save!
  puts "#{contact.name} updated"
end




# Remove all non-promoboxx contacts

Contact.all.each do |c|
  if c.email.split("@").last != "promoboxx.com"
    c.destroy
  end
end
