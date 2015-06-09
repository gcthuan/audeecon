class Pack
  include Mongoid::Document
  field :name
  field :artist
  field :description
  field :profile_image
  field :previews, type: Array
  embeds_many :stickers

  #create new packs from id_list.txt
  def self.initialize_packs
    all = %x[#{"curl 'https://www.facebook.com/stickers/state/store/' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/giang.c.thuan' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWUqhpOQS84lwq80jRlaNejJpgk.BVaWrf.99.AAA.0.AWVqHunC; xs=212%3A28UHUFP6tcbRqQ%3A2%3A1432971999%3A3735; csm=2; s=Aa7bat45mvyeLTF5.BVaWrf; lu=Rgbi7l-sLoGngxhQKrg78iNQ; p=-2; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1432972004623%2C%22jk%22%3A0%2C%22jk-ts%22%3A1432972004623%2C%22kb%22%3A1%2C%22kb-ts%22%3A1432972004623%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1432972004623%7D; act=1432972126530%2F8; presence=EM432972131EuserFA21B03129007260A2EstateFDsb2F1428746328106Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1432971401003EtrFnullEtwF2787795388EatF1432972131247G432972131522Etray_5fpack_5fidFA2599061016853145A2CEchFDp_5f1B03129007260F5CC; wd=1309x496' --data '__user=100003129007260&__a=1&__dyn=7AmajEyl2lm9o-t2u5bGya4Cq7pEsx6iqA8Ay9VQC-K26m6oKeDBwIhEoyUnwPUS2O4K5e8Gi4EOy28yQWxuFA4EK-&__req=1g&fb_dtsg=AQHUpOo7R1TZ&ttstamp=265817285112791115582498490&__rev=1761616' --compressed --compressed -k"}]
    all.gsub!("for (;;);", "")
    data = JSON.parse(all)
    data.fetch("payload").fetch("packs").collect do |index|
      pack_id = index.fetch("id")
      previews = index.fetch("previews")
      puts "Running #{pack_id}"
      raw_pack = %x[#{"curl 'https://www.facebook.com/stickers/state/pack/?pack_id=#{pack_id}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/giang.c.thuan' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWUqhpOQS84lwq80jRlaNejJpgk.BVaWrf.99.AAA.0.AWVqHunC; xs=212%3A28UHUFP6tcbRqQ%3A2%3A1432971999%3A3735; csm=2; s=Aa7bat45mvyeLTF5.BVaWrf; lu=Rgbi7l-sLoGngxhQKrg78iNQ; p=-2; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1432972004623%2C%22jk%22%3A0%2C%22jk-ts%22%3A1432972004623%2C%22kb%22%3A1%2C%22kb-ts%22%3A1432972004623%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1432972004623%7D; presence=EM432972273EuserFA21B03129007260A2EstateFDsb2F1428746328106Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1432971401004EtrFnullEtwF2787795388EatF1432972255916G432972273518Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F7CC; wd=1309x476; act=1432972321040%2F17' --data '__user=100003129007260&__a=1&__dyn=7AmajEyl2lm9o-t2u5bGya4Cq7pEsx6iqA8Ay9VQC-K26m6oKeDBwIhEoyUnwPUS2O4K5e8Gi4EOy28yQWxuFA4EK-&__req=1q&fb_dtsg=AQHUpOo7R1TZ&ttstamp=265817285112791115582498490&__rev=1761616' --compressed -k"}]
    
      raw_pack.gsub!("for (;;);","")
      json_packs = JSON.parse(raw_pack)
      pack_data = json_packs.fetch("payload")
      current_pack = Pack.create(id: "#{pack_id}", name: "#{pack_data.fetch("name")}", artist: "#{pack_data.fetch("artist")}", description: "#{pack_data.fetch("description")}", profile_image: "#{pack_data.fetch("profileImage")}", previews: previews)
      [64, 120, 240].each do |size|
        raw_sticker = %x[ #{"curl 'https://www.facebook.com/stickers/#{pack_id}/images/?sticker_size=#{size}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/giang.c.thuan' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWUqhpOQS84lwq80jRlaNejJpgk.BVaWrf.99.AAA.0.AWVqHunC; xs=212%3A28UHUFP6tcbRqQ%3A2%3A1432971999%3A3735; csm=2; s=Aa7bat45mvyeLTF5.BVaWrf; lu=Rgbi7l-sLoGngxhQKrg78iNQ; p=-2; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1432972004623%2C%22jk%22%3A0%2C%22jk-ts%22%3A1432972004623%2C%22kb%22%3A1%2C%22kb-ts%22%3A1432972004623%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1432972004623%7D; act=1432972126530%2F8; wd=1309x541; presence=EM432972205EuserFA21B03129007260A2EstateFDsb2F1428746328106Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1432971401004EtrFnullEtwF2787795388EatF1432972204872G432972204996Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F6CC' --data '__user=100003129007260&__a=1&__dyn=7AmajEyl2lm9o-t2u5bGya4Cq7pEsx6iqA8Ay9VQC-K26m6oKeDBwIhEoyUnwPUS2O4K5e8Gi4EOy28yQWxuFA4EK-&__req=1l&fb_dtsg=AQHUpOo7R1TZ&ttstamp=265817285112791115582498490&__rev=1761616' --compressed -k"} ]
        raw_sticker.gsub!("for (;;);","")
        json_stickers = JSON.parse(raw_sticker)
        json_stickers.fetch("payload").collect do |index|
          current_pack.stickers.create(sticker_id: "#{index.fetch("id")}", frame_count: index.fetch("frameCount"), frame_rate: index.fetch("frameRate"), frames_per_col: index.fetch("framesPerCol"), frames_per_row: index.fetch("framesPerRow"), height: index.fetch("height"), width: index.fetch("width"), source_uri: "#{index.fetch("sourceURI")}", uri: "#{index.fetch("uri")}", sprite_uri: "#{index.fetch("spriteURI")}", padded_sprite_uri: "#{index.fetch("paddedSpriteURI")}", request_size: size)
        end
      end
    end
  end
end
