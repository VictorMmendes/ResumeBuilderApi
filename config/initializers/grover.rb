# config/initializers/grover.rb
Grover.configure do |config|
  config.options = {
    format: "A4",
    margin: { top: "0px", bottom: "0px", left: "0px", right: "0px" }, # Margens controladas integralmente via CSS
    prefer_css_page_size: true,
    emulate_media: "print", # Permite usar @page e @media print no template final
    print_background: true,
    cache: false
  }
end
