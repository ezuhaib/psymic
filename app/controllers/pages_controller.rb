class PagesController < ApplicationController

  def root
      if !current_user
        @mindlogs_count = Mindlog.published.count
        @page_title = "Welcome to Psymic"
        @page_description = "Psymic is a global support group and an online compilation of human behaviours and their analyses, termed as 'mindlogs'."
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