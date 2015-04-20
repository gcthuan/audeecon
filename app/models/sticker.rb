class Sticker
  include Mongoid::Document
  field	:uri
  embedded_in :pack
end
