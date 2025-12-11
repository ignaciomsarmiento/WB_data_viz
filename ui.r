# ============================
# UI sources for each page
# ============================

source("tabs/ui/country_home.R", local = TRUE)  # Loads country_home

# ============================
# MAIN UI
# ============================

shinyUI(
  fluidPage(
    shinyjs::useShinyjs(),
    
    # ---- HEAD ----
    tags$head(
      tags$title("Regulatory Frameworks Explorer"),
      tags$link(
        href = "https://fonts.googleapis.com/css2?family=Source+Serif+Pro:wght@400;600&family=Source+Sans+Pro:wght@300;400;600&display=swap",
        rel = "stylesheet"
      ),
      includeCSS("www/styles.css"),
      
      # ---- JAVASCRIPT TO CONTROL TABS ----
      tags$script(HTML("
        document.addEventListener('DOMContentLoaded', function() {

          // Attach click handler to each header nav link
          document.querySelectorAll('.nav-link').forEach(function(link) {
            link.addEventListener('click', function(e) {
              e.preventDefault();

              // Get the tab name from data-tab attribute
              let tab = this.getAttribute('data-tab');

              // Find the hidden Shiny tab button that matches this name
              let tabButton = document.querySelector(
                'a[data-value=\"' + tab + '\"]'
              );

              // Simulate a click to switch the tab
              if (tabButton) {
                tabButton.click();
              }
            });
          });

        });
      "))
    ),
    
    # ---- HEADER ----
    tags$div(
      class = "header",
      tags$div(
        class = "container-fluid",
        tags$div(
          class = "nav-menu",
          tags$a("Home",    class = "nav-link", `data-tab` = "landing"),
          tags$a("Country", class = "nav-link", `data-tab` = "country_home"),
          tags$a("Topic",   class = "nav-link", `data-tab` = "topics")
        ),
        tags$img(src = "WB.png", class = "wb-logo")
      )
    ),
    
    # ---- MAIN BODY ----
    div(
      class = "body-content",
      tabsetPanel(
        id = "main_tabs",
        type="hidden",
        selected = "landing",
        
        # ============================
        # 1. LANDING PAGE
        # ============================
        tabPanel(
          "landing",
          tags$section(
            class = "landing-section",
            tags$div(
              class = "container",
              tags$div(
                class = "row align-items-center",
                
                # Left column
                tags$div(
                  class = "col-lg-6 col-md-12",
                  h1(class = "main-title", "Regulatory Frameworks Explorer"),
                  p(class = "subtitle", "Unlock insights into Latin America's regulatory landscape"),
                  p(
                    class = "intro-text",
                    "Explore comprehensive data on non-salary labor costs, minimum wages,
                     business taxes, and social assistance across Latin American countries."
                  ),
                  tags$div(
                    class = "d-flex flex-wrap",
                    actionButton("explore_topic", "Explore by Country", class = "cta-button"),
                    actionButton("explore_by_topic", "Explore by Topic", class = "cta-button")
                  )
                ),
                
                # Right column
                tags$div(
                  class = "col-lg-6 col-md-12 text-center mt-4 mt-lg-0",
                  tags$img(
                    src = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Map-Latin_America.svg/800px-Map-Latin_America.svg.png",
                    alt = "Map of Latin America",
                    class = "img-fluid hero-image"
                  )
                )
              )
            )
          )
        ),
        
        # ============================
        # 2. COUNTRY HOME PAGE
        # ============================
        tabPanel(
          "country_home",
          country_home   
        ),
        
        # ============================
        # 3. TOPICS PAGE
        # ============================
        tabPanel(
          "topics",
          h2("Topics page (coming soon)")
        ),
        
        # ============================
        # 4. CONTENT MODULE PAGE
        # ============================
        tabPanel(
          "content",
          div(
            class = "content-area",
            uiOutput("dynamic_content")
          )
        )
      )
    )
  )
)

