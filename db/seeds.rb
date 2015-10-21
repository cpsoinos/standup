require 'nokogiri'
require 'open-uri'

#specify the number of contacts you need
MAX_RESULTS = 3000
CLIENT_ID = ENV["GOOGLE_CLIENT_ID"]

#get and parse the contacts with your access token
def get(token)
  url = "https://www.google.com/m8/feeds/contacts/#{User.first.email}/full?access_token=#{token}"

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
    unless contact.save
      binding.pry
    end
  end
end

get(User.first.token)
