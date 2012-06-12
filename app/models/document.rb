class Document < ActiveRecord::Base
  attr_accessible :file, :remote_file_url, :user_id, :user_type, :room_id, :user_display_name
  
  mount_uploader :file, FileUploader
  after_create :broadcast

  def to_hash
    {
      room_id: room_id,
      user_name: user_display_name,
      user_id: user_id,
      user_type: user_type,
      message_type: self.class.name,
      body: file.url,
      # metadata: { },
      # created_at: created_at,
    }
  end

  def channel
    "/messages/#{room_id}"
  end

  def broadcast
    # WE NEED TO CHANGE THIS FOR PRODUCTION
    uri = URI.parse("http://localhost:3000/api/v1/messages.json")
    Net::HTTP.post_form(uri, :message => to_hash.to_json)
  end
end
