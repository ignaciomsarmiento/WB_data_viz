# modules/labor/ui.R

labor_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Custom styles for this module
    tags$head(
      tags$style(HTML(sprintf("
        .filter-panel { background:#f8f9fa; padding:14px; border:1px solid #e9ecef; border-radius:8px; margin-bottom:16px; }
        .country-buttons { display:flex; flex-direction:column; gap:6px; margin-bottom:10px; }
        .country-btn {
          display:block; width:100%%; text-align:left; font-size:11px; padding:6px 10px;
          border:1px solid #ddd; background:#fff; color:#333; border-radius:4px;
          transition: background-color .2s ease, border-color .2s ease;
        }
        .country-btn:hover { background:#f5f5f5; border-color:#999; }
        .selected-country { background:#d62728 !important; color:#fff !important; border-color:#d62728 !important; font-weight:500; }
      ", ns("dummy")))),
      
      # JavaScript for button updates (namespaced)
      tags$script(HTML(sprintf("
        Shiny.addCustomMessageHandler('%s', function(message) {
          var $el = $('#' + message.id);
          if (message.action === 'add') { 
            $el.addClass(message.class); 
          } else { 
            $el.removeClass(message.class); 
          }
        });
      ", ns("updateButtonClass"))))
    ),
    
    # Main content
    div(class = "main-title", "Non-salary labor costs"),
    div(class = "subtitle", "Yearly bonuses in number of monthly wages across Latin America"),
    
    sidebarLayout(
      sidebarPanel(
        width = 2,
        div(class = "filter-panel",
            h4("Filters", style = "margin-top:0; font-size:16px;"),
            
            h5("Countries:", style = "font-size:13px; margin-bottom:8px;"),
            div(class = "country-buttons",
                actionButton(ns("btn_lac"), "All LAC", class = "btn country-btn selected-country"),
                actionButton(ns("btn_argentina"), "Argentina", class = "btn country-btn"),
                actionButton(ns("btn_bolivia"), "Bolivia", class = "btn country-btn"),
                actionButton(ns("btn_brazil"), "Brazil", class = "btn country-btn"),
                actionButton(ns("btn_chile"), "Chile", class = "btn country-btn"),
                actionButton(ns("btn_colombia"), "Colombia", class = "btn country-btn"),
                actionButton(ns("btn_dominican"), "Dominican Republic", class = "btn country-btn"),
                actionButton(ns("btn_ecuador"), "Ecuador", class = "btn country-btn"),
                actionButton(ns("btn_honduras"), "Honduras", class = "btn country-btn"),
                actionButton(ns("btn_mexico"), "Mexico", class = "btn country-btn"),
                actionButton(ns("btn_paraguay"), "Paraguay", class = "btn country-btn"),
                actionButton(ns("btn_peru"), "Peru", class = "btn country-btn")
            ),
            
            h5("Bonus Types:", style = "font-size:13px; margin:10px 0 6px 0;"),
            div(class = "checkbox-group",
                checkboxGroupInput(
                  ns("bonus_types"), NULL,
                  choices = list(
                    "Bonus 1" = "Bonus_1",
                    "Bonus 2" = "Bonus_2",
                    "Bonus 3" = "Bonus_3",
                    "Bonus 4" = "Bonus_4",
                    "Bonus 5" = "Bonus_5"
                  ),
                  selected = c("Bonus_1", "Bonus_2", "Bonus_3", "Bonus_4", "Bonus_5")
                )
            ),
            
            h5("Additional Options:", style = "font-size:13px; margin:10px 0 6px 0;"),
            checkboxInput(ns("show_values"), "Show values on bars", value = FALSE),
            checkboxInput(ns("show_notes"), "Show explanatory notes", value = TRUE),
            
            div(style = "font-size:11px; color:#666; border-top:1px solid #eee; padding-top:10px; margin-top:8px;",
                h5("Data Summary:", style = "font-size:12px; margin-bottom:6px;"),
                textOutput(ns("data_summary"))
            )
        )
      ),
      
      mainPanel(
        width = 10,
        plotlyOutput(ns("labor_costs_plot"), height = "650px"),
        conditionalPanel(
          condition = paste0("input['", ns("show_notes"), "']"),
          div(style = "margin-top:18px; padding:16px; background-color:#f8f9fa; border-left:4px solid #d62728;",
              h5("Notes:", style = "font-size:15px; margin-bottom:10px; font-weight:600;"),
              p("Data represents non-salary labor costs as multiples of monthly wages. Different countries have varying bonus structures.",
                style = "font-size:12px; color:#333; line-height:1.5; margin-bottom:8px;"),
              tags$ul(style = "font-size:11px; color:#666; line-height:1.4; margin-bottom:0;",
                      tags$li("Bolivia shows different scenarios, A to E, based on wage levels and tenure"),
                      tags$li("Colombia and Mexico have different calculation methods, A and B"),
                      tags$li("Paraguay and Peru show variations across different benefit categories, A to F"),
                      tags$li("Empty cells indicate the bonus type does not apply to that country or category")
              )
          )
        )
      )
    )
  )
}
