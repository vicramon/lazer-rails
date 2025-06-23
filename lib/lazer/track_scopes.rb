module Lazer
  module TrackScopes
    extend ActiveSupport::Concern

    included do
      class << self
        def scope(name, options = nil, &block)
          defined_scopes[name] ||= options || block
          super
        end

        def defined_scopes
          @defined_scopes ||= {}
        end
      end
    end
  end
end
