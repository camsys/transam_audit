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

    # Start to set up the query
    conditions  = []
    values      = []

    # Check to see if we got an organization to sub select on.
    @org_filter = params[:org_filter]
    conditions << 'organization_id IN (?)'
    if @org_filter.blank?
      values << @organization_list
      @org_filter = []
    else
      values << @org_filter
    end

    # Check to see if we got type to select on
    @types_filter = params[:types_filter]
    if @types_filter.blank?
      @types_filter = []
    else
      conditions << 'class_name IN (?)'
      values << @types_filter
    end

    # Check to see if we got an audit to sub select on.
    @audit_filter = params[:audit_filter]
    if @audit_filter.blank?
      @audit_filter = ''
    else
      conditions << 'audit_id = ?'
      values << @audit_filter
    end

    @audit_result_type_filter = params[:audit_result_type_filter]
    if @audit_result_type_filter.blank?
      @audit_result_type_filter = []
    else
      conditions << 'audit_result_type_id IN (?)'
      values << @audit_result_type_filter
    end


    # get the audit results for this organization
    @audit_results = AuditResult.where(conditions.join(' AND '), *values)

    # Get the list of audit types for this organization
    @types = AuditResult.where(:organization_id => @organization_list).pluck(:class_name).uniq

    # cache the set of object keys in case we need them later
    #cache_list(@activities, INDEX_KEY_LIST_VAR)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @audit_results }
    end
  end


  private

end
