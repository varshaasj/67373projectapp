require "openssl"

class Patient < ApplicationRecord
    include AppHelpers::Activeable::InstanceMethods
    extend AppHelpers::Activeable::ClassMethods

    # TODO: Store this as env var
    @@cipher_key = ENV["CIPHER_KEY"]
    # Relationships
    has_many :visits
    has_many :bottles 

    # Scopes
    scope :alphabetical, -> { order('last_name, first_name') }
    
    # Validations
    validates_presence_of :patient_mrn, :first_name, :last_name, :dob
    validates_uniqueness_of :patient_mrn
    validates_date :dob, :on_or_before => lambda { Date.current }

    before_create :encode_mrn 
    # Methods
    def name
        "#{last_name}, #{first_name}"
    end
    
    def proper_name
        "#{first_name} #{last_name}"
    end

    def get_age
        (((Date.today-self.dob).to_i)/365.25).to_i
    end

    def get_mrn
        puts self.patient_mrn
        decrypt(@@cipher_key, self.patient_mrn)
    end

    def get_current_visit
        if !self.admitted?
            return nil 
        end
        self.visits.select{|v| v.is_active?}.first
    end
    class << self
        def get_encrypted_mrn(mrn)
            encrypt(@@cipher_key, mrn)
        end
        private 

        def encrypt(key, str)
            cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
            cipher.key = key
            s = cipher.update(str) + cipher.final
            s.unpack('H*')[0].upcase
        end
    end

    private

    def encrypt(key, str)
            cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
            cipher.key = key
            s = cipher.update(str) + cipher.final
            s.unpack('H*')[0].upcase
    end
    def decrypt(key, str)
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
        cipher.key = key
        cipher.padding = 0
        s = [str].pack("H*").unpack("C*").pack("c*")
        cipher.update(s) + cipher.final
    end

    def encode_mrn
        self.patient_mrn = encrypt(@@cipher_key, self.patient_mrn)
    end
end
