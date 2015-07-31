class Recommender
  include Mongoid::Document
  field :category, type: Hash, default: Hash.new {}
  field :previous_sticker_id, type: String, default: ""
  field :latest_recommendation, type: Array
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
  handle_asynchronously :initialize_data

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
      self.latest_recommendation = (0..Sticker.count-1).sort_by{rand}.slice(0, 5).collect! do |i|
        Sticker.skip(i).first._id
      end
      self.save!
      return self.latest_recommendation
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
    #get all purchased packs of the user
    @user = self.user
    packs_list = @user.packs.only(:_id).map(&:_id).shuffle
    #random a category in the sticker to recommend base on it
    random_category = Sticker.find(sticker_id).categories.skip(rand(Sticker.find(sticker_id).categories.count)).first
    if random_category.nil?
      purchased_stickers = Sticker.where(:pack_id.in => packs_list)
      self.latest_recommendation = (0..purchased_stickers.count-1).sort_by{rand}.slice(0, 5).collect! do |i|
        purchased_stickers.skip(i).first._id
      end
      self.save!
      return self.latest_recommendation
    end
    #get the best 5 recommended categories to the previous category
    sorted_list_of_category = self.category[random_category.name].sort_by(&:last).reverse
    recommended_category = []
    final_sticker = []
    (0..4).each do |i|
      recommended_category[i] = Category.where(name: sorted_list_of_category[i][0]).first
      #get the recommended stickers in the packs that the user has purchased of a category
      recommended_stickers_of_a_category = recommended_category[i].stickers.where(:pack_id.in => packs_list)
      final_sticker[i] = recommended_stickers_of_a_category.skip(rand(recommended_stickers_of_a_category.count)).first
      if final_sticker[i].nil?
        random_purchased_pack = Pack.find(packs_list.first)
        final_sticker[i] = (0..random_purchased_pack.stickers.count-1).sort_by{rand}.slice(0, 1).collect! do |i|
          random_purchased_pack.stickers.skip(i).first
        end
      end

    end

    self.latest_recommendation = final_sticker.map {|sticker| sticker.to_a.first._id}
    self.save!
    return self.latest_recommendation
  end

end
