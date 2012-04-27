require "kaminari/sinatra"
require File.expand_path("../../lib/mongoid_extension", __FILE__)

class Feed
  include Mongoid::Document
  include Mongoid::Extension
  include Mongoid::Timestamps::Created

  embeds_one :user
  embeds_one :device
  embeds_one :record
  field :network

  index 'user.name'
  index 'device.uuid'
  index 'record.key'

  paginates_per 100
  validates_presence_of :user, :device, :record
  
  default_scope desc('created_at')
  scope :kind, lambda { |key| where('record.key' => key) }
  scope :from_user, lambda { |name| where('user.name' => name) }

  class << self
    def build(user, device, record={}, network=nil)
      create :user => user, :device => device, :record => Record.new(record), :network => network
    end
  end
end