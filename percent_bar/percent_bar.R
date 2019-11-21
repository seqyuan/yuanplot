percent_barplot <- fluidRow(
  box(
    fileInput("pbar_data", "Choose CSV File to plot",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")
    ),
    uiOutput("pbar_xx"),
    uiOutput("pbar_yy"),
    br(),
    actionButton("plot_percent_bar", "plot!"),
    br(),
    width = 3
  ),
  
  tabBox(
    title = "percent bar",
    id = "percent_bar_tabset1", height = "250px",
    tabPanel("percentbar", plotOutput("percent_bar_1")),
    tabPanel("help", includeMarkdown("percent_bar/percent_bar.md")),
    width = 8
  )
)