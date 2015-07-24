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
    #update recommender table, return if there is no previous sticker id (first time chatting)
    if self.previous_sticker_id == ""
      self.previous_sticker_id = sticker_id
      self.save!
      final_result = (0..Sticker.count-1).sort_by{rand}.slice(0, 5).collect! do |i|
        Sticker.skip(i).first._id
      end
      p final_result
      return final_result
    else
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
    #random a category in the sticker to recommend base on it
    random_category = Sticker.find(sticker_id).categories.skip(rand(Sticker.find(sticker_id).categories.count)).first
    if random_category.nil?
      final_result = (0..Sticker.count-1).sort_by{rand}.slice(0, 5).collect! do |i|
        Sticker.skip(i).first._id
      end
      p final_result
      return final_result
    end
    #get the best 5 recommended categories name to the previous category
    sorted_list_of_category = self.category[random_category.name].sort_by(&:last).reverse
    recommended_category_name_0 = sorted_list_of_category[0][0]
    recommended_category_name_1 = sorted_list_of_category[1][0]
    recommended_category_name_1 = sorted_list_of_category[2][0]
    recommended_category_name_1 = sorted_list_of_category[3][0]
    recommended_category_name_1 = sorted_list_of_category[4][0]
    #find the 5 categories using their names
    recommended_category_0 = Category.where(name: recommended_category_name_0).first
    recommended_category_1 = Category.where(name: recommended_category_name_1).first
    recommended_category_2 = Category.where(name: recommended_category_name_1).first
    recommended_category_3 = Category.where(name: recommended_category_name_1).first
    recommended_category_4 = Category.where(name: recommended_category_name_1).first
    #get the list of stickers of each category
    recommend_stickers_0 = recommended_category_0.stickers
    recommend_stickers_1 = recommended_category_1.stickers
    recommend_stickers_2 = recommended_category_2.stickers
    recommend_stickers_3 = recommended_category_3.stickers
    recommend_stickers_4 = recommended_category_4.stickers
    #return 5 random stickers from the 5 recommended categories, 1 sticker for 1 category
    result_0 = recommend_stickers_0.skip(rand(recommend_stickers_0.count)).first
    result_1 = recommend_stickers_1.skip(rand(recommend_stickers_1.count)).first
    result_2 = recommend_stickers_1.skip(rand(recommend_stickers_2.count)).first
    result_3 = recommend_stickers_1.skip(rand(recommend_stickers_3.count)).first
    result_4 = recommend_stickers_1.skip(rand(recommend_stickers_4.count)).first
    # result_0 = (0..recommend_stickers_0.count-1).sort_by{rand}.slice(0, 1).collect! do |i|
    #   recommend_stickers_0.skip(i).first
    # end
    # result_1 = (0..recommend_stickers_1.count-1).sort_by{rand}.slice(0, 1).collect! do |i|
    #   recommend_stickers_1.skip(i).first
    # end
    final_result = [result_0._id, result_1._id, result_2._id, result_3._id, result_4._id]
  end

end
