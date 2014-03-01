class PagesController < ApplicationController

  def root
      @mindlogs = Mindlog.published.limit(6).all
  end

  def confirm_email
  end

end