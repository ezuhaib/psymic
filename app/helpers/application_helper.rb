module ApplicationHelper

def liquidize (string)
	Liquid::Template.parse(string).render({},:filters=>[LinkFilter]).html_safe
end

def link_to_submit(*args, &block)
  link_to_function (block_given? ? capture(&block) : args[0]), "$(this).closest('form').submit()", args.extract_options!
end

def get_comments(commentable)
	ajax_comments_path(commentable.class.name.downcase,commentable.id)
end

# Converts [[title]] and [[title|friendly_title]] tags to links
def wikify( text )
	r = /\[\[([\w _]+)(?:\||)([\w ?']+)?\]\]/
	text.gsub(r){link_to $2||$1,wiki_page_path($1)}
end

def admin_notifications_count
	m = Mindlog.where(workflow_state: ['awaiting_review','unpublished']).count
	u = @users_count = User.unread_by(current_user).count
	count = m+u
	return nil if count == 0
end

def notifications_count
	count = Notification.where(:user_id=>current_user.id).pluck(:counter).sum
end

def subscriptions_count
	count = current_user.subscriptions.where(counter:1).count
	return nil if count == 0
end

end