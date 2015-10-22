class HomeController < ApplicationController

  def index
    @update = Update.new
    gon.contacts = build_json_for_contacts
  end

  protected

  def build_json_for_contacts
    Contact.all.map do |contact|
      {
        text: contact.name,
        value: contact.id,
        selected: false,
        description: contact.email,
        imageSrc: contact.photo.url
      }
    end.to_json
  end

end
