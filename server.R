#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  boxplot_data <- reactive({ 
    shinyFileChoose(input, 'boxdata', roots = volumes, session=session, filetypes=c('xls', 'xlsx', 'csv'))
    plotdata <- parseFilePaths(volumes, input$boxdata)$datapath
    
    if (length(plotdata) != 0){
      outdata <- read.csv(plotdata, header=TRUE)
      return(outdata)
    }
  }) 
  
  observeEvent(input$boxdata, {
    output$display_data <- DT::renderDataTable({
      DT::datatable(boxplot_data(), filter = 'top')
    })
    
  })
  
  output$box_xx <- renderUI({
    selectInput("box_x", "select axis x", choices = colnames(boxplot_data()))
  })
  
  output$box_yy <- renderUI({
    selectInput("box_y", "select axis y", choices = colnames(boxplot_data()))
  })
  
  observeEvent(input$box_x, { 
    all_comparisons <- c()
    clist <- unique(boxplot_data()[[input$box_x]])
    tryCatch({
      ######## plot_vln_1
      output$plot_vln_1 <- renderPlot({
        #df <- boxplot_data()
        ggplot(data=boxplot_data(), aes(x= boxplot_data()[[input$box_x]], y = boxplot_data()[[input$box_y]])) + geom_violin() + scale_y_log10()
      })
      ########
      
      coml <- t(combn(clist,2))
      for (i in 1:nrow(coml)){
        all_comparisons <- c(all_comparisons, paste(coml[i,1], "vs", coml[i,2],sep=" "))
      }
      output$box_comparisons <- renderUI({
        checkboxGroupInput('all_comparisons', 'select comparisons',  all_comparisons, selected = TRUE)
      })
    },
    error=function(e){print("box_x error")}, finally = {}
    )
  })
  
  observeEvent(input$all_comparisons, {
    output$plot_box_1 <- renderPlot({
      my_comparisons <- strsplit(input$all_comparisons, " vs ")
      ggboxplot(boxplot_data(), x = input$box_x, y = input$box_y,
                color = input$box_x, palette = "jco")+
        stat_compare_means(comparisons = my_comparisons)+
        stat_compare_means(label.y = 50)  
    })
  })
  
})



