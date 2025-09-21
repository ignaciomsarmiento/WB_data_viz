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
    data <- labor_data_raw[labor_data_raw$Country %in% selected_countries(), ]
    
    # Filter by selected bonus types if any are selected
    if (!is.null(input$bonus_types) && length(input$bonus_types) > 0) {
      bonus_cols <- paste0("Bonus_", gsub("Bonus_", "", input$bonus_types))
      keep_cols <- c("Country", "Code", bonus_cols)
      data <- data[, names(data) %in% keep_cols]
    }
    
    data_long <- data %>%
      pivot_longer(cols = starts_with("Bonus_"), 
                   names_to = "bonus_type", 
                   values_to = "value", 
                   names_prefix = "Bonus_") %>%
      filter(!is.na(value), value > 0) %>%
      mutate(
        bonus_type = paste("Bonus", bonus_type),
        x_label = paste0(Code, "\n", wrap_country(Country)),
        x_order = paste(Country, Code, sep = "_"),
        tooltip_text = paste0(
          "<b>", Country, ifelse(Code != "", paste(" (", Code, ")", sep = ""), ""), "</b><br>",
          bonus_type, ": <b>", round(value, 2), "</b> monthly wages"
        )
      ) %>%
      arrange(Country, Code, bonus_type) %>%
      mutate(x_label = factor(x_label, levels = unique(x_label)))
    
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
      return(plot_ly() %>%
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
    
    # Create plot
    p <- ggplot(data, aes(x = x_label, y = value, fill = fill_id, 
                          group = bonus_type, text = tooltip_text)) +
      geom_col(position = "stack", width = 0.7, alpha = 0.95) +
      scale_fill_manual(values = color_palette, guide = "none") +
      labs(y = "Yearly bonuses in number of monthly wages") +
      theme_nyt() +
      scale_y_continuous(
        limits = c(0, max(aggregate(value ~ x_label, data, sum)$value) * 1.1),
        expand = c(0, 0),
        breaks = seq(0, 10, by = 1)
      )
    
    if(isTRUE(input$show_values)) {
      data_labels <- data %>%
        group_by(x_label) %>%
        arrange(desc(bonus_type)) %>%
        mutate(cumsum_value = cumsum(value), 
               label_pos = cumsum_value - value/2)
      p <- p + geom_text(data = data_labels, 
                         aes(y = label_pos, label = round(value, 1)),
                         size = 2.5, color = "white", fontface = "bold")
    }
    
    # Add country separators
    separator_positions <- c()
    current_country <- data$Country[1]
    for(i in 2:nrow(data)) {
      if(data$Country[i] != current_country) {
        pos_index <- which(levels(data$x_label) == data$x_label[i])[1]
        if(length(pos_index) > 0) separator_positions <- c(separator_positions, pos_index - 0.5)
        current_country <- data$Country[i]
      }
    }
    
    if(length(separator_positions) > 0) {
      p <- p + geom_vline(xintercept = separator_positions, 
                          color = "#d0d0d0", size = 0.5, linetype = "solid")
    }
    
    ggplotly(p, tooltip = "text") %>%
      layout(
        hovermode = 'closest',
        hoverlabel = list(bgcolor = "rgba(255, 255, 255, 0.95)", 
                          bordercolor = "#d0d0d0", 
                          borderwidth = 1,
                          font = list(family = "Arial", size = 11, color = "#1a1a1a")),
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