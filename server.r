library(googleway)
library(leaflet)
library(dplyr)
library(shiny)
library(shinyjs)
library(shinydashboard)
library(sf)
library(raster)



#### server
server <- function(input, output, session) {
  
  ##Google API Key  
  
  api_key <- "AIzaSyBo4AHjlO0qlcbDMX0i_WyAgxzQlAWlmDM"
  
  
  ##render Google map
  
  output$map <- renderGoogle_map({
    
    #set map to santa monica, eventually want geolocate
    latlongSM <- c(34.0195, -118.4912)
    
    google_map(key = api_key, event_return_type = "list", location = latlongSM, zoom = 15)
    
  })
  
  
  lat_long <- reactiveValues(originLocationDF = data.frame(lat = c(), long = c()))
  
  observeEvent(
    input$map_map_click, {
      
      
      #create origin lat/lon
      originLat <- input$map_map_click$lat
      originLon <- input$map_map_click$lon
      
      #print(input$map_map_click)
      
      #update startingAddress input value
      
      lat_long$originLocationDFnew <- data.frame(lat = originLat, lon = originLon)
      
      lat_long$originLocationDF <- bind_rows(lat_long$originLocationDF,
                                             lat_long$originLocationDFnew)
      
      lat_long$originLocationDFhead <- head(lat_long$originLocationDF, 2)
      
      updateTextInput(session, "startingAddress", value = paste(round(lat_long$originLocationDFhead[1, 1], 2), 
                                                                round(lat_long$originLocationDFhead[1, 2], 2), sep = ", "))
      
      if(nrow(lat_long$originLocationDF) != 1){
        updateTextInput(session, "endingAddress", value = paste(round(lat_long$originLocationDFhead[2, 1], 2), 
                                                                round(lat_long$originLocationDFhead[2, 2], 2), sep = ", "))
        
        

        }
      
      
      
      #update google map view and add markers
      if(nrow(lat_long$originLocationDF) < 2 ){
        
        google_map_update(map_id="map", data = lat_long$originLocationDFnew) %>%
          add_markers(update_map_view = FALSE)
        
      } else if (nrow(lat_long$originLocationDF) == 2 ) {
        
        
        directions <- google_directions(origin = c(lat_long$originLocationDFhead[1, 1], lat_long$originLocationDFhead[1, 2]),
                                        destination = c(lat_long$originLocationDFhead[2, 1], lat_long$originLocationDFhead[2, 2]),
                                        mode = "walking",
                                        key = api_key)
        
        pl <- direction_polyline(directions)
        
        route <- decode_pl(pl)
        
        #sf_polyline <- sf_linstring(route, x = "lat", y = "long")
        
        google_map_update(map_id="map", data = lat_long$originLocationDFnew) %>%
          add_markers(update_map_view = FALSE) %>%
          add_polylines(data = route, lat = "lat", lon = "lon")
        
      }
      
    }
    
    #google_directions()
    
    
  )
  
  #clear markers
  
  observeEvent(input$clearMarkers,{
    google_map_update(map_id="map") %>%
      clear_markers()
    
    updateTextInput(session, "startingAddress",
                    value = paste("Origin Location..."))
    
    updateTextInput(session, "endingAddress",
                    value = paste("Destination..."))
    
    session$reload() 
  }
  )
  
  output$example <- renderTable(lat_long$originLocationDFhead)
  
  
  
}