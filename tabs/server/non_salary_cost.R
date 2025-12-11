labor_server <- function(input, output, session) {
  ns <- session$ns
  tabla <- readRDS("data/non_salary/health_all.rds")
  tabla <- readRDS("data/non_salary/health_payer.rds")
  
  # non_salary variables
  ns_variables<-reactiveValues(
    order_country=NULL
  )
  
  # --- Reading Tenure Variables --- #
  # df_non_salary_t <- readRDS("data/non_salary/total_non_salary_costs_tenure.rds")
  # df_non_salary_payer_t <- readRDS("data/non_salary/total_ns_costs_by_payer_tenure.rds")
  # df_non_salary_component_t <- readRDS("data/non_salary/total_ns_costs_by_component_tenure.rds")
  
  # ---- Non Salary Tables and adding tenure  ----
  df_non_salary <- readRDS("data/non_salary/1. total_non_salary_costs.rds")
  # df_non_salary$tenure <- "all Years"
  # df_non_salary <- rbind(df_non_salary, df_non_salary_t)
  
  df_non_salary_payer <- readRDS("data/non_salary/2. total_ns_costs_by_payer.rds")
  # df_non_salary_payer$tenure <- "all Years"
  # df_non_salary_payer <- rbind(df_non_salary_payer, df_non_salary_payer_t)
  
  df_non_salary_component <- readRDS("data/non_salary/3. total_ns_costs_by_component.rds")
  # df_non_salary_component$tenure <- "all Years"
  # df_non_salary_component <- rbind(df_non_salary_component, df_non_salary_component_t)
  
  # ---- Selection Groups: Button results ----
  selected_groupA <- reactiveVal("total") # Total, by Payer, By Component   
  selected_groupB <- reactiveVal("1sm") # 1 MW / 2 MW / 5 MW / 10 MW / 15 MW
  selected_groupC <- reactiveVal("all_component")
  
  # ---- Slider ----
  # tenure_selected <- reactiveVal("all Years")
  
  # ---- Check if the user is selecting "all Years"
  # tenure_selected <- reactive({
  #   if (isTRUE(input$all_slider)) {
  #     return("all")   
  #   } else {
  #     req(input$tenure_slider)
  #     return(as.numeric(input$tenure_slider))
  #   }
  # })
  
  # ---- First Selection ----
  observeEvent(input$btn_total,  { selected_groupA("total") })
  observeEvent(input$btn_payer,  { selected_groupA("payer") })
  observeEvent(input$btn_component,  { 
    selected_groupA("component") 
  })
  
  # ---- MW Selection ----
  observeEvent(input$btn_sm1,  { selected_groupB("1sm") })
  observeEvent(input$btn_sm2,  { selected_groupB("2sm") })
  observeEvent(input$btn_sm5,  { selected_groupB("5sm") })
  observeEvent(input$btn_sm10, { selected_groupB("10sm") })
  observeEvent(input$btn_sm15, { selected_groupB("15sm") })
  
  # ---- Components ----
  observeEvent(input$all_component,  { selected_groupC("all_component") })
  observeEvent(input$bonus,  { selected_groupC("bonuses_and_benefits") })
  observeEvent(input$social,  { selected_groupC("pensions") })
  observeEvent(input$payroll, { selected_groupC("payroll_taxes") })
  observeEvent(input$health, { selected_groupC("health") })
  
  # ---- Graph ----
  output$plot <- renderPlotly({
    
    
    # Requirements
    req(selected_groupA())
    req(selected_groupB())
    
    # Results from user click
    groupA <- selected_groupA()
    groupB <- selected_groupB()
    groupC <- selected_groupC()
    #t <- tenure_selected()
    
    # # Checking values
    # print("Filtros")
    # print(paste("GroupA:", groupA))
    # print(paste("GroupB:", groupB))
    # print(paste("Tenure:", paste(t,"Years")))
    
    # Transform value from button "1sm" → "1 MW"
    wage_filter<-paste0(substr(groupB, 1, nchar(groupB) - 2), " MW")
    
    # # case 1 year
    # if(t==1){
    #   te=paste(t,"Year")
    # }
    # else{
    #   te=paste(t,"Years")
    # }
    
    # ---- Total ----
    if (groupA == "total") {
      
      # Filtering total non salary
      df <- df_non_salary %>%
        filter(
          wage == wage_filter
        )
      
      if (nrow(df) == 0) {
        showNotification("No Data for this combination.", type = "error")
        return(NULL)
      }
      
      df_wide <- df %>%
        tidyr::pivot_wider(
          names_from = type,
          values_from = value
        ) %>%
        arrange(t_min) %>%
        mutate(country = factor(country, levels = country))
      
      ns_variables$order_country <- unique(as.character(df_wide$country))
      
      p <- plot_ly(df_wide) %>%
        add_bars(
          x = ~country,
          y = ~t_min,
          name = "Minimum",
          hoverinfo = "text",
          text = ~paste0(
            "<b>Country:</b> ", country, "<br>",
            "<b>Minimum Cost:</b> ", t_min, "<br>",
            "<b>Wage Analysis:</b> Total - ", wage_filter, "<br>",
            "<b>Tenure:</b> ", t
          ),
          textposition="none",
          marker = list(color = "#1f77b4")
        ) %>%
        add_bars(
          x = ~country,
          y = ~t_max,
          name = "Maximum",
          hoverinfo = "text",
          text = ~paste0(
            "<b>Country:</b> ", country, "<br>",
            "<b>Max Cost:</b> ", t_max, "<br>",
            "<b>Wage Analysis:</b> Total - ", wage_filter, "<br>"
          ),
          textposition="none",
          marker = list(color = "#ff7f0e")
        ) %>%
        layout(
          barmode = "group",
          xaxis = list(title = ""),
          yaxis = list(title = "Non-Salary costs as % of wages"),
          margin = list(t = 50),
          showlegend=F
        )
      
      return(p)
    }
    
    # ---- Total By Payer ----
    if (groupA == "payer") {
      
      # Filtering total non salary by payer
      
      
      df_long <- df_non_salary_payer %>%
        filter(
          wage == wage_filter
        ) %>%
        select(country, type_by_payer, value) %>%
        mutate(
          group = ifelse(grepl("_min$", type_by_payer), "Min", "Max"),
          payer = ifelse(grepl("^st_er", type_by_payer), "Employer", "Employee"),
          group = factor(group, levels = c("Min", "Max"))
        )
      
      df_long <- df_long %>%
        mutate(country = factor(country, levels = ns_variables$order_country)) %>% 
        arrange(country)
      
      if (nrow(df_long) == 0) {
        showNotification("No Data for this combination.", type = "error")
        return(NULL)
      }
      
      
      df <- df_long
      df$Type <- factor(df$payer, levels = c("Employee", "Employer"))
      df$Scenario <- factor(df$group, levels = c("Min", "Max"))
      
      colors <- c("Employer" = "#204d78", "Employee" = "#b5c6e6")
      
      paises <- unique(df$country)
      plot_list <- list()
      
      for (i in seq_along(paises)) {
        pais <- paises[i]
        data_pais <- df %>% filter(country == pais)
        
        show_legend <- ifelse(i == 1, TRUE, FALSE)
        
        p <- plot_ly(data_pais, x = ~Scenario, y = ~value, type = 'bar',
                     color = ~Type, colors = colors, legendgroup = ~Type,
                     showlegend = show_legend, text = ~value,
                     hoverinfo = "text+y+name") %>%
          layout(
            xaxis = list(title = pais),
            yaxis = list(title = ifelse(i == 1, "Non-salary costs as % of wages", ""),
                         range = c(0, 140)),
            barmode = 'stack'
          )
        
        plot_list[[i]] <- p
      }
      
      fig <- subplot(plot_list, nrows = 1, shareY = TRUE, titleX = TRUE) %>%
        layout(
          title = "",
          legend = list(orientation = "h", x = 0.3, y = -0.2),
          margin = list(b = 80)
        )
      
      return(fig)
    }
    
    # ---- Total by Component ----
    if (groupA == "component" & groupC=="all_component") {
      
      df_long <- df_non_salary_component %>%
        filter(
          wage == wage_filter
        ) %>%
        select(country, type_by_component, value) %>%
        mutate(
          group = ifelse(grepl("_min$", type_by_component), "Min", "Max"),
          payer = ifelse(grepl("^st_p", type_by_component), "Pension", 
                         ifelse(grepl("^st_h", type_by_component), "Health",
                                ifelse(grepl("^st_b", type_by_component), "Bonuses and Benefits",
                                       ifelse(grepl("^st_or", type_by_component), "Labor Risk","Payroll Taxes")))),
          group = factor(group, levels = c("Min", "Max"))
        )
      
      df_long <- df_long %>%
        mutate(country = factor(country, levels = ns_variables$order_country)) %>% 
        arrange(country)
      
      if (nrow(df_long) == 0) {
        showNotification("No Data for this combination.", type = "error")
        return(NULL)
      }
      
      
      df <- df_long
      df$Type <- factor(df$payer, levels = c("Pension", "Health","Labor Risk","Bonuses and Benefits","Payroll Taxes"))
      df$Scenario <- factor(df$group, levels = c("Min", "Max"))
      
      colors <- c("Pension"="#204d78","Health"="#b5c6e6",
                  "Labor Risk"="#272EF5","Bonuses and Benefits"="#F527A6",
                  "Payroll Taxes"="#A3F527")
      
      paises <- unique(df$country)
      plot_list <- list()
      
      for (i in seq_along(paises)) {
        pais <- paises[i]
        data_pais <- df %>% filter(country == pais)
        
        show_legend <- ifelse(i == 1, TRUE, FALSE)
        
        p <- plot_ly(data_pais, x = ~Scenario, y = ~value, type = 'bar',
                     color = ~Type, colors = colors, legendgroup = ~Type,
                     showlegend = show_legend, text = ~value,
                     hoverinfo = "text+y+name") %>%
          layout(
            xaxis = list(title = pais),
            yaxis = list(title = ifelse(i == 1, "Non-salary costs as % of wages", ""),
                         range = c(0, 140)),
            barmode = 'stack'
          )
        
        plot_list[[i]] <- p
      }
      
      fig <- subplot(plot_list, nrows = 1, shareY = TRUE, titleX = TRUE) %>%
        layout(
          title = "",
          legend = list(orientation = "h", x = 0.3, y = -0.2),
          margin = list(b = 80)
        )
      
      return(fig)
    }
    
    if (groupA == "component" & groupC!="all_component") {
      
      if(input$component_type=="Total"){
        path_component=paste0("data/non_salary/",paste0(groupC,"_all.rds"))
        print(path_component)
        df=readRDS(path_component)
        df <- df %>%
          filter(
            wage == wage_filter
          ) %>%
          select(country, min_max_total, value) %>%
          mutate(
            type = ifelse(grepl("_min$", min_max_total), "Min", "Max")
          )
      }
      
      
      if (nrow(df) == 0) {
        showNotification("No Data for this combination.", type = "error")
        return(NULL)
      }
      
      
      df_wide=df %>%
        group_by(country) %>%
        summarize(
          t_min = min(value, na.rm = TRUE),
          t_max = max(value, na.rm = TRUE)
        )%>%
        arrange(t_min) %>%
        mutate(country = factor(country, levels = country))
      
      #ns_variables$order_country <- unique(as.character(df_wide$country))
      
      p <- plot_ly(df_wide) %>%
        add_bars(
          x = ~country,
          y = ~t_min,
          name = "Minimum",
          hoverinfo = "text",
          text = ~paste0(
            "<b>Country:</b> ", country, "<br>",
            "<b>Minimum Cost:</b> ", t_min, "<br>",
            "<b>Wage Analysis:</b> Total - ", wage_filter, "<br>"
          ),
          textposition="none",
          marker = list(color = "#1f77b4")
        ) %>%
        add_bars(
          x = ~country,
          y = ~t_max,
          name = "Maximum",
          hoverinfo = "text",
          text = ~paste0(
            "<b>Country:</b> ", country, "<br>",
            "<b>Max Cost:</b> ", t_max, "<br>",
            "<b>Wage Analysis:</b> Total - ", wage_filter, "<br>"
          ),
          textposition="none",
          marker = list(color = "#ff7f0e")
        ) %>%
        layout(
          barmode = "group",
          xaxis = list(title = ""),
          yaxis = list(title = "Non-Salary costs as % of wages"),
          margin = list(t = 50),
          showlegend=F
        )
      
      return(p)
    }
    
    
  })
  
  
  # --- Components ----
  output$component_buttons <- renderUI({
    groupA <- selected_groupA()
    if(groupA!="component")return()
    else{
      tagList(
        div(
          class = "horizontal-container",
          style = "margin-top:20px; display:flex; align-items:center; gap:20px;",
          
          # ---- botones a la izquierda ----
          div(
            style = "display:flex; gap:8px;",
            
            actionButton(ns("all_component"), "All",
                         class = "pill-button active",
                         style = "background-color:  #f0f0f0; color: #333; border: none; border-radius: 20px; padding: 6px 18px;"),
            
            actionButton(ns("bonus"), "Bonuses and Benefits",
                         class = "pill-button",
                         style = "background-color: #f0f0f0; color: #333; border: none; border-radius: 20px; padding: 6px 18px;"),
            
            actionButton(ns("social"), "Social Security Contributions",
                         class = "pill-button",
                         style = "background-color: #f0f0f0; color: #333; border: none; border-radius: 20px; padding: 6px 18px;"),
            
            actionButton(ns("payroll"), "Payroll Taxes",
                         class = "pill-button",
                         style = "background-color: #f0f0f0; color: #333; border: none; border-radius: 20px; padding: 6px 18px;"),
            
            actionButton(ns("health"), "Health",
                         class = "pill-button",
                         style = "background-color: #f0f0f0; color: #333; border: none; border-radius: 20px; padding: 6px 18px;")
          ),
          
          # ---- select input alineado a la derecha ----
          div(
            class = "custom-select",
            style = "min-width:220px;",
            
            selectInput(
              inputId = ns("component_type"),
              label = "Analysis by:",
              choices = c("Total", "Payer"),
              selected = "Total"
            )
          )
        )
      )
      
    }
  })
  
}

