module Shoppe
  class User < ActiveRecord::Base

    self.table_name = 'shoppe_users'

    has_secure_password

    # Validations
    validates :first_name, :presence => true
    validates :last_name, :presence => true
    validates :email_address, :presence => true

    # The user's first name & last name concatenated
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end

    # The user's first name & initial of last name concatenated
    #
    # @return [String]
    def short_name
      "#{first_name} #{last_name[0,1]}"
    end

    # Reset the user's password to something random and e-mail it to them
    def reset_password!
      self.password = SecureRandom.hex(8)
      self.password_confirmation = self.password
      self.save!
      Shoppe::UserMailer.new_password(self).deliver
    end

    # Attempt to authenticate a user based on email & password. Returns the
    # user if successful otherwise returns false.
    #
    # @param email_address [String]
    # @param paassword [String]
    # @return [Shoppe::User]
    def self.authenticate(email_address, password)
      user = self.where(:email_address => email_address).first
      return false if user.nil?
      return false unless user.authenticate(password)
      user
    end

  end
end
