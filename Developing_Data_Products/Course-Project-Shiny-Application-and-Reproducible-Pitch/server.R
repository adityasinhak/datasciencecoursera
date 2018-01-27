library(shiny)

# Load data
data <- read.csv("individuals-fake-data-p1.csv", nrows = 5000, header = TRUE)
data$Gender <- as.factor(data$Gender)

# Create shiny server
shinyServer(function(input, output) {
  
  # Data filtering reaction on input parameters
  dataFilter <- reactive({
    paste0("data[data$Age > ", input$age[1], " & data$Age < ", input$age[2], 
        ifelse(input$gender != "all", paste0(" & data$Gender == '", input$gender, "'"), ""), ", c(2,5,6,7,",
        ifelse(input$email == TRUE, "15,", ""),
        ifelse(input$phone == TRUE, "19,", ""), "23) ]")
  })
  
  # Data filtering
  output$dataTable <- renderDataTable({
    eval(parse(text = dataFilter()))
  })
  
  # Data filtering as a caption
  output$caption <- renderText({
    dataFilter()
  })
  
  # Plot rendering
  output$contactsPlot <- renderPlot({
    data <- eval(parse(text = dataFilter()))
    boxplot(data$Age ~ data$Gender, data = data, xlab = "Gender", ylab = "Age", col = c("red", "blue"))
  })
  
})
