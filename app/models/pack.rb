class Pack
  include Mongoid::Document
  field :name
  field :artist
  field :description
  field :profile_image
  field :previews, type: Array
  has_many :stickers
  has_and_belongs_to_many :users

  #create new packs from facebook stickers store
  def self.initialize_packs store_curl
    cookie = store_curl[/-H.*/]
    all = %x[#{"curl 'https://www.facebook.com/stickers/state/store/' #{cookie} -k"}]
    all.gsub!("for (;;);", "")
    data = JSON.parse(all)
    data.fetch("payload").fetch("packs").collect do |index|
      pack_id = index.fetch("id")
      if !Pack.find(pack_id)
        previews = index.fetch("previews")
        puts "Running #{pack_id}"
        raw_pack = %x[#{"curl 'https://www.facebook.com/stickers/state/pack/?pack_id=#{pack_id}' #{cookie} -k"}]
    
        raw_pack.gsub!("for (;;);","")
        json_packs = JSON.parse(raw_pack)
        pack_data = json_packs.fetch("payload")
        current_pack = Pack.create(id: "#{pack_id}", name: "#{pack_data.fetch("name")}", artist: "#{pack_data.fetch("artist")}", description: "#{pack_data.fetch("description")}", profile_image: "#{pack_data.fetch("profileImage")}", previews: previews)
        [256].each do |size|
          raw_sticker = %x[ #{"curl 'https://www.facebook.com/stickers/#{pack_id}/images/?sticker_size=#{size}' #{cookie} -k"} ]
          raw_sticker.gsub!("for (;;);","")
          json_stickers = JSON.parse(raw_sticker)
          json_stickers.fetch("payload").collect do |index|
            current_pack.stickers.create(sticker_id: "#{index.fetch("id")}", frame_count: index.fetch("frameCount"), frame_rate: index.fetch("frameRate"), frames_per_col: index.fetch("framesPerCol"), frames_per_row: index.fetch("framesPerRow"), height: index.fetch("height"), width: index.fetch("width"), thumbnail_uri: "#{index.fetch("uri")}", fullsize_uri: "#{index.fetch("uri")}", fullsize_sprite_uri: "#{index.fetch("spriteURI")}", fullsize_padded_sprite_uri: "#{index.fetch("paddedSpriteURI")}", request_size: size)
          end
        end
      end
    end
  end

end
