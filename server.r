library(shiny)
library(plotly)

shinyServer(function(input, output, session) {
  
  # =========================================================================
  # REACTIVE VALUES
  # =========================================================================
  
  navigation <- reactiveValues(
    current_view = "landing",
    previous_view = NULL,
    selected_topic = NULL,
    selected_country = NULL
  )
  
  # =========================================================================
  # CONFIGURATION
  # =========================================================================
  
  # Define available topics
  topics <- list(
    labor = list(
      title = "Non-salary Labor Costs",
      description = "Yearly bonuses, social security contributions, and employment benefits",
      ui_function = "render_labor_ui",
      server_function = "labor_server"
    ),
    minwage = list(
      title = "Minimum Wages",
      description = "Minimum wage policies and trends across the region",
      ui_function = "render_minwage_ui",
      server_function = "minwage_server"
    ),
    btax = list(
      title = "Business Taxes",
      description = "Corporate tax rates, incentives, and fiscal policies",
      ui_function = "render_btax_ui",
      server_function = "btax_server"
    ),
    social = list(
      title = "Social Assistance",
      description = "Social programs, welfare systems, and poverty alleviation policies",
      ui_function = "render_social_ui",
      server_function = "social_server"
    )
  )
  
  # Define available countries
  countries <- list(
    argentina = "Argentina",
    bolivia = "Bolivia",
    brazil = "Brazil",
    chile = "Chile",
    colombia = "Colombia",
    costa_rica = "Costa Rica",
    dominican = "Dominican Republic",
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
  
  # =========================================================================
  # NAVIGATION HANDLERS
  # =========================================================================
  
  # Handle "Explore by Topic" button
  observeEvent(input$explore_topic, {
    navigation$previous_view <- navigation$current_view
    navigation$current_view <- "topics"
    updateTabsetPanel(session, "main_tabs", selected = "topics")
  })
  
  # Handle "Explore by Country" button
  observeEvent(input$explore_country, {
    navigation$previous_view <- navigation$current_view
    navigation$current_view <- "countries"
    updateTabsetPanel(session, "main_tabs", selected = "countries")
  })
  
  # Handle back button
  observeEvent(input$back_button, {
    if (!is.null(navigation$previous_view)) {
      updateTabsetPanel(session, "main_tabs", selected = navigation$previous_view)
      temp <- navigation$current_view
      navigation$current_view <- navigation$previous_view
      navigation$previous_view <- temp
    }
  })
  
  # Handle topic selection
  observeEvent(input$topic_selected, {
    navigation$selected_topic <- input$topic_selected
    navigation$selected_country <- NULL
    navigation$previous_view <- "topics"
    navigation$current_view <- "content"
    updateTabsetPanel(session, "main_tabs", selected = "content")
  })
  
  # Handle country selection
  observeEvent(input$country_selected, {
    navigation$selected_country <- input$country_selected
    navigation$selected_topic <- NULL
    navigation$previous_view <- "countries"
    navigation$current_view <- "content"
    updateTabsetPanel(session, "main_tabs", selected = "content")
  })
  
  observeEvent(input$nav_selection, {
    updateTabsetPanel(session, "main_tabs", selected = input$nav_selection)
  })
  
  
  # =========================================================================
  # DYNAMIC UI GENERATION
  # =========================================================================
  
  # Generate topic cards
  output$topic_grid <- renderUI({
    topic_cards <- lapply(names(topics), function(topic_id) {
      topic <- topics[[topic_id]]
      tags$div(
        class = "topic-card",
        onclick = sprintf("Shiny.setInputValue('topic_selected', '%s', {priority: 'event'})", topic_id),
        h3(topic$title),
        p(topic$description)
      )
    })
    do.call(tagList, topic_cards)
  })
  
  # Generate country cards
  output$country_grid <- renderUI({
    country_cards <- lapply(names(countries), function(country_id) {
      tags$div(
        class = "country-card",
        onclick = sprintf("Shiny.setInputValue('country_selected', '%s', {priority: 'event'})", country_id),
        h4(countries[[country_id]])
      )
    })
    do.call(tagList, country_cards)
  })
  
  # =========================================================================
  # DYNAMIC CONTENT RENDERING
  # =========================================================================
  
  output$dynamic_content <- renderUI({
    # If a topic is selected
    if (!is.null(navigation$selected_topic)) {
      topic_id <- navigation$selected_topic
      if (topic_id %in% names(topics)) {
        # Call the appropriate UI rendering function
        ui_func_name <- topics[[topic_id]]$ui_function
        if (exists(ui_func_name)) {
          return(do.call(ui_func_name, list()))
        }
      }
      return(
        div(class = "text-center", style = "padding: 50px;",
            h3("Topic not implemented"),
            p("This topic view is not yet available.")
        )
      )
    }
    
    # If a country is selected
    if (!is.null(navigation$selected_country)) {
      country_id <- navigation$selected_country
      country_name <- countries[[country_id]]
      return(render_country_dashboard(country_name, country_id))
    }
    
    # Default: nothing selected
    return(
      div(class = "text-center", style = "padding: 50px;",
          h3("No selection made"),
          p("Please go back and select a topic or country to explore.")
      )
    )
  })
  
  # =========================================================================
  # UI RENDERING FUNCTIONS FOR TOPICS
  # =========================================================================
  
  render_labor_ui <- function() {
    source("modules/labor/ui_labor.R", local = TRUE)$value
    labor_ui("labor")
  }
  
  render_minwage_ui <- function() {
    source("modules/minwage/ui.R", local = TRUE)$value
    minwage_ui("minwage")
  }
  
  render_btax_ui <- function() {
    source("modules/btax/ui.R", local = TRUE)$value
    btax_ui("btax")
  }
  
  render_social_ui <- function() {
    source("modules/social/ui.R", local = TRUE)$value
    social_ui("social")
  }
  
  # =========================================================================
  # UI RENDERING FUNCTION FOR COUNTRY DASHBOARD
  # =========================================================================
  
  render_country_dashboard <- function(country_name, country_id) {
    tagList(
      h2(paste("Regulatory Framework:", country_name), 
         style = "margin: 20px; font-family: 'Source Serif Pro', serif;"),
      
      tabsetPanel(
        tabPanel("Overview",
                 div(style = "padding: 20px;",
                     p(paste("Overview of regulatory frameworks for", country_name))
                 )
        ),
        tabPanel("Labor Costs",
                 div(style = "padding: 20px;",
                     h3("Non-salary Labor Costs"),
                     p(paste("Labor cost data for", country_name))
                 )
        ),
        tabPanel("Minimum Wages",
                 div(style = "padding: 20px;",
                     h3("Minimum Wage Trends"),
                     p(paste("Minimum wage data for", country_name))
                 )
        ),
        tabPanel("Business Taxes",
                 div(style = "padding: 20px;",
                     h3("Business Tax Structure"),
                     p(paste("Business tax data for", country_name))
                 )
        ),
        tabPanel("Social Assistance",
                 div(style = "padding: 20px;",
                     h3("Social Programs"),
                     p(paste("Social assistance programs in", country_name))
                 )
        )
      )
    )
  }
  
  # =========================================================================
  # CALL MODULE SERVERS
  # =========================================================================
  
  # Only call server modules when the corresponding topic is selected
  observeEvent(navigation$selected_topic, {
    if (!is.null(navigation$selected_topic)) {
      topic_id <- navigation$selected_topic
      if (topic_id %in% names(topics)) {
        server_func_name <- topics[[topic_id]]$server_function
        
        # Source and call the appropriate server module
        tryCatch({
          if (topic_id == "labor") {
            source("modules/labor/server_labor.R", local = TRUE)$value
            callModule(labor_server, "labor")
          } else if (topic_id == "minwage") {
            source("modules/minwage/server.R", local = TRUE)$value
            callModule(minwage_server, "minwage")
          } else if (topic_id == "btax") {
            source("modules/btax/server.R", local = TRUE)$value
            callModule(btax_server, "btax")
          } else if (topic_id == "social") {
            source("modules/social/server.R", local = TRUE)$value
            callModule(social_server, "social")
          }
        }, error = function(e) {
          print(paste("Module not found:", server_func_name))
        })
      }
    }
  })
  
})