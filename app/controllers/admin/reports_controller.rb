class Admin::ReportsController < ApplicationController
  def index
  	@page_title = "Community Reports"
  	@mindlogs = Mindlog.where("reports_counter > 0")
  	authorize! :read , Report
  end

  def show
  	@page_title = "Community Reports"
  	@reportable = Report.where("reportable_type = ? AND reportable_id = ?",params[:reportable_type].capitalize,params[:reportable_id]).first.reportable
  	authorize! :read , Report
  end
end
