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
	reports_count = Report.where(reportable_type: "Mindlog").count('reportable_id',distinct: true)
	users_count = User.unread_by(current_user).count
	comics_count = Comic.where("status != ?",'published').count
    channel_items_count = ChannelItem.where(item_type:"Mindlog", status:"pending").count
	count = mindlogs_count+users_count+comics_count+channel_items_count+reports_count
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

def time_ago time, append = 'ago'
  return time_ago_in_words(time).gsub(/about|less than|almost|over/, '').strip.capitalize << " " + append
end

def title(title)
	@page_title = title
end

end