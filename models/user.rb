require "gravtastic"
require File.expand_path("../../lib/authlogic", __FILE__)
require File.expand_path("../../lib/mongoid_extension", __FILE__)

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Extension
  include Authlogic
  include Gravtastic

  gravtastic :secure => true, :filetype => :png, :size => 40

  field :email
  field :name
  field :salt
  field :hashed_password
  key :name

  validates_confirmation_of :password
  validate :email, :uniqueness => true, :presence => true, :format => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i    

  attr_accessor :password, :password_confirmation
  before_save :encrypt_password

  class << self
    def build(hash={})
      attrs = %w(name email password password_confirmation)
      create attrs.map(&:to_sym).inject({}) { |h, e| h[e] = hash[e]; h }
    end
  end
  
  def profile
    {:id => id.to_s, :name => name.to_s, :email => email.to_s}
  end
end