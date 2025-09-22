# modules/labor/server.R
library(tidyverse)

labor_server <- function(input, output, session) {
  
  # Get the namespace
  ns <- session$ns
  
  # Helper functions
  adjust_color_brightness <- function(hex, factor = 1) {
    if (is.na(hex) || !nzchar(hex)) return("#808080")
    rgb_mat <- try(grDevices::col2rgb(hex), silent = TRUE)
    if (inherits(rgb_mat, "try-error")) return("#808080")
    rgb_new <- pmin(255, pmax(0, round(rgb_mat[1:3, 1] * factor)))
    sprintf("#%02X%02X%02X", rgb_new[1], rgb_new[2], rgb_new[3])
  }
  
  wrap_country <- function(s, cutoff = 12) {
    ifelse(nchar(s) > cutoff, sub(" ", "\n", s), s)
  }
  
  theme_nyt <- function() {
    theme_minimal() +
      theme(
        text = element_text(family = "Arial", color = "#1a1a1a"),
        plot.title = element_text(size = 16, color = "#1a1a1a", margin = margin(b = 8), hjust = 0, face = "plain"),
        plot.subtitle = element_text(size = 12, color = "#666666", margin = margin(b = 20), hjust = 0),
        axis.title.y = element_text(size = 11, color = "#666666", margin = margin(r = 10)),
        axis.title.x = element_blank(),
        axis.text.x = element_text(size = 9, color = "#1a1a1a", hjust = 0.5),
        axis.text.y = element_text(size = 9, color = "#1a1a1a"),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major.y = element_line(color = "#e0e0e0", size = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA),
        plot.margin = margin(10, 20, 10, 10)
      )
  }
  
  # Country information for tooltips
  country_info <- list(
    "Argentina" = list(
      yearly_bonuses = "1 monthly wage",
      legislation = "Law 23041 (1983)."
    ),
    "Bolivia" = list(
      yearly_bonuses = "Christmas bonus: 1 monthly wage.<br>Economic growth bonus \"Doble aguinaldo\": 1 monthly wage awarded when the annual June-to-June GDP growth exceeds 4%.<br>Quinquennial bonus: Employees who have been in service for at least 5 years are entitled to five monthly wages paid every five years.<br>Employment tenure bonus (\"Antiguedad\"): 3 MW multiplied by a factor that varies with length of tenure:<br>- 2-4 years: 5%<br>- 5-7 years: 11%<br>- 8-10 years: 18%<br>- 11-14 years: 26%<br>- 15-19 years: 34%<br>- 20-24 years: 42%<br>- 25 or more years: 50%<br>Only employees working within 50km of international borders: Border subsidy: 20% of wages.",
      legislation = "Law of December 18th (1944) - Christmas bonus.<br>Supreme Decree 21137 (1985) - Bono antiguedad.<br>Supreme Decree 522 (2010) Bono quinquenio.<br>Supreme Decree 1802 (2013) - Doble aguinaldo."
    ),
    "Brazil" = list(
      yearly_bonuses = "Yearly bonus: 1 wage<br>Vacation bonus: equivalent to 1/3 wages.",
      legislation = "Law 4090 (1962)."
    ),
    "Chile" = list(
      yearly_bonuses = "No mandatory bonuses.",
      legislation = "Law 18620 (1987) - Labor Code."
    ),
    "Colombia" = list(
      yearly_bonuses = "Workers with wages under 13MW: 1 wage",
      legislation = "Law 1788 (2016)."
    ),
    "Dominican Republic" = list(
      yearly_bonuses = "Workers earning up to 5 MW: 1 wage<br>Workers earning more than 5 MW: 5 MW",
      legislation = "Ley 16 (1992) - Labor Code."
    ),
    "Ecuador" = list(
      yearly_bonuses = "2 wages",
      legislation = "Labor Code (2012)."
    ),
    "Honduras" = list(
      yearly_bonuses = "1 wage",
      legislation = "Decree No. 112. (1982) Ley del Séptimo Día y Décimo Tercer Mes en Concepto de Aguinaldo."
    ),
    "Mexico" = list(
      yearly_bonuses = "Yearly bonus (Aguinaldo): 0.5 wages<br>Vacation bonus: bonus equivalent to 25% of the wages corresponding to their vacation period.",
      legislation = "Federal Labor Law (1970). Last reform 2023."
    ),
    "Paraguay" = list(
      yearly_bonuses = "1 wage",
      legislation = "Law No. 213 (2014). Labor Code."
    ),
    "Peru" = list(
      yearly_bonuses = "Workers in medium and large businesses: 2 wages + corresponding employer health contribution (9% or 6.75% depending on modality).<br>Workers in small and micro businesses: 1 wage.<br>Family bonus: monthly bonus equivalent to 10% of the MW for workers who have children under 18 or children under 24 attending tertiary education.",
      legislation = "Law No. 27735. Yearly Bonus.<br>Law No. 25129. Family Bonus.<br>Decreto Supremo No. 013-2013-PRODUCE."
    )
  )
  
  # Data
  labor_data_raw <- data.frame(
    Country = c("Argentina", "Bolivia", "Bolivia", "Bolivia", "Bolivia", "Bolivia",
                "Brazil", "Chile", "Colombia", "Colombia", "Dominican Republic",
                "Ecuador", "Honduras", "Mexico", "Mexico", "Paraguay", "Peru", 
                "Paraguay", "Peru", "Paraguay", "Peru", "Paraguay"),
    Code = c("", "A", "B", "C", "D", "E", "", "", "A", "B", "", "", "", "A", "B", 
             "A", "A", "B", "C", "D", "E", "F"),
    Bonus_1 = c(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.3, 0.0, 1.0, 0.0, 1.0, 2.0, 1.0, 
                0.5, 0.5, 1.0, 2.0, 2.0, 2.0, 2.0, 1.0, 1.0),
    Bonus_2 = c(NA, NA, 1.0, 1.0, 1.0, 1.0, NA, NA, NA, NA, NA, NA, NA, 0.2, 0.4, 
                NA, 0.09, 0.07, 0.09, 0.07, NA, NA),
    Bonus_3 = c(NA, NA, 0.15, 1.5, 1.5, 1.5, NA, NA, NA, NA, NA, NA, NA, NA, NA, 
                NA, 0.1, 0.1, NA, NA, 0.1, NA),
    Bonus_4 = c(NA, NA, NA, NA, 0.2, 0.2, NA, NA, NA, NA, NA, NA, NA, NA, NA, 
                NA, NA, NA, NA, NA, NA, NA),
    Bonus_5 = c(NA, NA, NA, NA, NA, 5.0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 
                NA, NA, NA, NA, NA, NA, NA),
    stringsAsFactors = FALSE
  )
  
  # Reactive values
  selected_countries <- reactiveVal(unique(labor_data_raw$Country))
  active_button <- reactiveVal("btn_lac")
  
  # Update buttons function
  updateButtons <- function(active_btn) {
    buttons <- c("btn_lac", "btn_argentina", "btn_bolivia", "btn_brazil", "btn_chile", 
                 "btn_colombia", "btn_dominican", "btn_ecuador", "btn_honduras", 
                 "btn_mexico", "btn_paraguay", "btn_peru")
    for(btn in buttons) {
      if(btn == active_btn) {
        session$sendCustomMessage(ns("updateButtonClass"), 
                                  list(id = ns(btn), action = "add", class = "selected-country"))
      } else {
        session$sendCustomMessage(ns("updateButtonClass"), 
                                  list(id = ns(btn), action = "remove", class = "selected-country"))
      }
    }
  }
  
  # Country button observers
  observeEvent(input$btn_lac, { 
    selected_countries(unique(labor_data_raw$Country))
    active_button("btn_lac")
    updateButtons("btn_lac")
  })
  
  observeEvent(input$btn_argentina, { 
    selected_countries("Argentina")
    active_button("btn_argentina")
    updateButtons("btn_argentina")
  })
  
  observeEvent(input$btn_bolivia, { 
    selected_countries("Bolivia")
    active_button("btn_bolivia")
    updateButtons("btn_bolivia")
  })
  
  observeEvent(input$btn_brazil, { 
    selected_countries("Brazil")
    active_button("btn_brazil")
    updateButtons("btn_brazil")
  })
  
  observeEvent(input$btn_chile, { 
    selected_countries("Chile")
    active_button("btn_chile")
    updateButtons("btn_chile")
  })
  
  observeEvent(input$btn_colombia, { 
    selected_countries("Colombia")
    active_button("btn_colombia")
    updateButtons("btn_colombia")
  })
  
  observeEvent(input$btn_dominican, { 
    selected_countries("Dominican Republic")
    active_button("btn_dominican")
    updateButtons("btn_dominican")
  })
  
  observeEvent(input$btn_ecuador, { 
    selected_countries("Ecuador")
    active_button("btn_ecuador")
    updateButtons("btn_ecuador")
  })
  
  observeEvent(input$btn_honduras, { 
    selected_countries("Honduras")
    active_button("btn_honduras")
    updateButtons("btn_honduras")
  })
  
  observeEvent(input$btn_mexico, { 
    selected_countries("Mexico")
    active_button("btn_mexico")
    updateButtons("btn_mexico")
  })
  
  observeEvent(input$btn_paraguay, { 
    selected_countries("Paraguay")
    active_button("btn_paraguay")
    updateButtons("btn_paraguay")
  })
  
  observeEvent(input$btn_peru, { 
    selected_countries("Peru")
    active_button("btn_peru")
    updateButtons("btn_peru")
  })
  
  # Initialize buttons
  observeEvent(TRUE, { updateButtons("btn_lac") }, once = TRUE)
  
  # Process data
  processed_data <- reactive({
    # Ensure we have valid country selection
    selected_ctries <- selected_countries()
    if (is.null(selected_ctries) || length(selected_ctries) == 0) {
      selected_ctries <- unique(labor_data_raw$Country)
    }
    
    # Filter data by selected countries
    data <- labor_data_raw[labor_data_raw$Country %in% selected_ctries, ]
    
    # Check if we have data after filtering
    if (nrow(data) == 0) {
      return(data.frame())
    }
    
    # Convert to long format - show all bonus types since we removed the filter
    data_long <- data %>%
      pivot_longer(cols = starts_with("Bonus_"), 
                   names_to = "bonus_type", 
                   values_to = "value", 
                   names_prefix = "Bonus_") %>%
      filter(!is.na(value) & value > 0) %>%
      mutate(
        bonus_type = paste("Bonus", bonus_type),
        x_label = paste0(Code, "\n", wrap_country(Country)),
        x_order = paste(Country, Code, sep = "_")
      ) %>%
      arrange(Country, Code, bonus_type) %>%
      mutate(x_label = factor(x_label, levels = unique(x_label)))
    
    # Add custom tooltip text with country information
    if (nrow(data_long) > 0) {
      data_long$tooltip_text <- sapply(seq_len(nrow(data_long)), function(i) {
        country <- data_long$Country[i]
        info <- country_info[[country]]
        
        if (!is.null(info)) {
          paste0(
            "<b style='color: #0f3559; font-size: 16px;'>", country, "</b><br>",
            "────────────────────────<br>",
            "<b style='color: #d62728; font-size: 14px;'>Yearly Bonuses:</b><br>",
            "<span style='font-size: 13px; line-height: 1.4;'>", gsub("<br>", "<br>• ", paste0("• ", info$yearly_bonuses)), "</span><br><br>",
            "<b style='color: #d62728; font-size: 14px;'>Legislation:</b><br>",
            "<span style='font-size: 13px; line-height: 1.4;'>", gsub("<br>", "<br>• ", paste0("• ", info$legislation)), "</span>"
          )
        } else {
          paste0(
            "<b style='color: #0f3559; font-size: 14px;'>", country, ifelse(data_long$Code[i] != "", paste(" (", data_long$Code[i], ")", sep = ""), ""), "</b><br>",
            data_long$bonus_type[i], ": <b>", round(data_long$value[i], 2), "</b> monthly wages"
          )
        }
      })
    }
    
    data_long
  })
  
  # Data summary
  output$data_summary <- renderText({
    data <- processed_data()
    if(nrow(data) == 0) return("No data available for selected filters")
    n_countries <- length(unique(data$Country))
    n_entries <- nrow(data)
    avg_bonus <- round(mean(data$value, na.rm = TRUE), 2)
    paste0(n_countries, " countries, ", n_entries, " data points\nAverage bonus: ", 
           avg_bonus, " monthly wages")
  })
  
  # Main plot
  output$labor_costs_plot <- renderPlotly({
    data <- processed_data()
    
    if(nrow(data) == 0) {
      return(plot_ly(type = 'scatter', mode = 'markers') %>%
               add_annotations(text = "No data available for selected filters", 
                               x = 0.5, y = 0.5, xref = "paper", yref = "paper",
                               showarrow = FALSE, 
                               font = list(size = 16, color = "#666666", family = "Arial")) %>%
               layout(xaxis = list(visible = FALSE), 
                      yaxis = list(visible = FALSE),
                      plot_bgcolor = 'white', 
                      paper_bgcolor = 'white'))
    }
    
    # Color setup
    data$fill_id <- paste(data$Country, data$bonus_type, sep = "_")
    
    default_colors <- c(
      "Argentina" = "#9467bd",
      "Bolivia" = "#17becf",
      "Brazil" = "#ffbb78",
      "Chile" = "#aec7e8",
      "Colombia" = "#98df8a",
      "Dominican Republic" = "#ff00ff",
      "Ecuador" = "#d62728",
      "Honduras" = "#ff9896",
      "Mexico" = "#ff7f0e",
      "Paraguay" = "#2ca02c",
      "Peru" = "#1f77b4"
    )
    
    data$fill_color <- vapply(seq_len(nrow(data)), function(i) {
      country_color <- default_colors[data$Country[i]]
      if(is.na(country_color)) country_color <- "#808080"
      factor <- switch(data$bonus_type[i],
                       "Bonus 1" = 0.6,
                       "Bonus 2" = 0.75,
                       "Bonus 3" = 0.9,
                       "Bonus 4" = 1.1,
                       "Bonus 5" = 1.3,
                       1.0)
      adjust_color_brightness(country_color, factor)
    }, character(1))
    
    unique_ids <- unique(data$fill_id)
    color_palette <- vapply(unique_ids, function(uid) {
      idx <- which(data$fill_id == uid)[1]
      if(!is.na(idx) && !is.na(data$fill_color[idx])) data$fill_color[idx] else "#808080"
    }, character(1))
    names(color_palette) <- unique_ids
    
    data$fill_id <- factor(data$fill_id, levels = unique_ids)
    
    # Calculate y-axis limits safely
    y_max <- tryCatch({
      max(aggregate(value ~ x_label, data, sum, na.rm = TRUE)$value, na.rm = TRUE) * 1.1
    }, error = function(e) {
      max(data$value, na.rm = TRUE) * 1.1
    })
    
    if (is.infinite(y_max) || is.na(y_max)) y_max <- 5
    
    # Create plot
    p <- ggplot(data, aes(x = x_label, y = value, fill = fill_id, 
                          group = bonus_type, text = tooltip_text)) +
      geom_col(position = "stack", width = 0.7, alpha = 0.95) +
      scale_fill_manual(values = color_palette, guide = "none") +
      labs(y = "Yearly bonuses in number of monthly wages") +
      theme_nyt() +
      scale_y_continuous(
        limits = c(0, y_max),
        expand = c(0, 0),
        breaks = seq(0, ceiling(y_max), by = 1)
      )
    
    # Remove the "show values" feature since the option was removed
    # if(isTRUE(input$show_values) && nrow(data) > 0) {
    #   data_labels <- data %>%
    #     group_by(x_label) %>%
    #     arrange(desc(bonus_type)) %>%
    #     mutate(cumsum_value = cumsum(value), 
    #            label_pos = cumsum_value - value/2)
    #   p <- p + geom_text(data = data_labels, 
    #                      aes(y = label_pos, label = round(value, 1)),
    #                      size = 2.5, color = "white", fontface = "bold")
    # }
    
    # Add country separators
    if (nrow(data) > 1) {
      separator_positions <- c()
      current_country <- data$Country[1]
      for(i in 2:nrow(data)) {
        if(data$Country[i] != current_country) {
          pos_index <- which(levels(data$x_label) == data$x_label[i])[1]
          if(length(pos_index) > 0 && !is.na(pos_index)) {
            separator_positions <- c(separator_positions, pos_index - 0.5)
          }
          current_country <- data$Country[i]
        }
      }
      
      if(length(separator_positions) > 0) {
        p <- p + geom_vline(xintercept = separator_positions, 
                            color = "#d0d0d0", size = 0.5, linetype = "solid")
      }
    }
    
    ggplotly(p, tooltip = "text") %>%
      layout(
        hovermode = 'closest',
        hoverlabel = list(
          bgcolor = "white",
          bordercolor = "#0f3559",
          borderwidth = 2,
          font = list(family = "Arial", size = 12, color = "#333333"),
          align = "left"
        ),
        showlegend = FALSE,
        margin = list(l = 60, r = 30, t = 30, b = 100),
        plot_bgcolor = 'white',
        paper_bgcolor = 'white',
        font = list(family = "Arial", size = 10, color = "#1a1a1a"),
        xaxis = list(title = "", tickangle = 0, 
                     tickfont = list(size = 10, family = "Arial"),
                     showgrid = FALSE, zeroline = FALSE, showline = TRUE, 
                     linecolor = "#d0d0d0", linewidth = 1),
        yaxis = list(title = list(text = "Yearly bonuses in number of monthly wages",
                                  font = list(size = 11, family = "Arial", color = "#666666")),
                     tickfont = list(size = 10), 
                     gridcolor = "#e0e0e0", 
                     gridwidth = 0.5,
                     zeroline = TRUE, 
                     zerolinecolor = "#d0d0d0", 
                     zerolinewidth = 1, 
                     showline = FALSE)
      ) %>%
      config(displayModeBar = TRUE,
             modeBarButtonsToRemove = c('pan2d','select2d','lasso2d','autoScale2d',
                                        'hoverClosestCartesian','hoverCompareCartesian'),
             displaylogo = FALSE)
  })
}