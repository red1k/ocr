library(shiny)
library(DT)
library(tidyverse)

function(input, output, session) {
    
    uploaded_img <- reactive({input$upload})

    output$files <- renderDataTable(
        datatable({
            req(input$upload)
            tryCatch(
                {uploaded_img()},
                error = function(e) {stop(safeError(e))}
            )
            df <- uploaded_img()
            return(df)
        }),
        options = list(pageLength = 5)
    )

}