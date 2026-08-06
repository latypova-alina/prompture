# Tracks which Flipper boolean gates are currently declared in config/flipper_features.yml,
# so Flipper::Synchronizer can tell "removed from the file" apart from "never file-managed"
# and only ever clean up flags it actually owns.
class FlipperManagedFeature < ApplicationRecord
  validates :feature_key, presence: true, uniqueness: true
end
