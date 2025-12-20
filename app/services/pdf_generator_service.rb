# app/services/pdf_generator_service.rb
class PdfGeneratorService
  def initialize(template, locals = {})
    @template = template
    @locals = locals
  end

  def call
    # Precisamos instanciar um controller base para ter acesso ao render_to_string fora do request cycle
    controller = ActionController::Base.new
    html = controller.render_to_string(
      template: @template,
      layout: 'pdf',
      locals: @locals
    )
    Grover.new(html).to_pdf
  end
end