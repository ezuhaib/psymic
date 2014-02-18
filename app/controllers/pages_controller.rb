class PagesController < ApplicationController

  def root
    if !current_user
      render "splash" , layout:false
    else
      @mindlogs = Mindlog.limit(6).all
    end
  end

end