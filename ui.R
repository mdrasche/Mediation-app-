library(shiny)


shinyUI(fluidPage(
  titlePanel("Mediation"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", label = h5("Sample Size"),
                  min = 3, max = 1000, value = 10),
      h3("Predictor X"),
      radioButtons("DataType", label=h5("What is the Data type?"), choices=list("Categorical"=1, "Continuous"=2), selected=2),
      conditionalPanel(
        condition = "input.DataType == 1",
        selectInput("ConditionsNum", label = h5("How Many Condtions?"), 
                    choices = list("2" = 2, "3" = 3, "4"=4), selected = 2)),
      conditionalPanel(
        condition = "input.DataType == 2",
        p(sliderInput("meanX", label = h5("Mean of Population"),
                      min = 0, max = 100, value = 10),
          sliderInput("sdX", label = h5("Standard Deviation of Measure"),
                      min = 0, max = 10, value = 1, step=.1))),
      sliderInput("beta1", label = h5("Strength of Relation with M"),
                  min = -1, max = 1, value = .5, step=.01),
      sliderInput("beta2", label = h5("Strength of Relation with Y"),
                  min = -1, max = 1, value = .5, step=.01),
      h3("Mediator M"),
      sliderInput("meanM", label = h5("Mean of Population"),
                  min = 0, max = 100, value = 10),
      sliderInput("sdM", label = h5("Standard Deviation of Population"),
                  min = 0, max = 10, value = 1, step=.1),
      sliderInput("beta3", label = h5("Strength of Relation with Y"),
                  min = -1, max = 1, value = .5, step=.1),
      h3("Outcome Y"),
      sliderInput("mean3", label = h5("Mean of Population"),
                  min = 0, max = 100, value = 10),
      sliderInput("sd2", label = h5("Standard Deviation of Population"),
                  min = 0, max = 10, value = 1, step=.1)
      ),
    mainPanel(
      tabsetPanel(
        tabPanel("Descriptive Statistics",
                 tableOutput("describe1"),
                 plotOutput("plot")),
        tabPanel("Correlation between X and M", 
                 textOutput("corr"),
                 plotOutput("corrPlot")),
         tabPanel("Correlation between Y and X2",
                 code("cor.test(",strong("YOUR_DATA"),"$", strong("YOUR_Outcome"),",", strong("YOUR_DATA"),"$", strong("YOUR_IV"),")"),
                 tableOutput("corTest2"), 
                 code("ggplot(",strong("YOUR_DATA"),", aes(x=",strong("YOUR_Predictor2"),", y=",strong("YOUR_Outcome"),")) + geom_smooth(method = 'lm') + geom_point()"),
                 plotOutput("corPlot2")),
        tabPanel("Regression",
                 code("summary(lm(",strong("YOUR_Outcome") ,"~", strong("YOUR_Predictor1") ,"+", strong("YOUR_Predictor2"),", data=",strong("YOUR_DATA"),"))"),
                 tableOutput("model3"),
                 code(strong("YOUR_DATA"),"$predicted <- fitted(lm(",strong("YOUR_Outcome") ,"~", strong("YOUR_Predictor1") ,"+", strong("YOUR_Predictor2"),", data=",strong("YOUR_DATA"),"))"),
                 code("ggplot(",strong("YOUR_DATA"),", aes(x=predicted, y=",strong("YOUR_Outcome"),")) + geom_smooth(method = 'lm') + geom_point()"),
                 plotOutput("plot2"))
      )
    )
  ))
)