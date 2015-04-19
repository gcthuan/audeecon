class Sticker
  include Mongoid::Document
  field :id
  field	:uri
  field :source_uri
  embedded_in :pack
end
