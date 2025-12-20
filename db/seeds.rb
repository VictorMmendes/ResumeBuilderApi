puts "Limpando banco de dados..."
Hobby.destroy_all
Project.destroy_all
TechnicalSkill.destroy_all
Language.destroy_all
Software.destroy_all
Skill.destroy_all
Education.destroy_all
Experience.destroy_all
Resume.destroy_all
# Não vamos deletar o usuário para manter o ID 4 se possível, mas vamos garantir que ele exista
user = User.find_or_create_by!(id: 4) do |u|
  u.email = 'victormmendes.vm@icloud.com'
end
user.update!(email: 'victormmendes.vm@icloud.com') if user.email != 'victormmendes.vm@icloud.com'

puts "Criando currículo principal..."
resume = user.resumes.create!(
  title: "Currículo Sênior",
  full_name: "Victor Mendes",
  job_title: "Desenvolvedor e Analista de Sistemas",
  summary: "Engenheiro de Software com foco em arquitetura de alta escala e impacto de negócio. Especialista em Engenharia de Software e DevOps (PUC-PR), com sólida experiência na implementação de Clean Architecture e Vertical Slice Architecture (VSA). Atualmente consolidando conhecimentos avançados no ecossistema Kotlin Backend (JVM, Coroutines e Performance) via Deep Dive intensivo para atuação em nível Sênior. Atuação pautada por um \"Architecture-first approach\" e decisões orientadas a dados para resolver problemas complexos em domínios críticos como indústria, logística e varejo.",
  email: "victormmendes.vm@icloud.com",
  phone: "+55 41 991959007",
  address: "Paranaguá, PR, 83209570",
  linkedin_url: "https://www.linkedin.com/in/victor-mendes-martins-19878b180",
  github_url: "https://github.com/VictorMmendes",
  old_experiences_summary: "• Outras 3 experiências profissionais anteriores em desenvolvimento (PHP, C# e Mobile) disponíveis para consulta."
)

# Anexar avatar
avatar_path = Rails.root.join("app", "assets", "images", "IMG_7090.jpg")
if File.exist?(avatar_path)
  resume.avatar.attach(io: File.open(avatar_path), filename: "IMG_7090.jpg", content_type: "image/jpeg")
end

puts "Criando experiências profissionais..."
resume.experiences.create!([
                             {
                               job_title: "Engenheiro de Software Full Stack",
                               company: "Puzl Place",
                               location: "São Paulo (Remoto)",
                               start_date: Date.new(2023, 4, 1),
                               current: true,
                               description: "Liderança técnica no desenvolvimento de soluções críticas para o setor de concreteiras (indústria e logística), utilizando Laravel e PHP com foco em Clean Architecture e Vertical Slice Architecture (VSA).\nDesenvolvimento de rotinas complexas de negócio, processamento assíncrono (Jobs) e motores de geração de relatórios industriais avançados em PDF.\nModelagem avançada e otimização de queries em ORMs para cenários de alta demanda, garantindo a escalabilidade e performance do sistema.\nDesenvolvimento de interfaces modernas e performáticas com Vue 2/3, aplicando princípios SOLID e componentização para garantir baixo acoplamento."
                             },
                             {
                               job_title: "Desenvolvedor Front-end & Mobile Pleno",
                               company: "Telecom Sistemas",
                               location: "Rio Grande do Sul (Remoto)",
                               start_date: Date.new(2022, 1, 1),
                               end_date: Date.new(2023, 4, 1),
                               current: false,
                               description: "Arquitetura e desenvolvimento de um sistema completo de gestão ERP para grandes redes de supermercados, utilizando AngularJS para manipulação massiva de dados e tabelas dinâmicas.\nDesenvolvimento de um ecossistema mobile integrado em Flutter para automação comercial, permitindo venda direta, cadastro de produtos e gestão de estoque/logística.\nImplementação do projeto \"Estoque Inteligente\": uso de Business Intelligence e análise de dados para identificar tendências de venda baseadas em sazonalidade e geolocalização.\nFoco em Data-driven decisions e Architecture-first approach para otimizar a distribuição de itens entre unidades da rede."
                             },
                             {
                               job_title: "Desenvolvedor de Sistemas (Dynamics 365 / .NET)",
                               company: "MPS Informática",
                               location: "Curitiba, Paraná",
                               start_date: Date.new(2021, 3, 1),
                               end_date: Date.new(2021, 12, 1),
                               current: false,
                               description: "Desenvolvimento de plugins C# avançados e customizações para Microsoft Dynamics 365, aplicando Clean Code, XrmToolBox e integração de APIs REST.\nArquitetura de aplicativos mobile com Xamarin Forms (XAML/MVVM Pattern), focando em Clean Architecture e gerenciamento eficiente de APIs.\nOtimização de processos de negócio através da Power Platform (Power Apps e Power Automate).\nModelagem de banco de dados e documentação técnica de arquitetura de software."
                             }
                           ])

