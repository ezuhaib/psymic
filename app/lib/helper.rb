# Since escape_javascript is not available in .js.erb files, I'll need this
class Helper
  include ActionView::Helpers::JavaScriptHelper

  def self.escape_js( text )
    @instance ||= self.new
    return @instance.escape_javascript( text )
  end
end