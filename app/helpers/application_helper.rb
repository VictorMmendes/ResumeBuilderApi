module ApplicationHelper
  # Adicione esta linha mágica.
  # Ela permite chamar ApplicationHelper.embed_image direto, sem precisar de mixins.
  extend self

  def embed_image(filename)
    path = Rails.root.join("app", "assets", "images", filename)

    # Debug: Se der erro, vai avisar no log qual arquivo tentou ler
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
end
