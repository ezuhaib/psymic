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

end