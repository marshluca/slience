module Mongoid
  module Extension
    def self.included(receiver)
      receiver.extend ClassMethods
      receiver.class_eval { include InstanceMethods }
    end

    module ClassMethods
      def get(hash)
        self.first(:conditions => hash)
      end

      def all
        self.criteria.order_by([[:created_at, :asc]]).to_a
      end
    end

    module InstanceMethods
      def full_errors
        self.errors.full_messages.join(', ')
      end

      def method_missing(method, *args, &block)
        self.send(method, *args, &block) rescue nil
      end
      
      def timestamp
        self.created_at.to_s(:db)
      end

      def relative_time
        v = Time.now  - self.created_at
        return "just now" if v < 0
        case v
        when 0..1*60
          "just now"
        when 1*60..60*60
          "#{(v/60).to_i} mins ago"
        when 60*60*1..60*60*24
          "#{(v/(60*60)).to_i} hours ago"
        when 60*60*24..60*60*24*30
          "#{(v/(60*60*24)).to_i} days ago"
        when 60*60*24*30..60*60*24*30*12
          "#{(v/(60*60*24*30)).to_i} months ago"
        else
          "long long ago"
        end
      end
    end
  end
end
