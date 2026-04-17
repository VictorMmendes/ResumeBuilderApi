require "date"

module VictorLinkedinProfile20260417
  MATCH_ATTRIBUTES = {
    full_name: "Victor Mendes Martins",
    linkedin_url: "https://www.linkedin.com/in/victor-mendes-martins"
  }.freeze

  RESUME_ATTRIBUTES = {
    full_name: "Victor Mendes Martins",
    headline: "Fullstack Engineer (Backend-Focused) | Kotlin (Ktor) & Spring Boot | Vue.js, TypeScript, Laravel | AI-Assisted Development",
    summary: <<~TEXT.squish,
      I’m a Software Engineer with a strong backend focus, specializing in building scalable, maintainable, and high-performance systems.
      My work goes beyond coding, I focus on system design, product thinking, and leveraging AI to accelerate development.
      I actively use AI-assisted workflows to design PRDs, define technical specifications, and build systems using modern architectures
      such as RAG (Retrieval-Augmented Generation) and MCP-based approaches.
      On the backend, I work primarily with Kotlin (Ktor) and Java (Spring Boot), designing robust APIs and scalable architectures.
      I also have solid experience with Laravel, allowing me to operate across different backend ecosystems when needed.
      On the frontend, I use Vue.js and TypeScript to create clean, responsive, and well-structured interfaces, always focusing on
      maintainability and user experience.
      I prioritize clean architecture, design patterns, and long-term scalability.
      I’m particularly interested in building systems that are not only functional, but also elegant and thoughtfully designed.
      Currently, I work remotely as a contractor, contributing to production systems and collaborating with teams to continuously improve
      product quality and performance.
      Beyond my professional work, I’m building my own SaaS products and exploring applied AI, focusing on how intelligent systems can
      enhance productivity, discipline, and decision-making.
      Core skills: Backend: Kotlin (Ktor), Java (Spring Boot), Laravel. Frontend: Vue.js, TypeScript. Systems: REST APIs, Scalable
      Architectures, System Design. AI: RAG, MCPs, AI-Assisted Development, PRDs & Tech Specs.
    TEXT
    email: "Victormmendes.vm@icloud.com",
    phone: "41991959007",
    street_address: "Av. General Ivan Jejuhy Affonso da Costa, 403",
    city: "Paranaguá",
    region: "Paraná",
    country: "Brazil",
    linkedin_url: "https://www.linkedin.com/in/victor-mendes-martins",
    github_url: "https://github.com/VictorMmendes",
    portfolio_label: nil
  }.freeze

  TOP_SKILLS = [
    "Artificial Intelligence (AI)",
    "Computer Assisted Coding Software",
    "Kotlin"
  ].freeze

  CERTIFICATIONS = [
    "Aplicações completas e escaláveis com Node.js"
  ].freeze

  EXPERIENCE_GROUPS = [
    {
      company_name: "PUZL Place",
      location: "Belo Horizonte, MG · São Paulo, SP",
      positions: [
        {
          title: "Fullstack Software Engineer (Backend-Focused) | Vue.js, TypeScript & Laravel",
          start_date: Date.new(2025, 9, 1),
          end_date: nil,
          current: true,
          summary: <<~TEXT.squish,
            Working as a Fullstack Software Engineer with a strong focus on building scalable and maintainable web applications.
            My role involves developing and maintaining both frontend and backend systems, ensuring performance, usability, and clean
            architecture across the entire application.
            On the frontend, I work primarily with Vue.js and TypeScript, creating dynamic, responsive, and well-structured user
            interfaces. I focus on componentization, code quality, and delivering smooth user experiences.
            On the backend, I work with Laravel, building robust APIs and business logic, following best practices and design patterns
            to ensure scalability and long-term maintainability.
            I actively apply software architecture principles and continuously improve code structure and system design. I also leverage
            AI-assisted development to accelerate workflows, improve code quality, and support decision-making during development.
          TEXT
          bullets: [
            "Development of scalable web applications using Vue.js, TypeScript, and Laravel",
            "Implementation of reusable components and maintainable frontend architecture",
            "Backend API development and business logic structuring",
            "Application of design patterns and clean architecture principles",
            "Continuous improvement of system performance and code quality"
          ]
        },
        {
          title: "Software Engineer (Vue.js & Laravel)",
          start_date: Date.new(2023, 4, 1),
          end_date: nil,
          current: true,
          summary: <<~TEXT.squish,
            Started as a Software Engineer working on web development for a complex ERP platform focused on the concrete industry,
            covering financial operations, logistics, and industrial processes.
          TEXT
          bullets: [
            "Developed and maintained web applications using Vue.js and Laravel",
            "Contributed to a large-scale ERP system supporting end-to-end operations, including financial management, load control, and scale automation",
            "Implemented and maintained integrations with banking systems, including real-time account management and OFX import processing",
            "Worked on features related to financial workflows, data processing, and operational efficiency",
            "Collaborated with the team to improve system architecture, performance, and maintainability",
            "Gained experience working with complex business rules and enterprise-level systems"
          ]
        }
      ]
    },
    {
      company_name: "Self-employed",
      location: "Paranaguá, PR",
      positions: [
        {
          title: "Freelance Software Engineer",
          start_date: Date.new(2023, 4, 1),
          end_date: Date.new(2023, 6, 1),
          current: false,
          summary: <<~TEXT.squish,
            Worked as a freelance software engineer, delivering web and mobile solutions for companies and business clients.
          TEXT
          bullets: [
            "Developed custom web applications using Vue.js and Laravel, focusing on scalability and performance",
            "Built mobile applications using Kotlin, ensuring reliability and smooth user experience",
            "Designed and implemented backend services and APIs using Java and PHP",
            "Delivered end-to-end solutions, from requirements gathering to deployment",
            "Collaborated directly with clients, including larger companies, to understand business needs and deliver tailored solutions",
            "Applied agile development practices to ensure fast and efficient delivery"
          ]
        }
      ]
    },
    {
      company_name: "Grupo Telecon RS",
      location: "Rio Grande do Sul, Brazil",
      positions: [
        {
          title: "Software Engineer (Mobile & Web)",
          start_date: Date.new(2022, 1, 1),
          end_date: Date.new(2023, 4, 1),
          current: false,
          summary: <<~TEXT.squish,
            Worked on the development and maintenance of mobile and web applications for retail systems, focused on supermarket sales operations.
          TEXT
          bullets: [
            "Developed and maintained Android applications using Kotlin, implementing new features, bug fixes, and performance improvements",
            "Worked on a web application using Angular, contributing mainly to frontend development and feature implementation",
            "Participated in the development of a complete retail system used for sales and operational management",
            "Integrated applications with backend services and APIs, ensuring data consistency across platforms",
            "Collaborated with cross-functional teams using agile methodologies and tools such as Trello",
            "Gained experience in system architecture, API design, and business logic related to retail operations"
          ]
        }
      ]
    },
    {
      company_name: "MPS Informática Ltda",
      location: "Curitiba, PR",
      positions: [
        {
          title: "Mobile Engineer",
          start_date: Date.new(2021, 3, 1),
          end_date: Date.new(2022, 1, 1),
          current: false,
          summary: <<~TEXT.squish,
            Focused on mobile application development, working with native iOS and Android technologies.
          TEXT
          bullets: [
            "Developed and maintained iOS applications using Swift and Objective-C",
            "Developed Android applications using Kotlin, focusing on performance and reliability",
            "Implemented new features, bug fixes, and performance improvements across mobile platforms",
            "Integrated mobile applications with backend services and APIs",
            "Collaborated with the team to improve app stability, usability, and overall user experience"
          ]
        }
      ]
    },
    {
      company_name: "Genesis Company Brasil",
      location: "Florianópolis, SC",
      positions: [
        {
          title: "Full Stack Engineer",
          start_date: Date.new(2020, 11, 1),
          end_date: Date.new(2021, 3, 1),
          current: false,
          summary: <<~TEXT.squish,
            Worked on the development of ERP systems and mobile applications, focusing on solutions for the hospitality industry and on-demand services.
          TEXT
          bullets: [
            "Developed and maintained ERP systems for hotel management, including modules for operations, data management, and integrations",
            "Contributed to the development of a ride-hailing and delivery application, similar to Uber, handling core features and system logic",
            "Built and maintained backend services and APIs using Laravel and PHP",
            "Developed web interfaces using Vue.js, focusing on usability and performance",
            "Developed mobile applications using Kotlin, ensuring smooth user experience and reliability",
            "Collaborated on system architecture decisions and feature implementation across web and mobile platforms"
          ]
        }
      ]
    },
    {
      company_name: "Self-employed",
      location: "Paranaguá, PR",
      positions: [
        {
          title: "Freelance Software Engineer",
          start_date: Date.new(2018, 12, 1),
          end_date: Date.new(2021, 3, 1),
          current: false,
          summary: <<~TEXT.squish,
            Worked as a freelance software engineer, delivering custom web and mobile solutions for clients across different industries,
            including retail, hospitality, and local businesses.
          TEXT
          bullets: [
            "Designed and developed custom applications tailored to client needs, including private systems for supermarkets, hotels, and retail stores",
            "Built mobile applications using Kotlin, focusing on performance and usability",
            "Developed web applications and dashboards using Vue.js and Laravel",
            "Designed and implemented backend services and APIs using Java and PHP",
            "Delivered end-to-end solutions, from requirements gathering to deployment",
            "Collaborated directly with clients to understand business needs and translate them into technical solutions"
          ]
        }
      ]
    },
    {
      company_name: "AG&BM CONSTRUTORA",
      location: "Paranaguá, PR",
      positions: [
        {
          title: "Full Stack Engineer",
          start_date: Date.new(2020, 1, 1),
          end_date: Date.new(2020, 9, 1),
          current: false,
          summary: <<~TEXT.squish,
            Worked on fullstack development, contributing to web and mobile applications across different technologies.
          TEXT
          bullets: [
            "Gathered and analyzed requirements to support product development",
            "Designed and structured relational databases",
            "Developed web applications using Laravel and Ruby on Rails",
            "Built and maintained APIs to support system integrations",
            "Developed mobile applications using React Native and Kotlin",
            "Contributed to UI/UX design and interface improvements"
          ]
        }
      ]
    },
    {
      company_name: "Infotech Soluções em Tecnologia",
      location: "Paranaguá, PR",
      positions: [
        {
          title: "Mobile & Backend Software Engineer",
          start_date: Date.new(2019, 6, 1),
          end_date: Date.new(2019, 10, 1),
          current: false,
          summary: <<~TEXT.squish,
            Worked on mobile and backend development, building scalable applications and system integrations.
          TEXT
          bullets: [
            "Developed Android applications using Kotlin, implementing features such as QR code payments, local and remote data synchronization, and integrations with Google Maps API and Firebase",
            "Designed and implemented REST APIs using PHP",
            "Modeled and structured relational databases",
            "Built responsive web interfaces using HTML and CSS",
            "Implemented UI animations to improve user experience"
          ]
        }
      ]
    }
  ].freeze

  EDUCATIONS = [
    {
      institution: "Pontifícia Universidade Católica do Paraná",
      degree_name: "postgraduate",
      field_of_study: "Software Engineering, DevOps & Digital Transformation",
      start_date: Date.new(2025, 4, 1),
      end_date: Date.new(2026, 11, 1),
      current: false
    },
    {
      institution: "Instituto Federal do Paraná - IFPR (Curitiba)",
      degree_name: "Associate Degree in Systems Analysis and Development",
      field_of_study: "Computer Technology/Computer Systems Technology",
      start_date: Date.new(2016, 2, 1),
      end_date: Date.new(2019, 6, 1),
      current: false
    }
  ].freeze
end
