# Be sure to restart your server when you modify this file.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Permitir requisições do Frontend.
    # Adicionei http://localhost:5174 especificamente por causa do seu erro,
    # mas mantive 5173 (padrão vite) e '*' (para testes gerais se precisar).

    origins "http://localhost:5174", "http://localhost:5173", "http://127.0.0.1:5174"

    resource "*",
             headers: :any,
             methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
