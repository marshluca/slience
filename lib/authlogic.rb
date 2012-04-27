require "digest/sha1"

module Authlogic
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  module ClassMethods
    def authenticate(email, pass)
      user = get(:email => email)
      return if user.nil?
      encrypt(pass, user.salt) == user.hashed_password ? user : nil
    end

    def encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end

    def random_string(len)
       chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
       1.upto(len).inject('') { |str, i| str + chars[rand(chars.size-1)] }
    end
  end

  module InstanceMethods
    def encrypt_password
      return if password.blank?
      self.salt = self.class.random_string(10) unless self.salt
      self.hashed_password = self.class.encrypt(self.password, self.salt)
    end
  end
end
