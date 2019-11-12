#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  boxplot_data <- reactive({ 
    shinyFileChoose(input, 'boxdata', roots = getVolumes(), session=session, filetypes=c('xls', 'xlsx', 'csv'))
    plotdata <- parseFilePaths(getVolumes(), input$boxdata)$datapath
    print(plotdata)
    
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
  
  observeEvent(input$plot_box, { 
    all_comparisons <- c()
    clist <- unique(boxplot_data()[[input$box_x]])
    tryCatch({
      ######## plot_vln_1
      output$plot_vln_1 <- renderPlot({
        ggplot(boxplot_data(), aes_string(x= input$box_x, y = input$box_y, group = input$box_x)) +
          geom_violin(trim = F) + scale_y_log10() + geom_boxplot(width = 0.2) +
          theme_bw() + theme(panel.grid = element_blank())
      })
      
      ######## plot_box_1 without w-test
      output$plot_box_1 <- renderPlot({
        ggboxplot(boxplot_data(), x = input$box_x, y = input$box_y, color = input$box_x, palette = "jco")
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
                color = input$box_x, palette = "jco") +
        stat_compare_means(method = 'wilcox.test', comparisons = my_comparisons) +
        stat_compare_means(label.y = 50)
    })
  })
})



