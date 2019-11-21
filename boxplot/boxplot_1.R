


boxplot_par_plot <- fluidRow(
  box(
    fileInput("boxdata", "Choose CSV File to plot",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")
    ),
    uiOutput("box_xx"),
    uiOutput("box_yy"),
    uiOutput("box_cc"),
    uiOutput("box_comparisons"),
    br(),
    actionButton("plot_box", "plot!"),
    br(),
    width = 3
  ),
  
  tabBox(
    title = "boxplot",
    # The id lets us use input$tabset1 on the server to find the current tab
    id = "boxplot_tabset1", height = "250px",
    tabPanel("box", plotOutput("plot_box_1")),
    tabPanel("vln", plotOutput("plot_vln_1")),
    tabPanel("ridges", plotOutput("plot_ridges_1")),
    tabPanel("data", DT::dataTableOutput("display_data")),
    tabPanel("help", includeMarkdown("boxplot/boxplot.md")),
    width = 8
  )
)



