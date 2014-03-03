class PagesController < ApplicationController

  def root
      @mindlogs = Mindlog.published.limit(6).all
  end

  def confirm_email
  end

  def not_found
  end

  def error
  end

end