class Sticker
  include Mongoid::Document
  field :sticker_id
  field :_id, default: ->{ sticker_id }
  field	:frame_count, type: Integer
  field :frame_rate, type: Integer
  field :frames_per_col, type: Integer
  field :frames_per_row, type: Integer
  field :height, type: Integer
  field :width, type: Integer
  field :fullsize_uri
  field :thumbnail_uri
  field :fullsize_sprite_uri
  field :fullsize_padded_sprite_uri
  field :request_size, type: Integer
  belongs_to :pack
  has_and_belongs_to_many :categories
end
