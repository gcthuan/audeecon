class Pack
  include Mongoid::Document
  field :name
  field :artist
  field :description
  field :profile_image
  field :previews, type: Array
  embeds_many :stickers
  embedded_in :user

  #create new packs from facebook stickers store
  def self.initialize_packs
    all = %x[#{"curl 'https://www.facebook.com/stickers/state/store/' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWW5HAedAPk8x4z7zx5_Gf6ijpc.BVaWrf.99.AAA.0.AWXH-EyF; xs=212%3Apk66s8QjFxYjHQ%3A2%3A1434709533%3A3735; csm=2; s=Aa7EGCz2e_nRA3oy.BVg-4d; lu=TgV4ffdCVn3qWlvGJDeVsOig; p=-2; act=1434710098081%2F11; presence=EM434710130EuserFA21B03129007260A2EstateFDsb2F1434710018342Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1434709764057EtrFnullEtwF1520254623EatF1434710130739G434710130765Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F32CC' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8ponUDAyoS2N6y8-bxu3fzob8iUkUyp2aCza88y99EnhS4EKZAKuE&__req=35&fb_dtsg=AQHZCWzlE3Cs&ttstamp=2658172906787122108695167115&__rev=1795047' --compressed -k"}]
    all.gsub!("for (;;);", "")
    data = JSON.parse(all)
    data.fetch("payload").fetch("packs").collect do |index|
      pack_id = index.fetch("id")
      previews = index.fetch("previews")
      puts "Running #{pack_id}"
      raw_pack = %x[#{"curl 'https://www.facebook.com/stickers/state/pack/?pack_id=#{pack_id}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWW5HAedAPk8x4z7zx5_Gf6ijpc.BVaWrf.99.AAA.0.AWXH-EyF; xs=212%3Apk66s8QjFxYjHQ%3A2%3A1434709533%3A3735; csm=2; s=Aa7EGCz2e_nRA3oy.BVg-4d; lu=TgV4ffdCVn3qWlvGJDeVsOig; p=-2; presence=EM434710130EuserFA21B03129007260A2EstateFDsb2F1434710018342Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1434709764057EtrFnullEtwF1520254623EatF1434710130739G434710130765Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F32CC; act=1434710140078%2F15' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8ponUDAyoS2N6y8-bxu3fzob8iUkUyp2aCza88y99EnhS4EKZAKuE&__req=38&fb_dtsg=AQHZCWzlE3Cs&ttstamp=2658172906787122108695167115&__rev=1795047' --compressed -k"}]
    
      raw_pack.gsub!("for (;;);","")
      json_packs = JSON.parse(raw_pack)
      pack_data = json_packs.fetch("payload")
      current_pack = Pack.create(id: "#{pack_id}", name: "#{pack_data.fetch("name")}", artist: "#{pack_data.fetch("artist")}", description: "#{pack_data.fetch("description")}", profile_image: "#{pack_data.fetch("profileImage")}", previews: previews)
      [64, 120, 240].each do |size|
        raw_sticker = %x[ #{"curl 'https://www.facebook.com/stickers/#{pack_id}/images/?sticker_size=#{size}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWW5HAedAPk8x4z7zx5_Gf6ijpc.BVaWrf.99.AAA.0.AWXH-EyF; xs=212%3Apk66s8QjFxYjHQ%3A2%3A1434709533%3A3735; csm=2; s=Aa7EGCz2e_nRA3oy.BVg-4d; lu=TgV4ffdCVn3qWlvGJDeVsOig; p=-2; act=1434710098081%2F11; wd=1309x507; presence=EM434710130EuserFA21B03129007260A2EstateFDsb2F1434710018342Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1434709764057EtrFnullEtwF1520254623EatF1434710130739G434710130765Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F32CC' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8ponUDAyoS2N6y8-bxu3fzob8iUkUyp2aCza88y99EnhS4EKZAKuE&__req=34&fb_dtsg=AQHZCWzlE3Cs&ttstamp=2658172906787122108695167115&__rev=1795047' --compressed -k"} ]
        raw_sticker.gsub!("for (;;);","")
        json_stickers = JSON.parse(raw_sticker)
        json_stickers.fetch("payload").collect do |index|
          current_pack.stickers.create(sticker_id: "#{index.fetch("id")}", frame_count: index.fetch("frameCount"), frame_rate: index.fetch("frameRate"), frames_per_col: index.fetch("framesPerCol"), frames_per_row: index.fetch("framesPerRow"), height: index.fetch("height"), width: index.fetch("width"), source_uri: "#{index.fetch("sourceURI")}", uri: "#{index.fetch("uri")}", sprite_uri: "#{index.fetch("spriteURI")}", padded_sprite_uri: "#{index.fetch("paddedSpriteURI")}", request_size: size)
        end
      end
    end
  end
end
