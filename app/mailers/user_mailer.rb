class UserMailer < ActionMailer::Base

	default :from => "\"Psymic\" <admin@psymic.com>"

	def registration_confirmation(user)
		@username = user.username
		mail(:to => user.email, :subject => "Registered")
  	end

	def unread_notifications(user_id)
		@activities = PublicActivity::Activity.where(recipient_id: user_id, read: false, mailed: false).all
		mail(:to => User.find(user_id).email, :subject => "You received #{@activities.count} new responses and/or comments")
	end

end
