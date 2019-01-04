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
    # @types = AuditResult.where(:organization_id => @organization_list).pluck(:class_name).uniq
    @filterable_types = AuditResult.where(:organization_id => @organization_list).pluck(:filterable_type, :filterable_id).uniq

    conditions = Hash.new

    #check to see if we got an auditableType to sub select on. If not assume Asset since it is the primary auditableType
    @auditable_type = params[:auditable_type]
    if @auditable_type.blank?
      @auditable_type = Rails.application.config.asset_base_class_name
    end

    # Filter by Organizaiton
    conditions[:organization_id] = params[:org_filter].blank? ? @organization_list : [params[:org_filter].to_i] & @organization_list

    # Check to see if we got type to select on
    # @types_filter = params[:types_filter]
    # if @types_filter.blank?
    #  @types_filter = [@types.first]
    # end
    #conditions[:class_name] = @types_filter


    # Check to see if we got type to select on
    @filterable_filter = params[:filterable_filter]
    if @filterable_filter.blank?
      @filterable_filter = [@filterable_types.first]
    end
    conditions[:filterable_type] = @filterable_filter[:filterable_type]
    conditions[:filterable_id] = @filterable_filter[:filterable_id]

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

    # cache the set of object keys in case we need them later
    #cache_list(@activities, INDEX_KEY_LIST_VAR)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @audit_results }
    end
  end


  private

end
