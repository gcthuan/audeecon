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
  def self.initialize_packs
    all = %x[#{"curl 'https://www.facebook.com/stickers/state/store/' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'csp: active' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/?_rdr=p' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; locale=vi_VN; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWVmsLKUADVpMAi-1gs111FNC3M.BVaWrf.99.AAA.0.AWWOOrGB; xs=186%3A3Vx6R_ZkofaEJw%3A2%3A1438163120%3A3735; csm=2; s=Aa4BVLRX75WO4l72.BVuKCw; lu=RgTcJdBxOizLWI7TBFbMhChw; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1438163117082%2C%22jk%22%3A0%2C%22jk-ts%22%3A1438163117082%2C%22kb%22%3A3%2C%22kb-ts%22%3A1438163117082%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1438163117082%7D; p=-2; act=1438164191950%2F0; presence=EM438164245EuserFA21B03129007260A2EstateFDsb2F1438163794735Et2F_5bDiFA2user_3a1B00104061107A2ErF1C_5dElm2FA2user_3a1B00104061107A2Euct2F1438162521013EtrFnullEtwF1085792919EatF1438164245759G438164245775Etray_5fpack_5fidFA21426512574306366A2CEchFDp_5f1B03129007260F0CC' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8popyui9zob4q8zUK5Uc-dwIxi5e8CgyEjEwy8ACxt7oizZAKuEOqUlzV8&__req=w&fb_dtsg=AQFg-p8-E08a&ttstamp=265817010345112564569485697&__rev=1858565' --compressed -k"}]
    all.gsub!("for (;;);", "")
    data = JSON.parse(all)
    data.fetch("payload").fetch("packs").collect do |index|
      pack_id = index.fetch("id")
      previews = index.fetch("previews")
      puts "Running #{pack_id}"
      raw_pack = %x[#{"curl 'https://www.facebook.com/stickers/state/pack/?pack_id=#{pack_id}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'csp: active' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/?_rdr=p' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; locale=vi_VN; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWVmsLKUADVpMAi-1gs111FNC3M.BVaWrf.99.AAA.0.AWWOOrGB; xs=186%3A3Vx6R_ZkofaEJw%3A2%3A1438163120%3A3735; csm=2; s=Aa4BVLRX75WO4l72.BVuKCw; lu=RgTcJdBxOizLWI7TBFbMhChw; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1438163117082%2C%22jk%22%3A0%2C%22jk-ts%22%3A1438163117082%2C%22kb%22%3A3%2C%22kb-ts%22%3A1438163117082%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1438163117082%7D; p=-2; presence=EM438164245EuserFA21B03129007260A2EstateFDsb2F1438163794735Et2F_5bDiFA2user_3a1B00104061107A2ErF1C_5dElm2FA2user_3a1B00104061107A2Euct2F1438162521013EtrFnullEtwF1085792919EatF1438164245759G438164245775Etray_5fpack_5fidFA21426512574306366A2CEchFDp_5f1B03129007260F0CC; act=1438164256815%2F5' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8popyui9zob4q8zUK5Uc-dwIxi5e8CgyEjEwy8ACxt7oizZAKuEOqUlzV8&__req=z&fb_dtsg=AQFg-p8-E08a&ttstamp=265817010345112564569485697&__rev=1858565' --compressed -k"}]
    
      raw_pack.gsub!("for (;;);","")
      json_packs = JSON.parse(raw_pack)
      pack_data = json_packs.fetch("payload")
      current_pack = Pack.create(id: "#{pack_id}", name: "#{pack_data.fetch("name")}", artist: "#{pack_data.fetch("artist")}", description: "#{pack_data.fetch("description")}", profile_image: "#{pack_data.fetch("profileImage")}", previews: previews)
      [256].each do |size|
        raw_sticker = %x[ #{"curl 'https://www.facebook.com/stickers/#{pack_id}/images/?sticker_size=#{size}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'csp: active' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.132 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/?_rdr=p' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; locale=vi_VN; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWVmsLKUADVpMAi-1gs111FNC3M.BVaWrf.99.AAA.0.AWWOOrGB; xs=186%3A3Vx6R_ZkofaEJw%3A2%3A1438163120%3A3735; csm=2; s=Aa4BVLRX75WO4l72.BVuKCw; lu=RgTcJdBxOizLWI7TBFbMhChw; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1438163117082%2C%22jk%22%3A0%2C%22jk-ts%22%3A1438163117082%2C%22kb%22%3A3%2C%22kb-ts%22%3A1438163117082%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1438163117082%7D; p=-2; act=1438164191950%2F0; presence=EM438164245EuserFA21B03129007260A2EstateFDsb2F1438163794735Et2F_5bDiFA2user_3a1B00104061107A2ErF1C_5dElm2FA2user_3a1B00104061107A2Euct2F1438162521013EtrFnullEtwF1085792919EatF1438164245759G438164245775Etray_5fpack_5fidFA21426512574306366A2CEchFDp_5f1B03129007260F0CC' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgCBymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8popyui9zob4q8zUK5Uc-dwIxi5e8CgyEjEwy8ACxt7oizZAKuEOqUlzV8&__req=v&fb_dtsg=AQFg-p8-E08a&ttstamp=265817010345112564569485697&__rev=1858565' --compressed -k"} ]
        raw_sticker.gsub!("for (;;);","")
        json_stickers = JSON.parse(raw_sticker)
        json_stickers.fetch("payload").collect do |index|
          current_pack.stickers.create(sticker_id: "#{index.fetch("id")}", frame_count: index.fetch("frameCount"), frame_rate: index.fetch("frameRate"), frames_per_col: index.fetch("framesPerCol"), frames_per_row: index.fetch("framesPerRow"), height: index.fetch("height"), width: index.fetch("width"), thumbnail_uri: "#{index.fetch("uri")}", fullsize_uri: "#{index.fetch("uri")}", fullsize_sprite_uri: "#{index.fetch("spriteURI")}", fullsize_padded_sprite_uri: "#{index.fetch("paddedSpriteURI")}", request_size: size)
        end
      end
    end
  end
end
