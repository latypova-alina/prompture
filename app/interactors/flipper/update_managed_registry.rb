module Flipper
  class UpdateManagedRegistry
    include Interactor

    delegate :desired_keys, to: :context

    def call
      FlipperManagedFeature.where.not(feature_key: desired_keys).delete_all
      desired_keys.each { |key| FlipperManagedFeature.find_or_create_by!(feature_key: key) }
    end
  end
end
