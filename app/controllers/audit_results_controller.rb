#-------------------------------------------------------------------------------
# AuditsResultsController
#-------------------------------------------------------------------------------
class AuditResultsController < OrganizationAwareController

  add_breadcrumb "Home", :root_path

  INDEX_KEY_LIST_VAR    = "audits_key_list_cache_var"

  # Protect controller methods using the cancan ability
  authorize_resource

  def index

    add_breadcrumb "Audit Results"

    @filterables = AuditResult.where(:organization_id => @organization_list).distinct.pluck(:filterable_type, :filterable_id)
    @filterables = [[nil,nil]] if @filterables.empty? # make sure there is an array even if no results

    conditions = Hash.new

    #check to see if we got an auditableType to sub select on. If not assume Asset since it is the primary auditableType
    @auditable_type = params[:auditable_type]
    if @auditable_type.blank?
      @auditable_type = Rails.application.config.asset_base_class_name
    end

    # Filter by Organizaiton
    conditions[:organization_id] = params[:org_filter].blank? ? @organization_list : [params[:org_filter].to_i] & @organization_list

    # Check to see if we got type to select on
    @filterable_filter = params[:filterable_filter]
    if @filterable_filter.blank?
      @filterable_filter = @filterables.first
    else
      @filterable_filter = @filterable_filter.split("-")
      @filterable_filter[1] = @filterable_filter[1].to_i
    end
    conditions[:filterable_type] = @filterable_filter[0]
    conditions[:filterable_id] = @filterable_filter[1]

    # Check to see if we got an audit to sub select on.
    @audit_filter = params[:audit_filter]
    if @audit_filter.blank?
      @audit_filter = ''
    else
      conditions[:audit_id] = @audit_filter
    end

    @audit_result_type_filter = params[:audit_result_type_filter]
    if @audit_result_type_filter.blank?
      @audit_result_type_filter = AuditResultType::AUDIT_RESULT_FAILED
    end
    conditions[:audit_result_type_id] = @audit_result_type_filter
    conditions[:auditable_type] = @auditable_type
    
    # get the audit results for this organization
    @audit_results = "#{@auditable_type}AuditResultsListReport".constantize.new.get_data(conditions)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @audit_results }
    end
  end


  private

end
