library(shiny)
library(psych)
library(ggplot2)
library(boot)
library(reshape)

shinyServer(function(input, output) {
  values <- reactiveValues()
  calcX <- reactive({
    if (input$DataType == 1) { 
      values$X <- gl(n = input$ConditionsNum, k = input$n)
    }
    else{
      values$X <- rnorm(input$n, mean = input$meanX, sd = input$sdX)
    }
  })
  calcM <- reactive({
    res <- 1 - abs(input$beta1)
    error <- rnorm(input$n, mean=0, sd=res)
    mat <- model.matrix(~scale(values$X) + error)
    betaM <- c(1, input$beta1, res)    #c(B0, B1, e)
    M <- rnorm(input$n, mean=(scale(mat%*%betaM) + input$meanM), sd=input$sdM)
    values$M <- M
  })

  observe({
    calcX()
    calcM()
    values$dat <- data.frame(values$X,values$M)
    values$dat.long <- melt(values$dat)
  })
  
  
  
  #####
  
  output$describe1 <- renderTable({
    describe(values$dat)
  })
  
  output$plot <- renderPlot({
    ggplot(values$dat.long, aes(x=value)) + geom_histogram(binwidth=.5, colour="black", fill="purple") + 
      facet_grid(variable ~ .)
  })
  
  output$corrPlot <- renderPlot({
    plot(values$X, values$M)
  })
  
  output$corr <- renderText({
    cor(values$X,values$M)
  })

})