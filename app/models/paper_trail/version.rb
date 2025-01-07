module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern
    # attr_accessor :item_type, :item_id, :event, :whodunnit, :object, :object_changes, :created_at
  end
end