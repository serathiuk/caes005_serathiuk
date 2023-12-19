defmodule PaintByNumber do
  def palette_bit_size(color_count), do: do_palette_bit_size(color_count, 1)

  defp do_palette_bit_size(color_count, bit_count) do
    if Integer.pow(2, bit_count) >= color_count do
      bit_count
    else
      do_palette_bit_size(color_count, bit_count + 1)
    end
  end

  @spec empty_picture() :: <<>>
  def empty_picture(), do: <<>>

  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bit_size = palette_bit_size(color_count)
    <<pixel_color_index::size(bit_size), picture::bitstring>>
  end

  def get_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)

    case picture do
      <<pixel::size(bit_size), _::bitstring>> -> pixel
      _ -> nil
    end
  end

  def drop_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)

    case picture do
      <<_::size(bit_size), rest::bitstring>> -> rest
      _ -> <<>>
    end
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
