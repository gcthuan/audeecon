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
    all = %x[#{"curl 'https://www.facebook.com/stickers/state/store/' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWVQbqeRFq1qmNwXGYL9VL-SvGA.BVaWrf.99.AAA.0.AWXSjgho; xs=212%3A_GP3XamcYHexPg%3A2%3A1433840690%3A3735; csm=2; s=Aa61hfOvrcnj9vG9.BVdqwy; lu=SguvcVuypyjdTCzp-9ytWfNw; p=-2; act=1433840763207%2F5; presence=EM433840899EuserFA21B03129007260A2EstateFDsb2F1432981030520Et2F_5bDiFA2user_3a1BB33133148A2ErF1C_5dElm2FA2user_3a1BB33133148A2Euct2F1433840091003EtrFnullEtwF1106869484EatF1433840875767G433840899254Etray_5fpack_5fidFA2599061016853145A2CEchFDp_5f1B03129007260F5CC; wd=1309x462' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgBlymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8ponUDAyoS2N6y8-bxu3fzob8iUkUyHgyFEOy28yiq5RBoiyXSi&__req=1e&fb_dtsg=AQFFSclFvU9s&ttstamp=2658170708399108701188557115&__rev=1776439' --compressed -k"}]
    all.gsub!("for (;;);", "")
    data = JSON.parse(all)
    data.fetch("payload").fetch("packs").collect do |index|
      pack_id = index.fetch("id")
      previews = index.fetch("previews")
      puts "Running #{pack_id}"
      raw_pack = %x[#{"curl 'https://www.facebook.com/stickers/state/pack/?pack_id=#{pack_id}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWVQbqeRFq1qmNwXGYL9VL-SvGA.BVaWrf.99.AAA.0.AWXSjgho; xs=212%3A_GP3XamcYHexPg%3A2%3A1433840690%3A3735; csm=2; s=Aa61hfOvrcnj9vG9.BVdqwy; lu=SguvcVuypyjdTCzp-9ytWfNw; p=-2; presence=EM433840977EuserFA21B03129007260A2EstateFDsb2F1432981030520Et2F_5bDiFA2user_3a1BB33133148A2ErF1C_5dElm2FA2user_3a1BB33133148A2Euct2F1433840091003EtrFnullEtwF1106869484EatF1433840977543G433840977883Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F8CC; wd=1309x458; act=1433841003354%2F11' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgBlymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8ponUDAyoS2N6y8-bxu3fzob8iUkUyHgyFEOy28yiq5RBoiyXSi&__req=1o&fb_dtsg=AQFFSclFvU9s&ttstamp=2658170708399108701188557115&__rev=1776439' --compressed -k"}]
    
      raw_pack.gsub!("for (;;);","")
      json_packs = JSON.parse(raw_pack)
      pack_data = json_packs.fetch("payload")
      current_pack = Pack.create(id: "#{pack_id}", name: "#{pack_data.fetch("name")}", artist: "#{pack_data.fetch("artist")}", description: "#{pack_data.fetch("description")}", profile_image: "#{pack_data.fetch("profileImage")}", previews: previews)
      [64, 120, 240].each do |size|
        raw_sticker = %x[ #{"curl 'https://www.facebook.com/stickers/#{pack_id}/images/?sticker_size=#{size}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=mbMzVVrSXGsgCFS5wQZeWYGR; c_user=100003129007260; fr=0S55hucOBDfQT2K9o.AWVQbqeRFq1qmNwXGYL9VL-SvGA.BVaWrf.99.AAA.0.AWXSjgho; xs=212%3A_GP3XamcYHexPg%3A2%3A1433840690%3A3735; csm=2; s=Aa61hfOvrcnj9vG9.BVdqwy; lu=SguvcVuypyjdTCzp-9ytWfNw; p=-2; act=1433840763207%2F5; presence=EM433840768EuserFA21B03129007260A2EstateFDsb2F1432981030520Et2F_5bDiFA2user_3a1BB33133148A2ErF1C_5dElm2FA2user_3a1BB33133148A2Euct2F1433840091003EtrFnullEtwF1106869484EatF1433840765305G433840768648CEchFDp_5f1B03129007260F2CC' --data '__user=100003129007260&__a=1&__dyn=7Am8RW8BgBlymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWU8ponUDAyoS2N6y8-bxu3fzob8iUkUyHgyFEOy28yiq5RBoiyXSi&__req=16&fb_dtsg=AQFFSclFvU9s&ttstamp=2658170708399108701188557115&__rev=1776439' --compressed -k"} ]
        raw_sticker.gsub!("for (;;);","")
        json_stickers = JSON.parse(raw_sticker)
        json_stickers.fetch("payload").collect do |index|
          current_pack.stickers.create(sticker_id: "#{index.fetch("id")}", frame_count: index.fetch("frameCount"), frame_rate: index.fetch("frameRate"), frames_per_col: index.fetch("framesPerCol"), frames_per_row: index.fetch("framesPerRow"), height: index.fetch("height"), width: index.fetch("width"), source_uri: "#{index.fetch("sourceURI")}", uri: "#{index.fetch("uri")}", sprite_uri: "#{index.fetch("spriteURI")}", padded_sprite_uri: "#{index.fetch("paddedSpriteURI")}", request_size: size)
        end
      end
    end
  end
end
