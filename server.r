# ==========================================
# SERVER - REGULATORY FRAMEWORKS EXPLORER
# World Bank Group
# ==========================================

library(shiny)
library(shiny.router)

server <- function(input, output, session) {
  
  # ==========================================
  # REACTIVE VALUES
  # ==========================================
  
  navigation <- reactiveValues(
    selected_country = NULL,
    selected_topic = NULL,
    current_page = "explorer"
  )
  
  # ==========================================
  # NAVIGATION TRACKING
  # ==========================================
  
  # Actualizar active nav cuando cambia la ruta
  observeEvent(get_page(), {
    page <- get_page()
    message("DEBUG: Current page = ", page)
    
    # Determinar qué página mostrar en el nav
    nav_page <- if(page == "/" || page == "countries" || page == "country_topics" || page == "content") {
      "explorer"
    } else {
      page
    }
    
    navigation$current_page <- nav_page
    session$sendCustomMessage("setActiveNav", nav_page)
  })
  
  # ==========================================
  # TOPIC CARD CLICK (Landing Page)
  # ==========================================
  
  observeEvent(input$topic_card_clicked, {
    topic <- input$topic_card_clicked
    message("DEBUG: Topic card clicked = ", topic)
    
    if (topic == "labor") {
      navigation$selected_topic <- topic
      change_page("countries")
    } else {
      showNotification(
        "This topic is coming soon!",
        type = "warning",
        duration = 3
      )
    }
  })
  
  # ==========================================
  # COUNTRY GRID RENDERING
  # ==========================================
  
  output$country_grid <- renderUI({
    message("DEBUG: Rendering country_grid")
    
    country_cards <- lapply(names(countries), function(country_id) {
      tags$div(
        class = "country-card",
        onclick = sprintf(
          "console.log('Country clicked: %s'); Shiny.setInputValue('country_selected', '%s', {priority: 'event'});",
          country_id, country_id
        ),
        h4(class = "country-name", countries[[country_id]])
      )
    })
    
    tags$div(
      class = "countries-grid",
      country_cards
    )
  })
  
  # ==========================================
  # COUNTRY SELECTION
  # ==========================================
  
  observeEvent(input$country_selected, {
    country <- input$country_selected
    message("DEBUG: Country selected = ", country)
    
    navigation$selected_country <- country
    change_page("country_topics")
  })
  
  # ==========================================
  # COUNTRY TOPICS PAGE RENDERING
  # ==========================================
  
  output$country_topics_content <- renderUI({
    message("DEBUG: Rendering country_topics_content")
    message("DEBUG: selected_country = ", navigation$selected_country)
    message("DEBUG: selected_topic = ", navigation$selected_topic)
    
    if (is.null(navigation$selected_country)) {
      return(
        tags$div(
          class = "page-section text-center",
          h3("No country selected"),
          p("Please go back and select a country."),
          tags$a(
            href = route_link("countries"),
            class = "btn btn-secondary",
            "← Back to Countries"
          )
        )
      )
    }
    
    country_name <- countries[[navigation$selected_country]]
    message("DEBUG: Country name = ", country_name)
    
    # Crear las tarjetas de topics para este país
    topic_cards <- lapply(names(topics), function(topic_id) {
      topic <- topics[[topic_id]]
      
      card_class <- paste0("topic-card", if(!topic$active) " disabled" else "")
      card_onclick <- if(topic$active) {
        sprintf(
          "console.log('Topic clicked: %s for country: %s'); Shiny.setInputValue('topic_for_country_clicked', '%s', {priority: 'event'});",
          topic_id, navigation$selected_country, topic_id
        )
      } else {
        ""
      }
      
      # Determinar la clase del header
      header_class <- paste0("topic-card-header ", topic_id)
      
      tags$div(
        class = card_class,
        onclick = card_onclick,
        tags$div(class = header_class),
        h3(class = "topic-card-title", topic$title),
        p(class = "topic-card-description", topic$description),
        if(!is.null(topic$badge)) {
          tags$span(class = "topic-card-badge", topic$badge)
        }
      )
    })
    
    tagList(
      # Back Button
      tags$a(
        href = route_link("countries"),
        class = "btn btn-back",
        "← Back to Countries"
      ),
      
      # Page Section
      tags$div(
        class = "page-section",
        
        # Title
        h1(class = "page-title", paste("Select a Topic for", country_name)),
        p(class = "page-subtitle", 
          "Choose a regulatory framework topic to explore detailed data and visualizations"),
        
        # Section Divider
        tags$div(
          class = "section-divider",
          "AVAILABLE TOPICS"
        ),
        
        # Topics Grid
        tags$div(
          class = "topics-grid",
          topic_cards
        )
      )
    )
  })
  
  # ==========================================
  # TOPIC FOR COUNTRY CLICK
  # ==========================================
  
  observeEvent(input$topic_for_country_clicked, {
    topic <- input$topic_for_country_clicked
    message("DEBUG: Topic for country clicked = ", topic)
    message("DEBUG: Current country = ", navigation$selected_country)
    
    navigation$selected_topic <- topic
    change_page("content")
  })
  
  # ==========================================
  # MODULE CONTENT RENDERING
  # ==========================================
  
  output$module_content <- renderUI({
    message("DEBUG: Rendering module_content")
    message("DEBUG: Topic = ", navigation$selected_topic)
    message("DEBUG: Country = ", navigation$selected_country)
    
    req(navigation$selected_topic)
    
    topic_title <- topics[[navigation$selected_topic]]$title
    country_name <- if(!is.null(navigation$selected_country)) {
      countries[[navigation$selected_country]]
    } else {
      "All Countries"
    }
    
    # Placeholder content - aquí irían los módulos reales
    tags$div(
      class = "page-section",
      
      h1(class = "page-title", topic_title),
      h3(style = "color: #002244; margin-bottom: 30px;", 
         paste("Data for:", country_name)),
      
      tags$div(
        style = "background: #F1F3F5; padding: 40px; border-radius: 8px; border: 1px solid #B9BAB5;",
        h4("Content Module Coming Soon"),
        p("This is where the actual data visualization and analysis will appear."),
        p(paste("Topic:", topic_title)),
        p(paste("Country:", country_name)),
        
        tags$div(
          class = "mt-40",
          tags$a(
            href = route_link("country_topics"),
            class = "btn btn-secondary",
            "← Back to Topics"
          ),
          tags$a(
            href = route_link("countries"),
            class = "btn btn-secondary",
            style = "margin-left: 15px;",
            "← Back to Countries"
          )
        )
      )
    )
  })
  
  # ==========================================
  # BACK BUTTON FROM CONTENT
  # ==========================================
  
  observeEvent(input$btn_back_from_content, {
    message("DEBUG: Back button clicked from content")
    
    if(!is.null(navigation$selected_country)) {
      change_page("country_topics")
    } else {
      change_page("/")
    }
  })
  
  # ==========================================
  # DEBUG INFO
  # ==========================================
  
  observe({
    message("=== NAVIGATION STATE ===")
    message("Current Page: ", navigation$current_page)
    message("Selected Country: ", ifelse(is.null(navigation$selected_country), "NULL", navigation$selected_country))
    message("Selected Topic: ", ifelse(is.null(navigation$selected_topic), "NULL", navigation$selected_topic))
    message("========================")
  })
}
