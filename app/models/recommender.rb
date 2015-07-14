class Recommender
  include Mongoid::Document
  field :category, type: Hash, default: Hash.new {}
  field :previous_sticker_id, type: String, default: ""
  belongs_to :user

  def initialize_data
    number_of_category = Category.count
    #self.category = Hash.new {}
    (0..number_of_category-1).each do |i|
      self.category[Category.all[i].name] = {Category.all[i].name => 0}
      (0..number_of_category-1).each do |j|
        next if j == i
        self.category[Category.all[i].name][Category.all[j].name] = 0
      end
    end
    self.save!
  end

  # def recommend category
  #   self.category[category].max_by {|k, v| v}[0]
  # end

  def update sticker_id
    if self.previous_sticker_id != ""
      pre_sticker = Sticker.find(self.previous_sticker_id)
      cur_sticker = Sticker.find(sticker_id)
      pre_sticker.categories.each do |pre_category|
        cur_sticker.categories.each do |cur_category|
          self.category[pre_category.name][cur_category.name] += 1
        end
      end
    end
    self.previous_sticker_id = sticker_id
    self.save!
  end

  def recommend sticker_id
    sticker = Sticker.find(sticker_id)
    #random a category in the sticker to recommend base on it
    category = sticker.categories.skip(rand(sticker.categories.count)).first
    #get the best recommended category of the previous category
    recommended_category_name = self.category[category.name].sort_by(&:last).reverse[0][0]
    recommended_category = Category.where(name: recommended_category_name).first
    recommend_stickers = recommended_category.stickers
    #return random 20 stickers from the recommended category
    result = (0..recommend_stickers.count-1).sort_by{rand}.slice(0, 5).collect! do |i|
      recommend_stickers.skip(i).first
    end
  end

end
