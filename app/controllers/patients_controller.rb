class PatientsController < ApplicationController
    before_action :set_patient, only: [:show, :edit, :update, :destroy, :discharge]
    before_action :check_login
    def index
        @active_patients = Patient.active.alphabetical.paginate(page: params[:page]).per_page(15)
        @inactive_patients = Patient.inactive.alphabetical.paginate(page: params[:page]).per_page(15)
    end

    def show 
        #@recent_visits = @pet.visits.by_admission.last(10).to_a 
        @expired_bottles = Bottle.for_patient(@patient).expired.paginate(page: params[:expired_page]).per_page(5)
        @expiring_bottles_fridge = Bottle.for_patient(@patient).expiring_by_date(DateTime.now.next_day(1)).for_location("Fridge")
        @expiring_bottles_freezer = Bottle.for_patient(@patient).expiring_by_date(DateTime.now.next_day(7)).for_location("Freezer")
    end

    def new
        authorize! :new, @patient
        @patient = Patient.new
    end

    def create
        @patient = Patient.new(patient_params)
        if @patient.save
            # if saved to database
            flash[:notice] = "Successfully created #{@patient.proper_name}."
            redirect_to patient_path(@patient) # go to show patient page
        else
            # return to the 'new' form
            render action: 'new'
        end
    end

    def edit
        authorize! :update, @patient
    end

    def update
        authorize! :update, @patient
        if @patient.update_attributes(patient_params)
            flash[:notice] = "Updated all information on #{@patient.proper_name}"
            redirect_to @patient
        else
            render action: 'edit'
        end
    end

    def destroy
        authorize! :destroy, @patient
        @patient.destroy
        flash[:notice] = "Removed #{@patient.proper_name} from the system"
        redirect_to patients_url, notice: flash[:notice]

    end

    def discharge 
        @patient.get_current_visit.discharge_date = Date.current 
        @patient.admitted = false 
        @patient.save
        flash[:notice] = "Patient #{@patient.proper_name} discharged."
        redirect_to patient_path(@patient) 
    end 

    private

    def set_patient
        @patient = Patient.find(params[:id])
    end

    def patient_params
        params.require(:patient).permit(:patient_mrn, :first_name, :last_name, :dob, :active)
    end
end
