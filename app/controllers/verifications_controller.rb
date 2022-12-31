class VerificationsController < ApplicationController
    before_action :set_verification, only: [:success, :failed, :expired]
    before_action :check_login  
    def new
      @verifier = Verification.new
    end

    def create
        @verifier = Verification.new(verification_params)
        @bottle = Bottle.find(Bottle.get_bottle_id(@verifier.bottle_id))
        @patient = Visit.where(account_number: @verifier.patient_id).first.patient
        # @patient = Patient.find(@verifier.patient_id)
        if @verifier.verify && !@verifier.expired
          redirect_to success_path(@patient, @bottle)
        elsif @verifier.verify && @verifier.expired
          redirect_to expired_path(@patient,@bottle)
        else
          redirect_to failed_path(@patient, @bottle)
        end
    end

    def success
    end

    def failed
    end

    def expired
    end

    private
    def set_verification
      @patient = Patient.find(params[:patient_id])
      @bottle = Bottle.find(params[:bottle_id])
    end

    def verification_params
        params.require(:verification).permit(:patient_id, :bottle_id)
    end
  end