puts "Criando educação..."
resume.educations.create!([
                            {
                              institution: "Pontifícia Universidade Católica do Paraná (PUC-PR)",
                              degree: "Especialização: Engenharia de Software e DevOps",
                              start_date: Date.new(2021, 2, 1),
                              current: true
                            },
                            {
                              institution: "Rocketseat",
                              degree: "Bootcamp Rocketseat: Full Stack & Mobile",
                              location: "Formação Node.js concluída; Especialização em Kotlin (Mobile/Backend) complementada por um Deep Dive de 30 dias em Kotlin Backend focado em JVM, Coroutines e Performance.",
                              start_date: Date.new(2023, 1, 1),
                              current: true
                            },
                            {
                              institution: "Instituto Federal do Paraná (IFPR)",
                              degree: "Graduação: Análise e Desenvolvimento de Sistemas",
                              start_date: Date.new(2016, 2, 1),
                              end_date: Date.new(2019, 6, 1),
                              current: false
                            }
                          ])

puts "Criando competências técnicas..."
technical_skills = [
  { category: "Backend & Arquitetura", name: "Kotlin (JVM/Coroutines), Laravel, PHP, Node.js, Ruby on Rails, C# (.NET), Clean Architecture, Vertical Slice Architecture (VSA), DDD, SOLID, Clean Code." },
  { category: "Frontend", name: "Vue 2/3, React, AngularJS, JavaScript (ES6+), HTML5/CSS3, Componentização, Reaproveitamento de Código." },
  { category: "Mobile", name: "Flutter, Kotlin (Nativo), Xamarin Forms, MVVM Pattern, APIs RESTful, Gerenciamento de Memória." },
  { category: "Cloud & DevOps", name: "Docker, CI/CD, Observabilidade (Monitoring), Git/GitHub, Gerenciamento de Ambientes (Dev/Acc/Prod)." },
  { category: "Dados & BI", name: "MySQL, PostgreSQL, Business Intelligence, Data-driven decisions, Modelagem Avançada de Dados." }
]
technical_skills.each { |ts| resume.technical_skills.create!(ts) }

puts "Criando soft skills..."
[
  [ "Resolução de Problemas", 5 ],
  [ "Arquitetura de Soluções", 5 ],
  [ "Clean Code", 5 ],
  [ "Liderança Técnica", 4 ],
  [ "Comunicação", 4 ]
].each { |name, level| resume.skills.create!(name: name, level: level) }

puts "Criando softwares..."
[
  [ "XrmToolBox", 5 ],
  [ "MySQL Workbench", 5 ],
  [ "Android Studio", 5 ],
  [ "Photoshop / Maya", 4 ],
  [ "Docker / Git", 5 ]
].each { |name, level| resume.softwares.create!(name: name, level: level) }

puts "Criando idiomas..."
[
  [ "Português", 5 ],
  [ "Inglês", 5 ],
  [ "Francês", 2 ]
].each { |name, level| resume.languages.create!(name: name, level: level) }

puts "Criando projetos..."
resume.projects.create!([
                          { title: "ERP Industrial - Concreteiras (Laravel/VSA)", description: "Sistema crítico de gestão industrial e logística, implementando Vertical Slice Architecture para alta manutenibilidade e processamento assíncrono de rotinas complexas." },
                          { title: "Projeto 'Estoque Inteligente' (Flutter/BI)", description: "Ecossistema mobile integrado com Business Intelligence para gestão preditiva de estoque e análise de tendências de venda baseadas em sazonalidade e geolocalização." }
                        ])

puts "Criando hobbies..."
[
  [ "Pesquisa e Interesses", "Game Development (Unity/Maya)" ],
  [ "Pesquisa e Interesses", "Modern Architectures (VSA, DDD)" ],
  [ "Pesquisa e Interesses", "Desenvolvimento Android Nativo" ],
  [ "Pesquisa e Interesses", "Agentes de IA" ],
  [ "Pesquisa e Interesses", "Desafios de programação" ],
  [ "Pesquisa e Interesses", "Mercado Financeiro e Investimentos" ],
  [ "Entretenimento", "Exploração Tecnológica" ],
  [ "Entretenimento", "Viajar" ],
  [ "Entretenimento", "Inteligência Artificial" ]
].each { |cat, name| resume.hobbies.create!(category: cat, name: name) }

puts "Concluído! Dados do Victor Mendes inseridos com sucesso."
