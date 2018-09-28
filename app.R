library(shiny)
library(shinythemes)

# Define UI for app ----
ui <- fluidPage(theme=shinytheme("cerulean"),
                
    # App title ----
  titlePanel("Extract and Upload Table in MySql"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      #select file extention 
      selectInput("FileFormat", "Choose File Format to be Extracted:",
                  choices = c("SELECT" ,"PDF", "DOCX")),
      actionButton("Submit","Submit"),
      
      
        # Input: Select a dataset ----
      selectInput("dataset", "Choose a dataset:",
                  choices = c("OUTPUT","Table", "Text", "Databasetable")),
      
      # Input: Specify the number of observations to view ----
      numericInput("obs", "Number of observations to view:", 10),
      
      
      # Input: actionButton() to defer the rendering of output ----
      # until the user explicitly clicks the button (rather than
      # doing it immediately when inputs change). This is useful if
      # the computations required to render output are inordinately
      # time-consuming.
      actionButton("update", "Update View"),
      
      downloadButton("downloadData", "Download"),
      
      actionButton("Clear","Clear All")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel( 
      # Output: Header + table of distribution ----
      h4("Observations"),
      tableOutput("view"),
      uiOutput("source")
    )
    
  )
)

# Define server logic to Extract Table/Text ,view and Download selected dataset ----
server <- function(input, output,session) {
    
    
    FileFormatInput <-eventReactive(input$Submit, {
            switch(input$FileFormat,
           "SELECT"= "Welcome",       
           "DOCX"=source("docxextract.R"),
           "PDF"=source("pdfextract.R"))}
  ,ignoreNULL = FALSE)
   
  
   datasetInput <- eventReactive(input$update, {
     switch(input$dataset,
            "Table"= table,
            "Text"= finaltable,
            "Databasetable"= databasetable)
                },ignoreNULL = FALSE)
   
   # Show the first "n" observations ----
  # The use of isolate() is necessary because we don't want the table
  # to update whenever input$obs changes (only when the user clicks
  # the action button)
 
  # Extract Table from Selected FileFormat
  output$source <- renderUI({
   FileFormatInput()
  })
    
  # View Table of selected dataset ----
  
  output$view <- renderTable({
    head(datasetInput(), n = isolate(input$obs))
      })
  
  # Downloadable csv of selected dataset ----
   
   output$downloadData <- downloadHandler(
      filename = function() {
        paste(input$dataset, ".csv", sep = "")
      },
      content = function(file) {
        write.csv(datasetInput(), file, row.names = FALSE)
      
  #to remove Environment     
  
     observeEvent(input$Clear,source("Remove All.R"))
      
  }
)
  
}

# Create Shiny app ----
shinyApp(ui, server)


