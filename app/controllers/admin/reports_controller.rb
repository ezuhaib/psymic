class Admin::ReportsController < ApplicationController
  def index
  	@page_title = "Community Reports"
  	@mindlogs_array = Report.where(reportable_type:"Mindlog").pluck(:reportable_id)
    @mindlogs = Mindlog.find(@mindlogs_array)
  	authorize! :read , Report
  end

  def show
  	@page_title = "Community Reports"
  	@reportable = params[:reportable_type].classify.constantize.find(params[:reportable_id])
  	authorize! :read , Report
  end
end
