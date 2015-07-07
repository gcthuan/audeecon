class Recommender
  include Mongoid::Document
  field :category, type: Hash, default: Hash.new {}
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

  def recommend category
    self.category[category].max_by {|k, v| v}[0]
  end
end
