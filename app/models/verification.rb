class Verification
    include ActiveModel::Model

    attr_accessor :bottle_id, :patient_id

    validates :patient_id, presence: true
    validates :bottle_id, presence: true

    def verify
        # @patient = Patient.find(patient_id)
        # @bottle = Bottle.find(bottle_id)
        @bottle = Bottle.find(Bottle.get_bottle_id(bottle_id))
        @patient = Visit.where(account_number: patient_id).first.patient
        if @patient.id == @bottle.patient.id
            return true
        else
            return false
        end
    end

    def expired
        @bottle = Bottle.find(Bottle.get_bottle_id(bottle_id))
        if @bottle.expiration_date < DateTime.now
            return true
        else
            return false
        end
    end
end