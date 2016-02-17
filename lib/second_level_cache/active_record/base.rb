# -*- encoding : utf-8 -*-
module SecondLevelCache
  module ActiveRecord
    module Base
      extend ActiveSupport::Concern

      included do
        after_commit :expire_second_level_cache, :on => :destroy
        after_commit :update_second_level_cache, :on => :update
        after_commit :write_second_level_cache, :on => :create
      end

      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end

      module ClassMethods
        def update_counters(id, counters)
          super(id, counters).tap do
            Array(id).each{|i| expire_second_level_cache(i)}
          end
        end
      end
    end
  end
end
