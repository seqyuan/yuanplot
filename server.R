shinyServer(function(input, output, session) {
  ############################## boxplot
  boxplot_data <- reactive({ 
    #shinyFileChoose(input, 'boxdata', roots = getVolumes(), session=session, filetypes=c('xls', 'xlsx', 'csv'))
    inFile <- input$boxdata
    if (is.null(inFile)){
      return(NULL)
    }
    
    outdata <- read.csv(inFile$datapath, header=TRUE,sep=",")
    return(outdata)
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
  
  output$box_cc <- renderUI({
    selectInput("box_c", "select color by", choices = colnames(boxplot_data()))
  })
  
  observeEvent({
    input$plot_box
    }, { 
    all_comparisons <- c()
    clist <- unique(boxplot_data()[[input$box_x]])
    tryCatch({
      ######## plot_vln_1
      output$plot_vln_1 <- renderPlot({
        plot_data <- boxplot_data()
        plot_data[[input$box_x]] <- as.character(plot_data[[input$box_x]])
        ggplot(plot_data, aes_string(x= input$box_x, y = input$box_y, color = input$box_x)) +
          geom_violin(trim = F, alpha=0.8) + scale_y_log10() + geom_boxplot(width = 0.1) +
          theme_bw() + theme(panel.grid = element_blank())
      })
      
      ######## ridges
      output$plot_ridges_1 <- renderPlot({
        plot_data <- boxplot_data()
        plot_data[[input$box_x]] <- as.character(plot_data[[input$box_x]])
        plot_data[[input$box_c]] <- as.character(plot_data[[input$box_c]])
        
        ggplot(plot_data, aes_string(x = input$box_y, y = input$box_x, color=input$box_c, fill=input$box_c)) +
          geom_density_ridges(alpha=0.5) +
          scale_y_discrete(expand = c(0.01, 0)) +
          scale_x_continuous(expand = c(0.01, 0)) +
          theme_ridges(grid=FALSE)
      })
      
      ######## plot_box_1 without w-test
      output$plot_box_1 <- renderPlot({
        ggboxplot(boxplot_data(), x = input$box_x, y = input$box_y, color = input$box_x)
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
      ggboxplot(boxplot_data(), x = input$box_x, y = input$box_y, color = input$box_x) +
        stat_compare_means(method = 'wilcox.test', comparisons = my_comparisons) +
        stat_compare_means(label.y = 50)
    })
  })
  
  ################################################################### ratio plot
  pb_plot_data <- reactive({ 
    inFile <- input$pbar_data
    if (is.null(inFile)){
      return(NULL)
    }
    
    outdata <- read.csv(inFile$datapath, header=TRUE)
    return(outdata)
  }) 
  
  observeEvent(input$pb_plot_data, {
    output$display_pbdata <- DT::renderDataTable({
      DT::datatable(pb_plot_data(), filter = 'top')
    })
    
  })
  
  output$pbar_xx <- renderUI({
    selectInput("pbar_x", "选择要计算percent的列", choices = colnames(pb_plot_data()))
  })
  
  output$pbar_yy <- renderUI({
    selectInput("pbar_y", "选择要计算percent的元素列", choices = colnames(pb_plot_data()))
  })
  
  observeEvent({input$plot_percent_bar}, {
    tryCatch({
      ######## plot_percent
      output$percent_bar_1 <- renderPlot({
        plot_data <- pb_plot_data()
        
        ggplot(plot_data, aes_string(x= input$pbar_x, fill=input$pbar_y)) +
          geom_bar(position = 'fill') +
          coord_flip() +
          theme_bw() + theme(panel.grid = element_blank())
      })
    })
  })
  
})
