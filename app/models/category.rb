class Category
  include Mongoid::Document
  field :name
  has_and_belongs_to_many :stickers

  #index ({name: 1}, {unique: true, name: "name_index"})
end