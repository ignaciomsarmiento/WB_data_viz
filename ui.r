library(shiny)
library(shinyjs)

shinyUI(
  fluidPage(
    shinyjs::useShinyjs(),
    
    # Styles css
    tags$head(
      tags$title("Regulatory Frameworks Explorer"),
      
      # Google Fonts
      tags$link(href="https://fonts.googleapis.com/css2?family=Source+Serif+Pro:wght@400;600&family=Source+Sans+Pro:wght@300;400;600&display=swap", rel="stylesheet"),
      

    includeCSS("www/styles.css"),

      
      # JavaScript for navigation
      tags$script(HTML("
        $(document).ready(function() {
          // Ensure header is always visible
          $('.header').addClass('show');
          
          // Update browser history when navigating
          function updateHistory(tab) {
            history.pushState({tab: tab}, '', '#' + tab);
          }
          
          // Handle navigation link clicks
          $(document).on('click', '.nav-link', function() {
            var tab = $(this).attr('data-tab');
            Shiny.setInputValue('nav_selection', tab, {priority: 'event'});
            updateHistory(tab);
          });
          
          // Handle browser back/forward buttons
          window.onpopstate = function(event) {
            if (event.state && event.state.tab) {
              Shiny.setInputValue('nav_selection', event.state.tab, {priority: 'event'});
            }
          };
        });
        
        // Custom message handler for button classes (used by labor module)
        Shiny.addCustomMessageHandler('updateButtonClass', function(message) {
          var $el = $('#' + message.id);
          if (message.action === 'add') { 
            $el.addClass(message.class); 
          } else { 
            $el.removeClass(message.class); 
          }
        });
        
                       "))
    ),
    
    # Fixed header with navigation menu
    tags$div(class = "header",
             tags$div(class = "container-fluid",
                      tags$div(class = "nav-menu",
                               tags$a("Home", class = "nav-link", `data-tab` = "landing"),
                               tags$a("Country", class = "nav-link", `data-tab` = "country_topics"),
                               tags$a("Topic", class = "nav-link", `data-tab` = "topics")
                      ),
                      tags$img(src = "WB.png", alt = "Logo", class = "wb-logo")
             )
    ),
    
    # Main content with tabs
    div(class = "body-content",
    tabsetPanel(
      id = "main_tabs",
      type = "hidden",
      selected = "landing",
      
      # Landing page
      tabPanel("landing",
               tags$section(class = "landing-section",
                            tags$div(class = "container",
                                     tags$div(class = "row align-items-center",
                                              tags$div(class = "col-lg-6 col-md-12",
                                                       h1(class = "main-title", "Regulatory Frameworks Explorer"),
                                                       p(class = "subtitle", "Unlock insights into Latin America's regulatory landscape"),
                                                       p(class = "intro-text",
                                                         "Explore comprehensive data on non-salary labor costs, minimum wages, business taxes, 
                  and social assistance across Latin American countries. Dive into interactive 
                  visualizations and detailed analyses to understand regional regulatory frameworks."
                                                       ),
                                                       tags$div(class = "d-flex flex-wrap",
                                                                actionButton("explore_topic", "Explore by Country", class = "cta-button"),
                                                                actionButton("explore_by_topic", "Explore by Topic", class = "cta-button")
                                                       )
                                              ),
                                              tags$div(class = "col-lg-6 col-md-12 text-center mt-4 mt-lg-0",
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
      
      # Country page with topic selection
      tabPanel("country_topics",
               tags$div(class = "topic-page",
                        tags$div(class = "topic-header",
                                 h1(class = "topic-title", "Select a Topic"),
                                 p(class = "topic-subtitle", 
                                   "Choose a regulatory framework topic to explore detailed data and visualizations")
                        ),
                        tags$div(class = "topic-grid",
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'labor', {priority: 'event'})",
                                          h3("Non-salary Labor Costs"),
                                          p("Yearly bonuses, social security contributions, and employment benefits")
                                 ),
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'minwage', {priority: 'event'})",
                                          h3("Minimum Wages"),
                                          p("Minimum wage policies and trends across the region")
                                 ),
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'btax', {priority: 'event'})",
                                          h3("Business Taxes"),
                                          p("Corporate tax rates, incentives, and fiscal policies")
                                 ),
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'social', {priority: 'event'})",
                                          h3("Social Assistance"),
                                          p("Social programs, welfare systems, and poverty alleviation policies")
                                 )
                        )
               )
      ),
      
      # Topic selection page
      tabPanel("topics",
               tags$div(class = "topic-page",
                        tags$div(class = "topic-header",
                                 h1(class = "topic-title", "Select a Topic"),
                                 p(class = "topic-subtitle", 
                                   "Choose a regulatory framework topic to explore detailed data and visualizations")
                        ),
                        tags$div(class = "topic-grid",
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'labor', {priority: 'event'})",
                                          h3("Non-salary Labor Costs"),
                                          p("Yearly bonuses, social security contributions, and employment benefits")
                                 ),
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'minwage', {priority: 'event'})",
                                          h3("Minimum Wages"),
                                          p("Minimum wage policies and trends across the region")
                                 ),
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'btax', {priority: 'event'})",
                                          h3("Business Taxes"),
                                          p("Corporate tax rates, incentives, and fiscal policies")
                                 ),
                                 tags$div(class = "topic-card", 
                                          onclick = "Shiny.setInputValue('topic_selected', 'social', {priority: 'event'})",
                                          h3("Social Assistance"),
                                          p("Social programs, welfare systems, and poverty alleviation policies")
                                 )
                        )
               )
      ),
      
      # Content panel for modules
      tabPanel("content",
               tags$div(class = "content-area",
                        uiOutput("dynamic_content")
               )
      )
    )
  )
))