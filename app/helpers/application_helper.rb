module ApplicationHelper
  extend self

  def embed_image(filename)
    path = Rails.root.join("app", "assets", "images", filename)

    unless File.exist?(path)
      puts "ERRO: Imagem não encontrada em: #{path}"
      return ""
    end

    asset = File.read(path)
    ext = File.extname(path).delete(".")
    ext = "svg+xml" if ext == "svg"
    base64 = Base64.strict_encode64(asset)
    "data:image/#{ext};base64,#{base64}"
  end

  def embed_attachment(attachment)
    return "" unless attachment.attached?

    asset = attachment.download
    ext = attachment.filename.extension_with_delimiter.delete(".")
    base64 = Base64.strict_encode64(asset)
    "data:image/#{ext};base64,#{base64}"
  end

  def embed_font(filename)
    path = Rails.root.join("app", "assets", "fonts", filename)
    return "" unless File.exist?(path)

    mime_type = case File.extname(path)
    when ".ttf"
      "font/ttf"
    when ".otf"
      "font/otf"
    when ".woff"
      "font/woff"
    when ".woff2"
      "font/woff2"
    else
      "application/octet-stream"
    end

    asset = File.binread(path)
    base64 = Base64.strict_encode64(asset)
    "data:#{mime_type};base64,#{base64}"
  end
end
