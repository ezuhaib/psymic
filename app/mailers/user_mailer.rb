class UserMailer < ActionMailer::Base

	default :from => "\"Psymic\" <admin@psymic.com>"

	def registration_confirmation(user)
		@username = user.username
		mail(:to => user.email, :subject => "Registered")
  	end

	def unread_notifications(user_id)
		@activities = PublicActivity::Activity.where(recipient_id: user_id, read: false, mailed: false).all
		mail(:to => User.find(user_id).email, :subject => "You received #{@activities.count} new notifications in the last 12 hours")
	end

	def unread_messages(user_id)
		@messages = Message.where(recipient_id: user_id, read:nil, mailed:nil)
		@messages_count = @messages.count
		@messages.update_all(mailed: true)
		mail(:to => User.find(user_id).email, :subject => "You received #{@messages_count} new messages in the last 12 hours")
	end

	def sitewide_updates(update,email)
		@update = update
		mail(:to => email, :subject => "Update: #{update.title}")
	end

end
