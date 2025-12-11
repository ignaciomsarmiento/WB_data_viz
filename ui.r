# ==========================================
# UI - REGULATORY FRAMEWORKS EXPLORER
# World Bank Group
# ==========================================

library(shiny)
library(shiny.router)

# ==========================================
# DEFINICIONES DE PAÍSES Y TÓPICOS
# ==========================================

countries <- list(
  argentina = "Argentina",
  bolivia = "Bolivia",
  brazil = "Brazil",
  chile = "Chile",
  colombia = "Colombia",
  costa_rica = "Costa Rica",
  dominican_republic = "Dominican Republic",
  ecuador = "Ecuador",
  el_salvador = "El Salvador",
  guatemala = "Guatemala",
  honduras = "Honduras",
  mexico = "Mexico",
  nicaragua = "Nicaragua",
  panama = "Panama",
  paraguay = "Paraguay",
  peru = "Peru",
  uruguay = "Uruguay",
  venezuela = "Venezuela"
)

topics <- list(
  labor = list(
    title = "Non-Salary Labor Costs",
    description = "Yearly bonuses in number of monthly wages across Latin America",
    active = TRUE,
    badge = NULL
  ),
  minwage = list(
    title = "Minimum wages",
    description = "Yearly bonuses in number of monthly wages across Latin America",
    active = FALSE,
    badge = "FORTHCOMING"
  ),
  btax = list(
    title = "Business taxes",
    description = "Yearly bonuses in number of monthly wages across Latin America",
    active = FALSE,
    badge = "FORTHCOMING"
  )
)

# ==========================================
# PÁGINA 1: EXPLORER (Landing Page)
# ==========================================

page_explorer <- tags$div(
  class = "main-content",
  
  # Hero Banner
  tags$div(class = "hero-banner"),
  
  # Page Section
  tags$div(
    class = "page-section",
    
    # Title and Description
    h1(class = "page-title", "Regulatory Frameworks Explorer"),
    p(
      class = "page-subtitle",
      "Explore comprehensive data on non-salary labor costs, minimum wages, business taxes, and social assistance across Latin American countries. Dive into interactive visualizations and detailed analyses to understand regional regulatory frameworks."
    ),
    
    # Section Divider
    tags$div(
      class = "section-divider",
      "CHOOSE A REGULATORY FRAMEWORK TOPIC TO EXPLORE DETAILED DATA AND VISUALIZATIONS"
    ),
    
    # Topics Grid
    tags$div(
      class = "topics-grid",
      
      # Card 1: Non-Salary Labor Costs (Active)
      tags$div(
        class = "topic-card",
        id = "card-labor",
        onclick = "Shiny.setInputValue('topic_card_clicked', 'labor', {priority: 'event'});",
        tags$div(class = "topic-card-header labor"),
        h3(class = "topic-card-title", "Non-Salary Labor Costs"),
        p(class = "topic-card-description", 
          "Yearly bonuses in number of monthly wages across Latin America")
      ),
      
      # Card 2: Minimum Wages (Forthcoming)
      tags$div(
        class = "topic-card disabled",
        tags$div(class = "topic-card-header minwage"),
        h3(class = "topic-card-title", "Minimum wages"),
        p(class = "topic-card-description", 
          "Yearly bonuses in number of monthly wages across Latin America"),
        tags$span(class = "topic-card-badge", "FORTHCOMING")
      ),
      
      # Card 3: Business Taxes (Forthcoming)
      tags$div(
        class = "topic-card disabled",
        tags$div(class = "topic-card-header btax"),
        h3(class = "topic-card-title", "Business taxes"),
        p(class = "topic-card-description", 
          "Yearly bonuses in number of monthly wages across Latin America"),
        tags$span(class = "topic-card-badge", "FORTHCOMING")
      )
    )
  ),
  
  # Footer
  tags$div(
    class = "footer",
    tags$p(class = "footer-text", "© 2025 World Bank Group")
  )
)

# ==========================================
# PÁGINA 2: GUIDE (How to Read the Data)
# ==========================================

page_guide <- tags$div(
  class = "main-content",
  
  # Hero Banner
  tags$div(class = "hero-banner"),
  
  # Page Section
  tags$div(
    class = "page-section",
    
    # Title and Description
    h1(class = "page-title", "How to read the data"),
    p(
      class = "page-subtitle",
      "Explore comprehensive data on non-salary labor costs, minimum wages, business taxes, and social assistance across Latin American countries. Dive into interactive visualizations and detailed analyses to understand regional regulatory frameworks."
    ),
    
    # Questions List
    tags$div(
      class = "questions-list",
      
      tags$div(
        class = "question-item",
        tags$p(class = "question-text", "QUESTION 1")
      ),
      
      tags$div(
        class = "question-item",
        tags$p(class = "question-text", "QUESTION 2")
      ),
      
      tags$div(
        class = "question-item",
        tags$p(class = "question-text", "QUESTION 3")
      ),
      
      tags$div(
        class = "question-item",
        tags$p(class = "question-text", "QUESTION 4")
      ),
      
      tags$div(
        class = "question-item",
        tags$p(class = "question-text", "QUESTION 5")
      ),
      
      tags$div(
        class = "question-item",
        tags$p(class = "question-text", "QUESTION 6")
      )
    )
  ),
  
  # Footer
  tags$div(
    class = "footer",
    tags$p(class = "footer-text", "© 2025 World Bank Group")
  )
)

