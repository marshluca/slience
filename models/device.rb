class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Extension

  FIELDS = %w(uuid name model locale version)
  FIELDS.map { |attr| field attr }
  key :uuid

  validates_uniqueness_of :uuid
  validates_presence_of :uuid, :name, :model, :locale, :version

  class << self
    def find_or_build_by(hash={})
      device = Device.get(:uuid => hash['uuid'])
      return device if device
      create FIELDS.map(&:to_sym).inject({}) { |h, e| h[e] = hash[e.to_s]; h }
    end
  end
end
