library(shiny)
library(shinydashboard)
library(markdown)
library(DT)
library(ggplot2)
library(ggridges)
library(ggpubr)
library(dplyr)
library(ggsci)

source("boxplot/boxplot_1.R")
source("percent_bar/percent_bar.R")
source("cellMarkerHeatmap/cellMarkerHeatmap.R")


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("boxplot", tabName = "boxplot", icon = icon("box")
             #menuSubItem(tabName = 'boxplot1', newtab = TRUE, selectInput("x", "X selct", c("a", "b", "c"), selected="a")),
             #menuSubItem('Sub-Item One', tabName = 'subItemOne', newtab = TRUE)
               #menuSubItem(tabName = "ttt", selectInput("x", "X selct", c("a", "b", "c"), selected="a"))
    )
  ),
  sidebarMenu(
    menuItem("percent_bar", icon = icon("th"), tabName = "percent_bar")
  ),
  sidebarMenu(
    menuItem("cellMarker", newtab = TRUE, icon = icon("th"), tabName = "cellMarker")
    #menuItem(selectInput("cmhSpecied", "选择物种", c('Mouse','Human'), selected="Mouse"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "boxplot",
            boxplot_par_plot
    ),
    
    tabItem(tabName = "percent_bar",
            percent_barplot
    ),
    
    tabItem(tabName = "cellMarker",
            selectInput("cmhSpecied", "选择物种", c('Mouse','Human'), selected="Mouse"),
            cellMarkerData
    )
  )
)
