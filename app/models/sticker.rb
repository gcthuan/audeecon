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
  field :request_size, type: Integer
  belongs_to :pack
  has_and_belongs_to_many :categories
end
