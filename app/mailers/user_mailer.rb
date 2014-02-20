class UserMailer < ActionMailer::Base

	default :from => "\"Psymic\" <admin@psymic.com>"

	def registration_confirmation(user)
		@username = user.username
		mail(:to => user.email, :subject => "Registered")
  	end

	def new_response_on_mindlog(response)
		@response = response
  	@mindlog = @response.mindlog
  	address = @mindlog.user.email
  	mail(:to => address, :subject => "New response over your mindlog: #{@mindlog.title}")
  end

end
