class User
  include Mongoid::Document
  field :username
  field :packs, type: Array

  def purchase_pack pack_id
    self.add_to_set(packs: pack_id)
  end

end
