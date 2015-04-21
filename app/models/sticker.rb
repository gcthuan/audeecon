class Sticker
  include Mongoid::Document
  field :sticker_id
  field	:frame_count, type: Integer
  field :frame_rate, type: Integer
  field :frames_per_col, type: Integer
  field :frames_per_row, type: Integer
  field :height, type: Integer
  field :width, type: Integer
  field :source_uri
  field :uri
  field :sprite_uri
  field :padded_sprite_uri
  embedded_in :pack
end
