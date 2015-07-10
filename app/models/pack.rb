class Pack
  include Mongoid::Document
  field :name
  field :artist
  field :description
  field :profile_image
  field :previews, type: Array
  has_many :stickers

  #create new packs from facebook stickers store
  def self.initialize_packs
    all = %x[#{"curl 'https://www.facebook.com/stickers/state/store/' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'csp: active' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWV1jQ9n940gsifaZIgm_K_ukg4.BVaWrf.99.AAA.0.AWXFz0-V; xs=186%3ArdCgyBpjHDbInw%3A2%3A1436518751%3A3735; csm=2; s=Aa5GWCbQDBPjWL7v.BVn4lf; lu=wgsh5kkTb2mV_1JEqi1Q4nvw; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1436518746790%2C%22jk%22%3A0%2C%22jk-ts%22%3A1436518746790%2C%22kb%22%3A1%2C%22kb-ts%22%3A1436518746790%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1436518746790%7D; p=-2; act=1436518757840%2F5; presence=EM436518952EuserFA21B03129007260A2EstateFDsb2F1435937884194Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1436518152005EtrFnullEtwF2946853BEatF1436518952766G436518952931Etray_5fpack_5fidFA21426512574306366A2CEchFDp_5f1B03129007260F6CC' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAFp8yut9LHwxBxvyui9DBwIhEyfyUnwPUS2O4K5e8CgyFEOy28yQq5QtxabLpbDGcCxC&__req=1r&fb_dtsg=AQElEzUALzKO&ttstamp=2658169108691228565761227579&__rev=1827440' --compressed -k"}]
    all.gsub!("for (;;);", "")
    data = JSON.parse(all)
    data.fetch("payload").fetch("packs").collect do |index|
      pack_id = index.fetch("id")
      previews = index.fetch("previews")
      puts "Running #{pack_id}"
      raw_pack = %x[#{"curl 'https://www.facebook.com/stickers/state/pack/?pack_id=#{pack_id}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'csp: active' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWV1jQ9n940gsifaZIgm_K_ukg4.BVaWrf.99.AAA.0.AWXFz0-V; xs=186%3ArdCgyBpjHDbInw%3A2%3A1436518751%3A3735; csm=2; s=Aa5GWCbQDBPjWL7v.BVn4lf; lu=wgsh5kkTb2mV_1JEqi1Q4nvw; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1436518746790%2C%22jk%22%3A0%2C%22jk-ts%22%3A1436518746790%2C%22kb%22%3A1%2C%22kb-ts%22%3A1436518746790%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1436518746790%7D; p=-2; presence=EM436518959EuserFA21B03129007260A2EstateFDsb2F1435937884194Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1436518152005EtrFnullEtwF2946853BEatF1436518958363G436518959083Etray_5fpack_5fidFA21426512574306366A2CEchFDp_5f1B03129007260F7CC; wd=1309x450; act=1436518993631%2F19' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAFp8yut9LHwxBxvyui9DBwIhEyfyUnwPUS2O4K5e8CgyFEOy28yQq5QtxabLpbDGcCxC&__req=1u&fb_dtsg=AQElEzUALzKO&ttstamp=2658169108691228565761227579&__rev=1827440' --compressed -k"}]
    
      raw_pack.gsub!("for (;;);","")
      json_packs = JSON.parse(raw_pack)
      pack_data = json_packs.fetch("payload")
      current_pack = Pack.create(id: "#{pack_id}", name: "#{pack_data.fetch("name")}", artist: "#{pack_data.fetch("artist")}", description: "#{pack_data.fetch("description")}", profile_image: "#{pack_data.fetch("profileImage")}", previews: previews)
      [240].each do |size|
        raw_sticker = %x[ #{"curl 'https://www.facebook.com/stickers/#{pack_id}/images/?sticker_size=#{size}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'csp: active' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWV1jQ9n940gsifaZIgm_K_ukg4.BVaWrf.99.AAA.0.AWXFz0-V; xs=186%3ArdCgyBpjHDbInw%3A2%3A1436518751%3A3735; csm=2; s=Aa5GWCbQDBPjWL7v.BVn4lf; lu=wgsh5kkTb2mV_1JEqi1Q4nvw; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1436518746790%2C%22jk%22%3A0%2C%22jk-ts%22%3A1436518746790%2C%22kb%22%3A1%2C%22kb-ts%22%3A1436518746790%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1436518746790%7D; p=-2; act=1436518757840%2F5; presence=EM436518944EuserFA21B03129007260A2EstateFDsb2F1435937884194Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1436518152005EtrFnullEtwF2946853BEatF1436518944382G436518944486Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F6CC; wd=1309x477' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAFp8yut9LHwxBxvyui9DBwIhEyfyUnwPUS2O4K5e8CgyFEOy28yQq5QtxabLpbDGcCxC&__req=1q&fb_dtsg=AQElEzUALzKO&ttstamp=2658169108691228565761227579&__rev=1827440' --compressed -k"} ]
        raw_sticker.gsub!("for (;;);","")
        json_stickers = JSON.parse(raw_sticker)
        json_stickers.fetch("payload").collect do |index|
          current_pack.stickers.create(sticker_id: "#{index.fetch("id")}", frame_count: index.fetch("frameCount"), frame_rate: index.fetch("frameRate"), frames_per_col: index.fetch("framesPerCol"), frames_per_row: index.fetch("framesPerRow"), height: index.fetch("height"), width: index.fetch("width"), thumbnail_uri: "#{index.fetch("uri")}", fullsize_uri: "#{index.fetch("uri")}", fullsize_sprite_uri: "#{index.fetch("spriteURI")}", fullsize_padded_sprite_uri: "#{index.fetch("paddedSpriteURI")}", request_size: size)
        end
      end
    end
  end
end
