class User < ApplicationRecord
    has_secure_password
    
    validates_presence_of :first_name, :last_name 
    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates_presence_of :password, :on => :create 
    validates_presence_of :password_confirmation, :on => :create 
    validates_confirmation_of :password, message: "does not match"
    validates_length_of :password, :minimum => 4, message: "must be at least 4 characters long", :allow_blank => true
    #what are the different users, do we specify admin here or no 
    validates_inclusion_of :role, in: %w( admin nurse ), message: "is not recognized in the system"

    scope :alphabetical, -> { order('last_name, first_name') }

    before_destroy :cannot_destroy_object

    def name
        "#{last_name}, #{first_name}"
    end
    
    def proper_name
        "#{first_name} #{last_name}"
    end

    
    ROLES = [['Admin', :admin],['Nurse', :nurse]]
    NURSEROLE = [['Nurse', :nurse]]

    def role?(authorized_role)
        return false if role.nil?
        role.downcase.to_sym == authorized_role
    end

    # login by username
    def self.authenticate(username, password)
        find_by_username(username).try(:authenticate, password)
    end

    def generate_password_token!
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!
    end
       
    def password_token_valid?
        (self.reset_password_sent_at + 4.hours) > Time.now.utc
    end
       
    def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        save!
    end
       
    private
       
    def generate_token
        SecureRandom.hex(10)
    end


end
