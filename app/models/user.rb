class User
  include Mongoid::Document
  field :username

  field :packs, type: Array
  has_one :recommender

  index({ username: 1 }, { unique: true, name: "username_index" })

  def purchase_pack pack_id
    self.add_to_set(packs: pack_id)
  end

  def unpurchase_pack pack_id
  	self.packs.delete(pack_id)
  	self.save
  end

end
