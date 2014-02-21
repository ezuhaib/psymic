class PagesController < ApplicationController

  def root
      @mindlogs = Mindlog.limit(6).all
  end

  def confirm_email
  end

end