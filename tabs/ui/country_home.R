country_home<-fluidPage(
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
)