# require 'procedo/engine/intervention/product_parameter'

module Procedo
  module Engine
    class Intervention
      class Output < Procedo::Engine::Intervention::Quantified
        attr_reader :variant

        def initialize(intervention, id, attributes = {})
          super(intervention, id, attributes)
          if @attributes[:variant_id].present?
            @variant = ProductNatureVariant.find_by(id: @attributes[:variant_id])
          end
        end

        def variant_id
          @variant ? @variant.id : nil
        end

        def variant=(record)
          self.variant_id = record.id
        end

        def variant_id=(id)
          @variant = ProductNatureVariant.find_by(id: id)
          impact_dependencies!(:variant)
        end

        def to_hash
          hash = super
          hash[:variant_id] = @variant ? @variant.id : nil
          hash
        end

        def env
          { variant: variant }.merge(super)
        end
      end
    end
  end
end
