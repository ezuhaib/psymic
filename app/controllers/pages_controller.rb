class PagesController < ApplicationController

  def root
      if !current_user
        @page_title = "Homepage"
        @mindlogs_count = Mindlog.published.count
      else
        redirect_to controller: 'mindlogs', action: 'index'
      end
  end

  def confirm_email
  end

  def not_found
  end

  def error
  end

end