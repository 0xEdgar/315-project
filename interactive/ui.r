# team members: edgar xi [esx], eric wang [ewang1], taylor vigliot [tvigliot], jai ghose (jghose)
# url: https://edgar-eric-taylor-315.shinyapps.io/interactive/
library(shiny)
library(ggplot2)
library(shinydashboard)
library(shinythemes)
# library(dashboardthemes)
library(tidyverse)
library(plotly)
shinythemes::themeSelector()

# df = read.csv("undergrad.csv")
fluidPage(
    theme = shinytheme("simplex"),
	titlePanel("Edgar's Plot #1"),
	inputPanel(
	       sliderInput("adm_rate", "Filter By Rate of Admissions", #add slider input for user to filter by admission rate
	                                    0, 1, value = c(0, 1), step = .05)
	    ),
	plotlyOutput('earnings_plot'),



	titlePanel("Edgar's Plot #2"),
    inputPanel(
	       sliderInput("adm_rate2", "Filter By Rate of Admissions", # second slider
	                                    0, 1, value = c(0, 1), step = .05)
	    ),
	selectizeInput(inputId = "school_type", #add dropdown menu for user to select school type
                                       label = "Filter By School Type",
                                       choices = c('All','Public', 'Private Non-Profit', 'Private For-Profit')),
	plotlyOutput('plot2'),

	titlePanel("Eric's plot #1"),
	plotlyOutput('eric_plot1'),

	titlePanel("Eric's plot 2"),
	plotlyOutput('eric_plot2'),

	titlePanel("Jai's plot1"),
	plotlyOutput('jai_plot1'),

	titlePanel("Jai's plot2"),
	plotlyOutput('jai_plot2'),

	titlePanel("Taylor's plot 1"),
	inputPanel(
	sliderInput("adm_rate_2", "Filter By Rate of Admissions",
        0, 1, value = c(0, 1), step = .05)),
	plotlyOutput('plot_7'),

	titlePanel("Taylor's plot 2"),
	plotlyOutput('plot_8')

)
