library(shiny)
library(DT)

fluidPage(

    fluidRow(
        column(2),
        column(8,
            h1("QR code to TEXT"),
            hr(),
            radioButtons("qrtype", h4("Turul songono uu:"), c("Oroh" = "in", "Garah" = "out"), inline = T),
        ),
        column(2),
    ),
    
    fluidRow(
        column(2),
        column(8,
            fileInput("upload", NULL, buttonLabel = "Upload...", multiple = TRUE, width = "100%"),
            dataTableOutput("files"),
            hr(),
            fluidRow(
                column(4,
                    downloadButton('sgc', 'SGC', class = 'btn-block'),
                ),
                column(4,
                    downloadButton('kbtl', 'KBTL', class = 'btn-block'),
                ),
                column(4,
                    downloadButton('terra', 'TERRA', class = 'btn-block'),
                ),
            )
        ),
        column(2),
    ),
)