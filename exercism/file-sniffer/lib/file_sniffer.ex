defmodule FileSniffer do
  @mime_exe "application/octet-stream"
  @mime_bmp "image/bmp"
  @mime_png "image/png"
  @mime_jpg "image/jpg"
  @mime_gif "image/gif"


  def type_from_extension("exe"), do: @mime_exe
  def type_from_extension("bmp"), do: @mime_bmp
  def type_from_extension("png"), do: @mime_png
  def type_from_extension("jpg"), do: @mime_jpg
  def type_from_extension("gif"), do: @mime_gif
  def type_from_extension(_), do: nil


  def type_from_binary(<<0x7F, 0x45, 0x4C, 0x46, _::binary>>), do: @mime_exe
  def type_from_binary(<<0x42, 0x4D, _::binary>>), do: @mime_bmp
  def type_from_binary(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: @mime_png
  def type_from_binary(<<0xFF, 0xD8, 0xFF, _::binary>>), do: @mime_jpg
  def type_from_binary(<<0x47, 0x49, 0x46, _::binary>>), do: @mime_gif
  def type_from_binary(_), do: nil

  def verify(file_binary, extension) do
    mime_binary = type_from_binary(file_binary)
    mime_extension = type_from_extension(extension)
    verify_mime(mime_binary, mime_extension)
  end

  defp verify_mime(mime, mime) when mime != nil, do: {:ok, mime}
  defp verify_mime(_, _), do: {:error, "Warning, file format and file extension do not match."}
end
