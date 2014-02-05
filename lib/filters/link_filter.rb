module LinkFilter
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

	def link(input,source)
	link_to input,source
	end

	Liquid::Template.register_filter(LinkFilter)
end