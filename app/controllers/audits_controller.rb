#-------------------------------------------------------------------------------
# AuditsController
#-------------------------------------------------------------------------------
class AuditsController < OrganizationAwareController

  before_action :set_audit, only: [:show, :edit, :update, :destroy]
  before_action :reformat_date_fields, only: [:create, :update]

  INDEX_KEY_LIST_VAR  = "audits_list_cache_var"

  add_breadcrumb "Audits", :audits_path

  # Lock down the controller
  authorize_resource

  #-----------------------------------------------------------------------------
  # GET /audits
  # GET /audits.json
  #-----------------------------------------------------------------------------
  def index

    # Start to set up the query
    conditions  = []
    values      = []

    # Get the activities
    @audits = Audit.where(conditions.join(' AND '), *values).order("name, created_at DESC")

    # cache the set of object keys in case we need them later
    cache_list(@audits, INDEX_KEY_LIST_VAR)

    respond_to do |format|
      format.js
      format.html
      format.json { render :json => @audits }
    end

  end

  #-----------------------------------------------------------------------------
  # GET /audits/1
  # GET /audits/1.json
  #-----------------------------------------------------------------------------
  def show

    add_breadcrumb @audit

    # get the @prev_record_path and @next_record_path view vars
    get_next_and_prev_object_keys(@audit, INDEX_KEY_LIST_VAR)
    @prev_record_path = @prev_record_key.nil? ? "#" : audit_path(@prev_record_key)
    @next_record_path = @next_record_key.nil? ? "#" : audit_path(@next_record_key)

  end

  #-----------------------------------------------------------------------------
  # GET /audits/new
  #-----------------------------------------------------------------------------
  def new

    add_breadcrumb "New Audit"

    @audit = Audit.new

  end

  #-----------------------------------------------------------------------------
  # GET /audits/1/edit
  #-----------------------------------------------------------------------------
  def edit

    add_breadcrumb @audit, audit_path(@audit)
    add_breadcrumb "Update"

  end

  #-----------------------------------------------------------------------------
  # POST /audits
  # POST /audits.json
  #-----------------------------------------------------------------------------
  def create

    add_breadcrumb "New Audit"

    @audit = Audit.new(audit_params)

    respond_to do |format|
      if @audit.save

        job = AuditUpdateJob.new(@audit, current_user)
        Delayed::Job.enqueue job, :priority => 0

        notify_user :notice, 'Audit was successfully created.'
        format.html { redirect_to @audit }
        format.json { render :show, status: :created, location: @audit }
      else
        format.html { render :new }
        format.json { render json: @audit.errors, status: :unprocessable_entity }
      end
    end
  end

  #-----------------------------------------------------------------------------
  # PATCH/PUT /audits/1
  # PATCH/PUT /audits/1.json
  #-----------------------------------------------------------------------------
  def update

    add_breadcrumb @audit, audit_path(@audit)
    add_breadcrumb "Update"

    respond_to do |format|
      if @audit.update(audit_params)

        if (@audit.previous_changes.keys & ['start_date', 'end_date']).count > 0
          job = AuditUpdateJob.new(@audit, current_user)
          Delayed::Job.enqueue job, :priority => 0
        end

        notify_user :notice, 'Audit was successfully updated.'
        format.html { redirect_to @audit }
        format.json { render :show, status: :ok, location: @audit }
      else
        format.html { render :edit }
        format.json { render json: @audit.errors, status: :unprocessable_entity }
      end
    end
  end

  #-----------------------------------------------------------------------------
  # DELETE /audits/1
  # DELETE /audits/1.json
  #-----------------------------------------------------------------------------
  def destroy
    @audit.destroy
    respond_to do |format|
      notify_user :notice, 'Audit was successfully removed.'
      format.html { redirect_to audits_url }
      format.json { head :no_content }
    end
  end

  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------

  def reformat_date_fields
    params[:audit][:start_date] = reformat_date(params[:audit][:start_date]) unless params[:audit][:start_date].blank?
    params[:audit][:end_date] = reformat_date(params[:audit][:end_date]) unless params[:audit][:end_date].blank?
    params[:audit][:activity_attributes][:start_date] = reformat_date(params[:audit][:activity_attributes][:start_date]) unless params[:audit][:activity_attributes].blank? || params[:audit][:activity_attributes][:start_date].blank?
    params[:audit][:activity_attributes][:end_date] = reformat_date(params[:audit][:activity_attributes][:end_date]) unless params[:audit][:activity_attributes].blank? || params[:audit][:activity_attributes][:end_date].blank?
  end

  def reformat_date(date_str)
    form_date = Date.strptime(date_str, '%m/%d/%Y')
    return form_date.strftime('%Y-%m-%d')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_audit
    @audit = Audit.find_by(:object_key => params[:id])
    if @audit.nil?
      redirect_to '/404'
      return
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def audit_params
    params.require(:audit).permit(Audit.allowable_params)
  end
end