# ==========================================
# PÁGINA 3: ABOUT (The Project)
# ==========================================

page_about <- tags$div(
  class = "main-content",
  
  # Hero Banner
  tags$div(class = "hero-banner"),
  
  # Page Section
  tags$div(
    class = "page-section",
    
    # Title and Description
    h1(class = "page-title", "The project"),
    p(
      class = "page-subtitle",
      "Explore comprehensive data on non-salary labor costs, minimum wages, business taxes, and social assistance across Latin American countries. Dive into interactive visualizations and detailed analyses to understand regional regulatory frameworks."
    ),
    
    # Info Sections
    tags$div(
      class = "info-sections",
      
      # Contact Section
      tags$div(
        class = "info-section",
        h3(class = "info-section-title", "CONTACT"),
        tags$div(
          class = "info-section-content",
          p("For more information about this project, please contact us at:"),
          p(tags$strong("Email:"), " contact@worldbank.org"),
          p(tags$strong("Phone:"), " +1 (202) 473-1000")
        )
      ),
      
      # Team Section
      tags$div(
        class = "info-section",
        h3(class = "info-section-title", "TEAM"),
        tags$div(
          class = "info-section-content",
          p("This project was developed by a dedicated team of researchers and data scientists at the World Bank Group."),
          tags$ul(
            tags$li("Project Lead: [Name]"),
            tags$li("Data Analysis: [Name]"),
            tags$li("Development: [Name]"),
            tags$li("Design: [Name]")
          )
        )
      )
    )
  ),
  
  # Footer
  tags$div(
    class = "footer",
    tags$p(class = "footer-text", "© 2025 World Bank Group")
  )
)

# ==========================================
# PÁGINA 4: COUNTRIES SELECTION
# ==========================================

page_countries <- tags$div(
  class = "main-content",
  
  # Back Button
  tags$a(
    href = route_link("/"),
    class = "btn btn-back",
    "← Back to Topics"
  ),
  
  # Page Section
  tags$div(
    class = "page-section",
    
    # Title
    h1(class = "page-title", "Select a Country"),
    p(class = "page-subtitle", 
      "Choose a Latin American country to explore detailed regulatory data"),
    
    # Countries Grid - Dynamic Content
    uiOutput("country_grid")
  ),
  
  # Footer
  tags$div(
    class = "footer",
    tags$p(class = "footer-text", "© 2025 World Bank Group")
  )
)

# ==========================================
# PÁGINA 5: COUNTRY TOPICS (Después de seleccionar país)
# ==========================================

page_country_topics <- tags$div(
  class = "main-content",
  
  # Dynamic content will be rendered here
  uiOutput("country_topics_content"),
  
  # Footer
  tags$div(
    class = "footer",
    tags$p(class = "footer-text", "© 2025 World Bank Group")
  )
)

# ==========================================
# PÁGINA 6: CONTENT (Data Visualization)
# ==========================================

page_content <- tags$div(
  class = "main-content",
  
  # Back Button
  tags$a(
    href = "#",
    class = "btn btn-back",
    id = "btn_back_from_content",
    "← Back"
  ),
  
  # Dynamic Module Content
  uiOutput("module_content"),
  
  # Footer
  tags$div(
    class = "footer",
    tags$p(class = "footer-text", "© 2025 World Bank Group")
  )
)

# ==========================================
# UI PRINCIPAL
# ==========================================

ui <- fluidPage(
  
  # CSS Styles
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    
    # Google Fonts - National Park (fallback to Source Sans Pro if not available)
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@300;400;600;700&display=swap"
    ),
    
    # Custom Scripts
    tags$script(HTML("
      // Debugging helper
      console.log('=== Regulatory Frameworks Explorer Initialized ===');
      
      // Add active class to navigation
      Shiny.addCustomMessageHandler('setActiveNav', function(page) {
        $('.nav-link').removeClass('active');
        $('.nav-link[data-page=\"' + page + '\"]').addClass('active');
        console.log('Active nav set to:', page);
      });
      
      // Card click debugging
      $(document).on('click', '.topic-card:not(.disabled)', function() {
        console.log('Topic card clicked:', $(this).attr('id'));
      });
      
      $(document).on('click', '.country-card', function() {
        console.log('Country card clicked');
      });
    "))
  ),
  
  # Header
  tags$div(
    class = "header",
    tags$div(
      class = "header-content",
      
      # Logo
      tags$img(
        src = "https://www.worldbank.org/content/dam/wbr-redesign/logos/logo-wb-header-en.svg",
        class = "wb-logo",
        alt = "World Bank Group"
      ),
      
      # Navigation Menu
      tags$div(
        class = "nav-menu",
        
        tags$a(
          href = route_link("/"),
          class = "nav-link active",
          "data-page" = "explorer",
          "EXPLORER"
        ),
        
        tags$a(
          href = route_link("guide"),
          class = "nav-link",
          "data-page" = "guide",
          "GUIDE"
        ),
        
        tags$a(
          href = route_link("about"),
          class = "nav-link",
          "data-page" = "about",
          "ABOUT"
        )
      )
    )
  ),
  
  # Router
  router_ui(
    route("/", page_explorer),
    route("guide", page_guide),
    route("about", page_about),
    route("countries", page_countries),
    route("country_topics", page_country_topics),
    route("content", page_content)
  )
)
