class Visit < ApplicationRecord
  #include AppHelpers::Deletions
  
  belongs_to :patient 

  # Scopes
  # by_admission -- orders results chronologically by admission date
  # by_discharge -- orders results chronologically by discharge date
  scope :by_admission, lambda { order('admission_date DESC') }
  scope :by_discharge, lambda { order('discharge_date DESC') }
  scope :for_patient, -> (patient) { where(patient_id: patient.id) }

  # Validations
  validates_presence_of :patient_id, :account_number, :admission_date
  validates_uniqueness_of :account_number
  validates_date :admission_date, :on_or_before => :discharge_date
  validate :is_admitted, on: :create

  before_save :admit_patient
  before_destroy :cannot_destroy_object

  def is_active?
    self.discharge_date == nil
  end
  private 
  def admit_patient
    self.patient.admitted = true unless !self.is_active?
    self.patient.save
  end
  def is_admitted
    # all_visits = Visit.for_patient(self.patient).select{|v| v.is_active?}
    if (self.patient.admitted)
      self.errors.add(:base, "Patient #{self.patient.proper_name} has already been admitted!")
    end
  end


end
