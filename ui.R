#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(DT)

# Define UI for application that draws a histogram
shinyUI(tagList(
  shinythemes::themeSelector(),
  navbarPage(
    # theme = "cerulean",  # <--- To use a theme, uncomment this
    "seqyuan baseplot APP",
    tabPanel("boxplot",
             sidebarPanel(
               shinyFilesButton('boxdata', 'uplod data to plot', 'Please select a file', FALSE),
               uiOutput("box_xx"),
               uiOutput("box_yy"),
               uiOutput("box_comparisons"),
               br(),
               actionButton("plot_box", "plot!"),
               br()
             ),
             
             mainPanel(
               tabsetPanel(type = "tabs",
                           tabPanel("box",
                                    plotOutput("plot_box_1"),
                                    plotOutput("plot_box_2")
                           ),
                           tabPanel("vln",
                                    plotOutput("plot_vln_1")
                           ),
                           tabPanel("help",
                                    DT::dataTableOutput("display_data"),
                                    br(),
                                    includeMarkdown("boxplot.md"),
                                    br()
                           )
               )
               
             )
    )
  )
))


