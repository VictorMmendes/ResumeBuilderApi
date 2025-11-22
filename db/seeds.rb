# Limpar banco de dados existente para evitar duplicatas ao rodar seeds
puts "Limpando banco de dados..."
Language.destroy_all
Software.destroy_all
Skill.destroy_all
Education.destroy_all
Experience.destroy_all
Resume.destroy_all
User.destroy_all

puts "Criando usuário..."
# Criando o usuário base com o e-mail do PDF
user = User.create!(email: 'victormmendes.vm@icloud.com')

puts "Criando currículo..."
# Criando o currículo principal
resume = user.resumes.create!(
  title: "Currículo Full Stack",
  full_name: "Victor Mendes",
  job_title: "Desenvolvedor e Analista de sistemas",
  summary: "Busco uma oportunidade para me recolocar no mercado de trabalho para me desenvolver e atuar na área de desenvolvimento de software, estou disposto a aplicar meus conhecimentos já adquiridos e também aprender quaisquer tecnologias exigidas para suprir as necessidades da empresa.",
  email: "victormmendes.vm@icloud.com",
  phone: "+55 41 991959007",
  address: "Paranaguá, PR, 83209570",
  linkedin_url: "https://www.linkedin.com/in/victor-mendes-martins-19878b180"
)

puts "Criando experiências profissionais..."
# 1. MPS Informática
resume.experiences.create!(
  job_title: "Programador de Computadores",
  company: "MPS Informática",
  location: "Curitiba, Paraná",
  start_date: Date.new(2020, 11, 1),
  end_date: Date.new(2021, 3, 1),
  current: false,
  description: "• Arquitetura de Soluções
• Desenvolvimento de aplicativos com Make Power Apps
• Criação de Plugin C# para Dynamics da Microsoft
• Desenvolvimento CRM com Dynamics 365
• Gerenciamento de soluções em ambiente Dev, Acc e Prod
• Criação de views, forms, security roles, flows e outros componentes na plataforma Dynamics 365
• Gerenciamento de componentes em ambiente CRM com Xrm ToolBox
• Desenvolvimento iOS e android com Xamarin Forms"
)

# 2. Genesis Company
resume.experiences.create!(
  job_title: "Desenvolvedor Junior",
  company: "Genesis Company",
  location: "Florianópolis, Santa Catarina (Remote)",
  start_date: Date.new(2020, 9, 1),
  end_date: Date.new(2020, 11, 1), # Estimado baseando-se na próxima exp
  current: false,
  description: "• Modelagem de banco de dados
• Levantamento de requisitos"
)

# 3. AG&BM
resume.experiences.create!(
  job_title: "Desenvolvedor Web/Mobile",
  company: "AG&BM",
  location: "Paranaguá, Paraná",
  start_date: Date.new(2020, 1, 1),
  end_date: Date.new(2020, 9, 1),
  current: false,
  description: "• Levantamento de requisitos
• Modelagem de banco de dados
• Web Design & UIX
• Desenvolvimento Web Laravel
• Desenvolvimento Web Ruby on Rails
• Photoshop CC
• Desenvolvimento de aplicativos com React Native
• Desenvolvimento de aplicativos com Kotlin
• Criação de APIS"
)

# 4. Infotech Sistemas
resume.experiences.create!(
  job_title: "Desenvolvedor Aplicativo",
  company: "Infotech Sistemas",
  location: "Paranaguá, Paraná",
  start_date: Date.new(2019, 6, 1),
  end_date: Date.new(2019, 10, 1),
  current: false,
  description: "• Modelagem de banco de dados
• Desenvolvimento de aplicativos com Kotlin, incluindo funcionalidades como pagamento via QrCode, sincronização local e remota, Google Maps API e Firebase
• Criação de APIs com PHP 7.2
• Desenvolvimento de Layouts (HTML5 e CSS3)
• Animações gráficas (CSS3)"
)

puts "Criando educação..."
resume.educations.create!(
  institution: "Universidade Federal do Paraná",
  degree: "Pós-Graduação: Inteligência Artificial Aplicada",
  location: "Curitiba-PR",
  start_date: Date.new(2021, 2, 1),
  current: true
)

resume.educations.create!(
  institution: "Instituto Federal do Paraná",
  degree: "Graduação: Análise e desenvolvimento de sistemas",
  location: "Paranaguá-PR",
  start_date: Date.new(2016, 2, 1),
  end_date: Date.new(2019, 6, 1),
  current: false
)

resume.educations.create!(
  institution: "I.E.E Dr. Caetano Munhoz da Rocha",
  degree: "Ensino Médio",
  location: "Paranaguá-PR",
  start_date: Date.new(2007, 2, 1),
  end_date: Date.new(2013, 6, 1),
  current: false
)

resume.educations.create!(
  institution: "CECAP",
  degree: "Curso Profissionalizante: Informática Básica",
  location: "Paranaguá-PR",
  start_date: Date.new(2013, 2, 1),
  end_date: Date.new(2013, 8, 1),
  current: false
)

resume.educations.create!(
  institution: "SENAI",
  degree: "Curso Técnico: Eletrotécnica",
  location: "Paranaguá-PR",
  start_date: Date.new(2014, 2, 1),
  end_date: Date.new(2015, 11, 1),
  current: false
)

resume.educations.create!(
  institution: "SENAI",
  degree: "Curso Técnico: Administração",
  location: "Paranaguá-PR",
  start_date: Date.new(2014, 2, 1),
  end_date: Date.new(2015, 11, 1),
  current: false
)

puts "Criando habilidades..."
skills_list = [
  { name: "Programação de computadores (OO)", level: 5 },
  { name: "Modelagem de banco de dados", level: 5 },
  { name: "Documentação de software", level: 4 },
  { name: "MySQL / PostgreSQL", level: 4 },
  { name: "PHP / Laravel", level: 4 },
  { name: "HTML5 / CSS / Web Design", level: 5 },
  { name: "VueJS", level: 3 },
  { name: "ReactJS / React Native", level: 3 },
  { name: "Ruby on Rails", level: 4 },
  { name: "Ionic / AngularJS", level: 3 },
  { name: "Kotlin", level: 3 },
  { name: "Web Service / APIs / JSON", level: 5 },
  { name: "Java", level: 3 },
  { name: "C / C++ / C#", level: 3 },
  { name: "Git", level: 4 }
]

skills_list.each do |skill|
  resume.skills.create!(skill)
end

puts "Criando softwares..."
software_list = [
  { name: "Photoshop CC", level: 5 },
  { name: "MySQL Workbench", level: 5 },
  { name: "Android Studio", level: 4 },
  { name: "Illustrator CC", level: 3 },
  { name: "Office", level: 5 }
]

software_list.each do |soft|
  resume.softwares.create!(soft)
end

puts "Criando idiomas..."
resume.languages.create!(name: "Português", level: 5) # Nativo
resume.languages.create!(name: "Inglês", level: 3) # Intermediário (inferido pelos cursos)
resume.languages.create!(name: "Francês", level: 1) # Básico

puts "Concluído! Dados do Victor Mendes inseridos com sucesso."
