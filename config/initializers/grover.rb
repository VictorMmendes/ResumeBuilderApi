# config/initializers/grover.rb
Grover.configure do |config|
  config.options = {
    format: "A4",
    margin: { top: "0px", bottom: "0px" }, # Margens zero para controlar via CSS
    prefer_css_page_size: true,
    emulate_media: "screen", # Força o CSS a agir como tela, não impressão
    print_background: true, # <--- ESSA LINHA É OBRIGATÓRIA PARA CORES DE FUNDO
    cache: false
  }
end
