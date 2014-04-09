class PagesController < ApplicationController

  def root
      if !current_user
        @page_title = "Homepage"
        @mindlogs_count = Mindlog.published.count
      else
        flash[error] = flash.now[:error]
        redirect_to mindlogs_path
      end
  end

  def confirm_email
  end

  def not_found
  end

  def error
  end

end