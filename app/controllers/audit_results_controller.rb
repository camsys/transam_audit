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

    # Get the list of audit types for this organization
    @types = AuditResult.where(:organization_id => @organization_list).pluck(:class_name).uniq

    conditions = Hash.new

    # Check to see if we got an organization to sub select on.
    @org_filter = params[:org_filter]
    if @org_filter.blank?
      @org_filter = [@organization_list.first]
    end
    conditions[:organization_id] = @org_filter

    # Check to see if we got type to select on
    @types_filter = params[:types_filter]
    if @types_filter.blank?
      @types_filter = [@types.first]
    end
    conditions[:class_name] = @types_filter

    # Check to see if we got an audit to sub select on.
    @audit_filter = params[:audit_filter]
    if @audit_filter.blank?
      @audit_filter = ''
    else
      conditions[:audit_id] = @audit_filter
    end

    @audit_result_type_filter = params[:audit_result_type_filter]
    if @audit_result_type_filter.blank?
      @audit_result_type_filter = [AuditResultType::AUDIT_RESULT_FAILED]
    end
    conditions[audit_result_type_id: @audit_result_type_filter]

    # get the audit results for this organization
    # hard coded to assets right now cause views are just for assets
    @audit_results = AuditResult.search_auditable(conditions, 'Asset', {disposition_date: nil})

    # cache the set of object keys in case we need them later
    #cache_list(@activities, INDEX_KEY_LIST_VAR)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @audit_results }
    end
  end


  private

end
