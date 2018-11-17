# == Schema Information
#
# Table name: collection_entities
#
#  collection_album_id :integer
#  entity_id           :integer
#  entity_type         :string
#
# Indexes
#
#  index_collection_entities_on_collection_album_id_and_entity_id  (collection_album_id,entity_id)
#  index_collection_entities_on_entity_id_and_collection_album_id  (entity_id,collection_album_id)
#


require 'test_helper'

class CollectionEntityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
