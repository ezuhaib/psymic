class UserMailer < ActionMailer::Base

	default :from => "admin@psymic.com"

	def registration_confirmation(user)
		@username = user.username
		mail(:to => user.email, :subject => "Registered")
  	end
end
