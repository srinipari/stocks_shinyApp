library(shiny)
#These will load once per session. Change which we use via user input
APPL = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=AAPL&a=08&b=14&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",") #rename table.csv for any input csv file
TSLA = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=TSLA&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
YHOO = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=YHOO&a=08&b=15&c=2014&d=08&e=28&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
IBM_tick = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=IBM&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
GOOG = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=GOOG&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csvv"), header = TRUE, sep = ",")
FB = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=FB&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
LNKD = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=LNKD&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
MSFT = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=MSFT&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
CSCO = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=CSCO&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")
MU = read.csv(url("http://real-chart.finance.yahoo.com/table.csv?s=MU&a=08&b=15&c=2014&d=08&e=15&f=2015&g=d&ignore=.csv"), header = TRUE, sep = ",")


i <- 1

colu1 <- length(APPL$Close)


Apple <-c()
Tesla <-c()
Yahoo <-c()
IBM <- c()
Google <- c()
Facebook <- c()
Linkedin <- c()
Microsoft <- c()
Cisco <- c()
Micron <- c()


#value1 <- list()

for (i in 1:colu1){
  
  value1<- log(APPL$Close[i]/APPL$Close[i+1]) 
  Apple<- c(value1,Apple)
  
  value2<- log(TSLA$Close[i]/TSLA$Close[i+1]) 
  Tesla<- c(value2,Tesla)
  
  value3<- log(YHOO$Close[i]/YHOO$Close[i+1]) 
  Yahoo<- c(value3,Yahoo)
  
  value4<- log(IBM_tick$Close[i]/IBM_tick$Close[i+1]) 
  IBM<- c(value4,IBM)
  
  value5<- log(GOOG$Close[i]/GOOG$Close[i+1]) 
  Google<- c(value5,Google)
  
  value6<- log(FB$Close[i]/FB$Close[i+1]) 
  Facebook<- c(value6,Facebook)
  
  value7<- log(LNKD$Close[i]/LNKD$Close[i+1]) 
  Linkedin<- c(value7,Linkedin)
  
  value8<- log(MSFT$Close[i]/MSFT$Close[i+1]) 
  Microsoft<- c(value8,Microsoft)
  
  value9<- log(CSCO$Close[i]/CSCO$Close[i+1]) 
  Cisco<- c(value9,Cisco)
  
  value10<- log(MU$Close[i]/MU$Close[i+1]) 
  Micron<- c(value10,Micron)
  
  
}

shinyServer(function(input, output) {
  datasetInput <- reactive({
    switch(input$stocks,
           "AAPL" = Apple,
           "TSLA" = Tesla,
           "YHOO" = Yahoo,
           "IBM" = IBM,
           "GOOG" = Google,
           "FB" = Facebook,
           "LNKD" = Linkedin,
           "MSFT" = Microsoft,
           "CSCO" = Cisco,
           "MU" = Micron)
  })

  output$hist <- renderPlot({
    
    bins <- input$bins
    stock <- datasetInput()
    hist(stock,breaks = bins)

  })
  output$NormalProbPlot <- renderPlot({ 
    stock <- datasetInput()
    qqnorm(stock)
  })

  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste(input$stocks, input$filetype, sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      
      # Write to a file specified by the 'file' argument
      write.table(datasetInput(), file, sep = sep,
                  row.names = FALSE)
    }
  )
})
