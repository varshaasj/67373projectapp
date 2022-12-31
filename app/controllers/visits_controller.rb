class VisitsController < ApplicationController
    before_action :set_visit, only: [:show, :edit, :update, :destroy]
    before_action :check_login

    def index
        # get all visits in reverse chronological order, 10 per page
        @visits = Visit.by_admission.paginate(page: params[:page]).per_page(10)
    
    end
    def show
        get_related_data()
    end

    def new
        @visit = Visit.new
        puts params
        @visit.patient = Patient.find(params[:patient_id])
        @visit.admission_date = Date.current
    end

    def create
        @visit = Visit.new(visit_params)
        if @visit.save
          flash[:notice] = "Successfully admitted #{@visit.patient.proper_name}."
          redirect_to patient_path(@visit.patient)
        else
          render action: 'new'
        end
    end

    def destroy
        flash[:notice] = "Visits cannot be destroyed in the system"
        redirect_to @visit
    end

    private
    def set_visit
        @visit = Visit.find(params[:id])
    end
    def visit_params
        params.require(:visit).permit(:patient_id, :account_number, :admission_date)
    end

    def get_related_data
        @patient = @visit.patient
    end
end
