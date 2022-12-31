class BottlesController < ApplicationController
    before_action :set_bottle, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    def index
        @active_bottles = Bottle.active.by_patient.paginate(page: params[:page]).per_page(15)
    end

    def new
        authorize! :new, @bottle
        @bottle = Bottle.new
        puts params
        @bottle.patient = Patient.find(params[:patient_id])
    end

    def create
        authorize! :create, @bottle
        puts params[:other][:amount]
        amount = params[:other][:amount]
        if amount == ""
            render action: 'new'
            return
        end
        (amount.to_i).times do 
            @bottle = Bottle.new(create_params)
            if !@bottle.save 
                render action: 'new'
                return
            end
        end
        flash[:notice] = "Successfully created bottles for patient."
        redirect_to patient_path(@bottle.patient) # go to show bottle page
        # @bottle = Bottle.new(bottle_params)
        # if @bottle.save
        #     # if saved to database
        #     flash[:notice] = "Successfully created bottle."
        #     redirect_to bottle_path(@bottle) # go to show bottle page
        # else
        #     # return to the 'new' form
        #     render action: 'new'
        # end
    end

    def edit
    end

    def show  
        
    end

    def update
        if params[:other][:confirm]
            @bottle.storage_location = @bottle.storage_location.downcase == "fridge" ? "Freezer" : "Fridge"
            @bottle.save
            flash[:notice] = "Updated storage location on bottle"
        end
        redirect_to patient_path(@bottle.patient)
    end

    def destroy
        authorize! :destroy, @bottle
        path = @bottle.get_qr_path
        puts path
        File.delete(path) if File.exist?(path)
        @bottle.destroy
        flash[:notice] = "Removed bottle from the system"
        redirect_to bottles_url, notice: flash[:notice]
    end

    
    private
    def set_bottle
        @bottle = Bottle.find(params[:id])
    end


    def create_params
        params.require(:bottle).permit(:patient_id, :checkin_nurse_id_id, :collected_date, :storage_location)
    end
end
