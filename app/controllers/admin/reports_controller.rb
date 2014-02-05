class Admin::ReportsController < ApplicationController
  def index
  	@mindlogs = Mindlog.where("reports_counter > 0")
  	authorize! :read , Report
  end

  def show
  	@reportable = Report.where("reportable_type = ? AND reportable_id = ?",params[:reportable_type].capitalize,params[:reportable_id]).first.reportable
  	authorize! :read , Report
  end
end
