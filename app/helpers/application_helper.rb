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

def render_mentions( text )
	r = /(^|\s)@(\w*)(\s|\z|$)/
	text.gsub(r){$1+(User.find_by_username($2) ? (link_to "@#{$2}",user_path($2)) : "@#{$2}" )+$3}
end

def admin_notifications_count
	mindlogs_count = Mindlog.where(workflow_state: ['awaiting_review','unpublished']).count
	users_count = User.unread_by(current_user).count
	count = mindlogs_count+users_count
	count == 0 ? nil : count
end

def notifications_count
	count = PublicActivity::Activity.where(:recipient_id => current_user.id,read: false).count
end

def subscriptions_count
	count = current_user.subscriptions.where(counter:1).count
	return nil if count == 0
end

def messages_count
	Message.where(recipient_id: current_user.id, read: nil).count
end

def get_rank(user)
	(User.order('points desc').index(user)+1).ordinalize
end

def dotiw(time)
	distance_of_time_in_words(Time.now, time, true, { :highest_measure_only => true })
end

end