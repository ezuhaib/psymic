class Update < ActiveRecord::Base
  attr_accessible :body, :title, :user_id
  validates_presence_of :title , :body , :user_id
  after_create :send_mails

  def send_mails
  	User.find_each do |u|
  		UserMailer.sitewide_updates(self,u.email).deliver if u.email_site_updates == true
	end
  end

end
