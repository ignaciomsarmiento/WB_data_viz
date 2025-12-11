# modules/labor/ui.R


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

annual_leave_raw <- data.frame(
  Country = c(
    rep("Argentina", 4),
    rep("Bolivia", 3),
    rep("Brazil", 4),
    "Chile",
    "Colombia",
    rep("Dominican Republic", 2),
    rep("Ecuador", 4),
    rep("Honduras", 4),
    rep("Mexico", 2),
    rep("Paraguay", 3),
    rep("Peru", 2)
  ),
  Code = c(
    "A", "B", "C", "D",
    "A", "B", "C",
    "A", "B", "C", "D",
    "A",
    "A",
    "A", "B",
    "A", "B", "C", "D*",
    "A", "B", "C", "D",
    "A", "B",
    "A", "B", "C",
    "A", "B"
  ),
  Bonus_1 = c(
    14, 21, 28, 35,
    15, 20, 30,
    12, 18, 24, 30,
    15,
    15,
    14, 18,
    15, 18, 20, 30,
    10, 12, 15, 20,
    12, 32,
    12, 18, 30,
    15, 30
  ),
  Bonus_2 = NA_real_,
  Bonus_3 = NA_real_,
  Bonus_4 = NA_real_,
  Bonus_5 = NA_real_,
  stringsAsFactors = FALSE
)



labor_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Custom styles for this module
    tags$head(
      tags$style(HTML("
        .filter-panel { background:#f8f9fa; padding:14px; border:1px solid #e9ecef; border-radius:8px; margin-bottom:16px; }
        .country-buttons { display:flex; flex-direction:column; gap:6px; margin-bottom:10px; }
        .country-btn {
          display:block; width:100%; text-align:left; font-size:12px; padding:6px 10px;
          border:1px solid #ddd; background:#fff; color:#333; border-radius:4px;
          transition: background-color .2s ease, border-color .2s ease;
          white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .country-btn:hover { background:#f5f5f5; border-color:#999; }
        .selected-country { background:#d62728 !important; color:#fff !important; border-color:#d62728 !important; font-weight:500;
        .benefit-panel { margin-bottom: 10px; }
  .benefit-buttons { display:flex; flex-wrap:wrap; gap:6px; margin-bottom:8px; }
  .benefit-btn {
    font-size:12px; padding:6px 10px;
    border-radius:14px; border:1px solid #ccc;
    background:#fff; color:#333;
  }
  .benefit-btn:hover { background:#f5f5f5; border-color:#999; }
  .selected-benefit {
    background:#0f3559 !important;
    color:#fff !important;
    border-color:#0f3559 !important;
    font-weight:500;
  }
      ")),
      
      # JavaScript for button updates (namespaced)
      tags$script(HTML(paste0("
        Shiny.addCustomMessageHandler('", ns("updateButtonClass"), "', function(message) {
          var $el = $('#' + message.id);
          if (message.action === 'add') { 
            $el.addClass(message.class); 
          } else { 
            $el.removeClass(message.class); 
          }
        });
      ")))
    ),
    
    # Main content
    div(class = "main-title", "Non-salary labor costs"),
    div(class = "subtitle", "Yearly bonuses in number of monthly wages across Latin America"),
    
    sidebarLayout(
      sidebarPanel(
        width = 3,  # Using integer width
        div(class = "filter-panel",
            h4("Filters", style = "margin-top:0; font-size:18px;"),
            
            h5("Countries:", style = "font-size:15px; margin-bottom:8px;"),
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
            
            h5("Additional Options:", style = "font-size:15px; margin:10px 0 6px 0;"),
            checkboxInput(ns("show_notes"), "Show explanatory notes", value = TRUE)
        )
      ),
      
      mainPanel(
        width = 9,  # Using integer width to balance with width 3
        div(
          class = "non_salary_components-panel",
          div(
            class = "non_salary_components-buttons",
            actionButton(ns("bonuses_n_benefits"), "Bonuses and Benefits", class = "btn benefit-btn selected-benefit"),
            actionButton(ns("contributory_sss"), "Contributory Social Security System", class = "btn benefit-btn"),
            actionButton(ns("payroll"), "Payroll taxes", class = "btn benefit-btn")
          )
        ),
        div(
          class = "benefit-panel",
          div(
            class = "benefit-buttons",
            actionButton(ns("benefit_yearly"), "Yearly bonuses", class = "btn benefit-btn selected-benefit"),
            actionButton(ns("benefit_annual"), "Annual leave", class = "btn benefit-btn"),
            actionButton(ns("benefit_unemp"), "Unemployment protection", class = "btn benefit-btn"),
            actionButton(ns("benefit_other"), "Other benefits", class = "btn benefit-btn"),
            actionButton(ns("benefit_severance"), "Severance payment", class = "btn benefit-btn"),
            actionButton(ns("benefit_parental"), "Parental leave", class = "btn benefit-btn")
          )
        ),
        
        plotlyOutput(ns("labor_costs_plot"), height = "650px"),
        conditionalPanel(
          condition = paste0("input['", ns("show_notes"), "']"),
          div(style = "margin-top:18px; padding:16px; background-color:#f8f9fa; border-left:4px solid #d62728;",
              h5("Notes:", style = "font-size:17px; margin-bottom:10px; font-weight:600;"),
              p("Data represents non-salary labor costs as multiples of monthly wages. Different countries have varying bonus structures.",
                style = "font-size:14px; color:#333; line-height:1.5; margin-bottom:8px;"),
              tags$ul(style = "font-size:13px; color:#666; line-height:1.4; margin-bottom:0;",
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
