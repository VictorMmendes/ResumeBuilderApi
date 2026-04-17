puts "Resetando dados do domínio principal..."

ExperiencePositionBullet.destroy_all
ExperiencePosition.destroy_all
ExperienceGroup.destroy_all
Certification.destroy_all
TopSkill.destroy_all
Education.destroy_all
Resume.destroy_all

user = User.find_or_create_by!(id: 4) do |record|
  record.email = "victormmendes.vm@icloud.com"
end
user.update!(email: "victormmendes.vm@icloud.com")

puts "Criando currículo principal no formato LinkedIn..."

resume = user.resumes.create!(
  full_name: "Victor Mendes Martins",
  headline: "Fullstack Engineer (Backend-Focused) | Kotlin (Ktor) & Spring Boot | Vue.js, TypeScript, Laravel | AI-Assisted Development",
  summary: "Engenheiro de software com foco em backend, arquitetura e entrega orientada a impacto. Experiência com produtos web escaláveis, decisões técnicas guiadas por contexto de negócio e uso prático de IA para acelerar discovery, implementação e qualidade.",
  email: "victormmendes.vm@icloud.com",
  phone: "+55 41 99195-9007",
  street_address: "Paranaguá, Paraná",
  city: "Paranagua",
  region: "Parana",
  country: "Brazil",
  linkedin_url: "https://www.linkedin.com/in/victor-mendes-martins",
  github_url: "https://github.com/VictorMmendes",
  portfolio_label: "Portfolio"
)

avatar_path = Rails.root.join("app", "assets", "images", "IMG_7090.jpg")
if File.exist?(avatar_path)
  resume.avatar.attach(
    io: File.open(avatar_path),
    filename: "IMG_7090.jpg",
    content_type: "image/jpeg"
  )
end

[
  "Artificial Intelligence (AI)",
  "Kotlin Backend",
  "Laravel",
  "Vue.js",
  "Software Architecture"
].each_with_index do |name, index|
  resume.top_skills.create!(name:, display_order: index)
end

[
  "Aplicacoes completas e escalaveis com Node.js",
  "Formacao avancada em Kotlin Backend"
].each_with_index do |name, index|
  resume.certifications.create!(name:, display_order: index)
end

[
  {
    company_name: "PUZL Place",
    location: "Belo Horizonte, MG",
    positions: [
      {
        title: "Frontend Software Engineer | Vue.js, TypeScript & UX Delivery",
        start_date: Date.new(2025, 2, 1),
        end_date: Date.new(2025, 8, 1),
        current: false,
        summary: "Atuação em evolução de interfaces críticas e fluxos de produto com foco em consistência de entrega.",
        bullets: [
          "Implementou interfaces responsivas com Vue.js e TypeScript para fluxos operacionais críticos.",
          "Aproximou produto e engenharia com refinamentos orientados por impacto e viabilidade."
        ]
      },
      {
        title: "Fullstack Software Engineer (Backend-Focused) | Vue.js, TypeScript & Laravel",
        start_date: Date.new(2025, 9, 1),
        end_date: nil,
        current: true,
        summary: "Responsável por funcionalidades fullstack com foco crescente em backend, arquitetura e qualidade de entrega.",
        bullets: [
          "Desenvolve aplicações web escaláveis com Laravel, TypeScript e integrações orientadas a domínio.",
          "Usa IA de forma prática para acelerar discovery técnico, implementação e revisão de qualidade."
        ]
      }
    ]
  },
  {
    company_name: "Telecom Sistemas",
    location: "Rio Grande do Sul, Brazil",
    positions: [
      {
        title: "Desenvolvedor Front-end & Mobile Pleno",
        start_date: Date.new(2022, 1, 1),
        end_date: Date.new(2023, 4, 1),
        current: false,
        summary: "Atuação em ERP para varejo e ecossistema mobile de automação comercial.",
        bullets: [
          "Arquitetou e evoluiu módulos front-end para operação de grandes redes de supermercados.",
          "Entregou fluxos mobile em Flutter para venda, estoque e logística integrada."
        ]
      }
    ]
  },
  {
    company_name: "MPS Informatica",
    location: "Curitiba, Parana",
    positions: [
      {
        title: "Desenvolvedor de Sistemas (Dynamics 365 / .NET)",
        start_date: Date.new(2021, 3, 1),
        end_date: Date.new(2021, 12, 1),
        current: false,
        summary: "Projetos com C#, Dynamics 365, integrações REST e arquitetura mobile.",
        bullets: [
          "Desenvolveu plugins e customizações avançadas para Microsoft Dynamics 365.",
          "Implementou integrações REST e rotinas de automação para processos de negócio."
        ]
      }
    ]
  }
].each_with_index do |group_attributes, group_index|
  group = resume.experience_groups.create!(
    company_name: group_attributes[:company_name],
    location: group_attributes[:location],
    display_order: group_index
  )

  group_attributes[:positions].each_with_index do |position_attributes, position_index|
    position = group.experience_positions.create!(
      title: position_attributes[:title],
      start_date: position_attributes[:start_date],
      end_date: position_attributes[:end_date],
      current: position_attributes[:current],
      summary: position_attributes[:summary],
      display_order: position_index
    )

    position_attributes[:bullets].each_with_index do |content, bullet_index|
      position.experience_position_bullets.create!(content:, display_order: bullet_index)
    end
  end
end

[
  {
    institution: "Pontificia Universidade Catolica do Parana",
    degree_name: "Postgraduate",
    field_of_study: "Software Engineering, DevOps & Digital Transformation",
    start_date: Date.new(2025, 4, 1),
    end_date: Date.new(2026, 11, 1),
    current: false
  },
  {
    institution: "Rocketseat",
    degree_name: "Bootcamp",
    field_of_study: "Full Stack & Mobile Development",
    start_date: Date.new(2023, 1, 1),
    end_date: Date.new(2023, 12, 1),
    current: false
  },
  {
    institution: "Instituto Federal do Parana",
    degree_name: "Associate Degree",
    field_of_study: "Systems Analysis and Development",
    start_date: Date.new(2016, 2, 1),
    end_date: Date.new(2019, 6, 1),
    current: false
  }
].each_with_index do |education_attributes, index|
  resume.educations.create!(education_attributes.merge(display_order: index))
end

puts "Seed concluído com currículo LinkedIn de referência."
