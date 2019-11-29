MouseCellMarkers <- read.csv("cellMarkerHeatmap/Mouse_cell_markers.txt", header=1, sep="\t")
MouseCellMarkers <- MouseCellMarkers[,c('tissueType', 'cancerType', 'cellType', 'cellName', 'cellMarker', 'geneSymbol', 'geneID')]
HumanCellMarkers <- read.csv("cellMarkerHeatmap/Human_cell_markers.txt", header=1, sep="\t")
HumanCellMarkers <- HumanCellMarkers[,c('tissueType', 'cancerType', 'cellType', 'cellName', 'cellMarker', 'geneSymbol', 'geneID')]


cellMarkerData <- fluidRow(
  #box(
  #  uiOutput("cMH_species"),
    #uiOutput("cancerType"),
    #uiOutput("tissueType"),
    #uiOutput("cellType"),
  #  br(),
  #  width = 3
  #),
  tabBox(
    title = "cellMarkers",
    id = "cellMarkers_tabset1", height = "250px",
    tabPanel("cellMarkers", DT::dataTableOutput("cellMarkers")),
    tabPanel("help", includeMarkdown("cellMarkerHeatmap/cellMarkerHeatmap.md")),
    width = 12
  )
)

cellMarkers <- function(cMH_species){
  selectCellMarkers <- MouseCellMarkers
  if (cMH_species == "Human"){
    selectCellMarkers <- HumanCellMarkers
  }
  selectCellMarkers <- selectCellMarkers
}

#cancerType <- 'Normal'
#cellType <- 'Normal cell'
#tissueType <- c('Blood', 'Undefined', 'Spleen', 'Lymphoid tissue', 'Aorta')
#cellName <- c('CD8+ T cell','CD8+ cytotoxic T killer cell', 'Activated CD8+ T cell')


#sdf <- df %>%
#  filter(cancerType == cancerType & tissueType %in% tissueType & cellType == cellType) %>%
#  filter(cellName %in% cellName)
  


