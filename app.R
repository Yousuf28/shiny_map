library(shiny)
library(shinydashboard)
library(data.table)
library(leaflet)


dt <- data.table::fread("bgeusa.csv")
dt[, popup_info:= paste(Name_batch,"<br/>", Affiliation,"<br/>",
	 Title,"<br/>",City,"<br/>", State)]

colors <- c("green","blue")
pal <- leaflet::colorFactor(colors,dt$lon)

############# UI ----  
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
	sidebarMenu(
	menuItem("filter",
	startExpanded = TRUE,
	shiny::uiOutput("title_ui")
	))),
  dashboardBody(
	leaflet::leafletOutput("map", height = 800)
  )
)

############ server ----  
server <- function(input, output, session) {
  
  dt_update <- shiny::reactive({
    dt_update <- dt
    dt_update
  })
  
  
  output$title_ui <- shiny::renderUI({
    dt <- dt_update()
    title_choices <- unique(dt$Title)
    names(title_choices) <- title_choices
    shiny::selectInput("title",label = "Select Title", 
                       choices = c(ALL = "ALL" , title_choices),
                       selected = "ALL")
  })
  
  
  output$map <- leaflet::renderLeaflet( {
    req(input$title)
    
    dt <- dt_update()
    dt <- na.omit(dt)
    print(input$title)
    
    if (input$title == "ALL") {
    
    
    leaflet()%>%addTiles()%>%addCircleMarkers(
      data = dt, lat = ~lat, lng = ~lon,
      popup = ~popup_info, color = ~pal(lon))
    } else {
      dt <- dt[Title == input$title, ]
      leaflet()%>%addTiles()%>%addCircleMarkers(
        data = dt, lat = ~lat, lng = ~lon, 
        popup = ~popup_info, color = ~pal(lon))
    }
    
    
  })
  
}

shinyApp(ui, server)