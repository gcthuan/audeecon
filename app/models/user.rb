class User
  include Mongoid::Document
  field :username

  has_one :recommender
  has_and_belongs_to_many :packs
  index({ username: 1 }, { unique: true, name: "username_index" })

  def purchase_pack pack_id
    self.packs << Pack.find(pack_id)
  end

  def unpurchase_pack pack_id
  	self.pack_ids.delete(pack_id)
    self.save
  end

end
