library(googleway)
library(leaflet)
library(dplyr)
library(shiny)
library(shinyjs)
library(shinydashboard)
library(rmarkdown)
library(tinytex)

#### user interface
ui <- tags$html(
  
  
  #html head
  tags$head(
    
    tags$meta(charset="utf-8"),
    tags$meta(name="viewport", content="width-device-width, initial-scale=1, shrink-to-fit=no"),
    
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css"),
    
  ),#end head
  
  
  #BEGIN CONTENT
  
  #start body
  tags$body(
    
    #Header Navigation
    tags$nav(class = "navbar navbar-expand-lg sticky-top navbar-light bg-light",
             tags$a(class = "navbar-brand", href="#",
                    
                    tags$img(src = "images/header-logo.svg", height = "56" )
                    
             ),
             
             tags$div(class="collapse navbar-collapse justify-content-end",
                      
                      tags$ul(class="navbar-nav",
                              
                              
                              tags$div(class="btn-group",
                                       
                                       tags$button(class="btn btn-primary", href="#", "Create New Route"),
                                       
                                       tags$button(class="btn btn-light", href="#", "Trends",
                                                   
                                                   tags$img(src = "images/ic-trends.svg", height = "24", align = "left")
                                                   
                                       ),
                                       
                                       tags$button(type="button", class="btn btn-light dropdown-toggle", `data-toggle`="dropdown", `aria-haspopup`="true",`aria-expanded`="false", "Chris Ferenci",
                                                   
                                                   tags$img(class = "rounded-circle align-middle", src = "images/profile-pic.png", height = "36")
                                                   
                                       ),
                                       
                                       tags$div(class="dropdown-menu dropdown-menu-right",
                                                
                                                tags$button(class="dropdown-item", `type`="button", "Log Out" )
                                                
                                       )
                              )#end profile dropdown
                              
                              
                      )#end ul
             )#end div
             
    ),#end Nav
    
    
    tags$div(class="section-full",
             
             tags$div(class="container-fluid", id="container-full",
                      
                      tags$div(class = "row", id="full-row",
                               
                               tags$div(class = "col-4 pt-3",
                                        
                                        tags$div(id="create-route-intro",
                                                 
                                                 h3("Route Viewer and Creator"),
                                                 p("Route Creator minimizes your exposure to air pollution, maximises your time surrounded by greenery, and takes into account routes you've taken before. Select your route type to get started:"),
                                                 
                                        ),
                                        
                                        tags$form(
                                          
                                          tags$div(class="form-group", id="route-form",
                                                   
                                                   h4("Create New Route"),
                                                   
                                                   
                                                   
                                                   textInput(inputId = "startingAddress", label = "Origin", value = "Origin Location..."),
                                                   
                                                   textInput(inputId = "endingAddress", label = "Destination", "Destination..."),
                                                   
                                                   radioButtons(inputId = "exerciseType", label = "Select Route Type", choices = list("Walk" = 1, "Bike" = 2, "Run" = 3), selected = 1),
                                                   
                                                   radioButtons(inputId = "routeType", label = "Select Route Type", choices = list("One Way" = 1, "Out & Back" = 2, "Loop" = 3), selected = 1),
                                                   
                                                   tags$div(class="row",
                                                            
                                                            tags$div(class="col-8", 
                                                                     
                                                                     textInput(inputId = "dd", label = "Desired Duration/Distance", "Enter Number"),
                                                                     
                                                            ),
                                                            
                                                            tags$div(class="col-4", 
                                                                     
                                                                     selectInput(inputId = "distanceType", label="Select", choices = list("minutes" = 1, "miles" = 2, "kilometers" = 3), selected = 1),
                                                                     
                                                            ),
                                                            
                                                            
                                                            
                                                   ),
                                                   
                                                   actionButton("centerMaponAddress", "Create Route", class = "btn-primary"),
                                                   
                                                   actionLink("clearMarkers", "Clear Markers")
                                                   
                                          ),
                                          
                                        ),
                                        
                                        
                                        
                                        
                               ), #endcolumn
                               
                               tags$div(class="col-8 p-0",
                                        
                                        google_mapOutput(outputId = "map", width="100%", height = "100%")
                                        
                               )#endcolumn
                               
                      )#endRow
             ),#endContainer
             
    )#endSection-Full
    
    
  ),
  
  #tags$script(src = "https://code.jquery.com/jquery-3.2.1.slim.min.js", `integrity`="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN", `crossorigin`="anonymous"),
  tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js", `integrity`="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q", `crossorigin`="anonymous"),
  tags$script(src = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js", `integrity`="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl", `crossorigin`="anonymous"),
  
)##end body


