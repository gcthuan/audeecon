class Category
  include Mongoid::Document
  field :name
  has_and_belongs_to_many :stickers

  #index ({name: 1}, {unique: true, name: "name_index"})

  def self.initialize_categories
  	categories_list = File.read('lib/categories/categories_list.txt').split("\n").map
  	categories_list.each do |category|
  	  stickers_list = File.read("lib/categories/#{category}.txt").split("\n").map
      Category.where(name: "#{category}").nil? ? current_category = Category.create(name: "#{category}") : current_category = Category.where(name: "#{category}").first
  	  stickers_list.each do |sticker_id|
  	    sticker = Sticker.find(sticker_id)
  	    current_category.stickers << sticker
      end
  	end
  end
end