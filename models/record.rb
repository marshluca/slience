class Record

  include Mongoid::Document
  include Mongoid::Extension
  include Mongoid::Timestamps::Created

  field :key
  field :value

  embedded_in :feed

  def name
    key.split('-').map(&:capitalize).join(' ')
  end

  def unit
    UNITS[key]
  end

  UNITS = {
    'activity'       => 'bits',
    'glucose'        => 'bits',
    'temperature'    => 'bits',
    'heart-rate'     => 'bits',
    'sweat-analysis' => 'bits',
    'pulse'          => 'bits',
    'blood-pressure' => 'bits'
  }

end
