class Pack
  include Mongoid::Document
  field :name
  field :artist
  field :description
  field :profile_image
  field :preview_image
  embeds_many :stickers
  #create new packs from id_list.txt
  def self.initialize_packs
  	id_list = File.read(Rails.root + "lib/id_list.txt")
  	id_list.split(" ").map(&:to_i).each do |pack_id|
      puts "Running #{pack_id}"
      raw_pack = %x[#{"curl 'https://www.facebook.com/stickers/state/pack/?pack_id=#{pack_id}' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=pSzJU6pAa8xEf504vlDu2saR; c_user=100003129007260; fr=00qufS9QgHd4ZuzdX.AWWjVjNpcKmrNwaoCOo6TpGQXNc.BVJzcf.-7.AAA.0.AWWLpMYA; xs=234%3AI3gMeLoZeLen-g%3A2%3A1429430416%3A3735; csm=2; s=Aa7BRzyF0M1gtVC-.BVM2CQ; lu=whrnOWzNLLMTwNxPq7wJGWLw; p=-2; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1429430422273%2C%22jk%22%3A0%2C%22jk-ts%22%3A1429430422273%2C%22kb%22%3A1%2C%22kb-ts%22%3A1429430422273%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1429430422273%7D; presence=EM429430523EuserFA21B03129007260A2EstateFDsb2F1429430457489Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1429429817007EtrFnullEtwF2440659981EatF1429430523336G429430523456Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F10CC; act=1429430624624%2F18' -H 'x-firephp-version: 0.0.6' --data '__user=100003129007260&__a=1&__dyn=7nm8RW8BgBlymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWo8popyui9zob4q8zUK5Uc-dwIxbxjyaJ2aBgOGy9KbK&__req=1q&fb_dtsg=AQGUDsFvbmXh&ttstamp=26581718568115701189810988104&__rev=1696458' --compressed -k"}]
    
      raw_pack.gsub!("for (;;);","")
      raw_pack.gsub!('"','')
      json_packs = JSON.parse(raw_pack)
      pack_data = json_packs.fetch("payload")

      Pack.create(id: "#{pack_data.fetch("id")}", name: "#{pack_data.fetch("name")}", artist: "#{pack_data.fetch("artist")}", description: "#{pack_data.fetch("description")}", profile_image: "#{pack_data.fetch("profileImage")}", preview_image: "#{pack_data.fetch("previewImage")}")
    
   #    raw_sticker = %x[ #{"curl 'https://www.facebook.com/stickers/#{pack_id}/images/?sticker_size=64' -H 'origin: https://www.facebook.com' -H 'accept-encoding: gzip, deflate' -H 'accept-language: en-US,en;q=0.8,vi;q=0.6' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: */*' -H 'referer: https://www.facebook.com/' -H 'cookie: datr=pSzJU6pAa8xEf504vlDu2saR; c_user=100003129007260; fr=00qufS9QgHd4ZuzdX.AWWjVjNpcKmrNwaoCOo6TpGQXNc.BVJzcf.-7.AAA.0.AWWLpMYA; xs=234%3AI3gMeLoZeLen-g%3A2%3A1429430416%3A3735; csm=2; s=Aa7BRzyF0M1gtVC-.BVM2CQ; lu=whrnOWzNLLMTwNxPq7wJGWLw; p=-2; a11y=%7B%22sr%22%3A0%2C%22sr-ts%22%3A1429430422273%2C%22jk%22%3A0%2C%22jk-ts%22%3A1429430422273%2C%22kb%22%3A1%2C%22kb-ts%22%3A1429430422273%2C%22hcm%22%3A0%2C%22hcm-ts%22%3A1429430422273%7D; act=1429430484336%2F12; wd=1309x446; presence=EM429430523EuserFA21B03129007260A2EstateFDsb2F1429430457489Et2F_5bDiFA2user_3a1BB46367079A2ErF1C_5dElm2FA2user_3a1BB46367079A2Euct2F1429429817007EtrFnullEtwF2440659981EatF1429430523336G429430523456Etray_5fpack_5fidFA2350357561732812A2CEchFDp_5f1B03129007260F10CC' -H 'x-firephp-version: 0.0.6' --data '__user=100003129007260&__a=1&__dyn=7nm8RW8BgBlymfDgDxiWEyx97xN6yUgByVbGAEG8DDirWo8popyui9zob4q8zUK5Uc-dwIxbxjyaJ2aBgOGy9KbK&__req=1k&fb_dtsg=AQGUDsFvbmXh&ttstamp=26581718568115701189810988104&__rev=1696458' --compressed -k"} ]
	  
	  # raw_sticker.gsub!("for (;;);","")
	  # json_stickers = JSON.parse(raw_sticker)
	  # json_stickers.fetch("payload").collect {|index|  index.fetch("id")}
  	end
  end
end
