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
shiny::tags
df = read.csv("undergrad.csv")

bod_1 <- fluidPage(
    theme = shinytheme("cerulean"),
    titlePanel("Where are colleges located?"),
        inputPanel(sliderInput("adm_rate2", "Filter By Rate of Admissions", # second slider
                            0, 1, value = c(0, 1), step = .05)),
        # inputPanel(sliderInput("population", "Filter by Population",
        #                     0, max(df$population, na.rm = T),
        #                      value = c(0, max(df$population, na.rm =T)), step = 100))),
    selectizeInput(inputId = "school_type", #add dropdown menu for user to select school type
                       label = "Filter By School Type",
                       choices = c('All','Public', 'Private Non-Profit', 'Private For-Profit')),
    plotlyOutput('plot2'),
    tags$br(),
    p("We notice some interesting things: The most selective colleges are typically located in the East and West coasts. \nThe most selective public colleges (UC Berkeley and UCLA) are located on the west cost,")

    tags$br(),
	titlePanel("Which colleges are most selective/expensive?"),
	plotlyOutput('plot_8'),
    tags$br(),
    p("Overall, price vs selectivity of colleges tends to be fairly homogenous towards the center,
    but we notice that the most selective colleges are outliers that all tend to be around the same,
    extremely expensive price of approximately 60k a year.")
    )



bod_2 <- fluidPage(
    titlePanel("Will I earn more from going to a Private School?"),
	plotlyOutput('eric_plot1'),
    tags$br(),
    p("Surpsingly, the median earnings 10 years after graduation is centered around 40k a year for
    both private and public schools. With for-profit schools, the answer is less clear, as there is
    much less data.
    "),

    # selectizeInput(
    #    'e1', 'Choose college', choices = df$college, multiple = FALSE
    #  ),

    titlePanel("Do graduates of more expensive schools earn more?"),
    inputPanel(sliderInput("adm_rate", "Filter By Rate of Admissions",
        0, 1, value = c(0, 1), step = .05)),

    plotlyOutput('earnings_plot', width = 'auto'),
    tags$br(),
    p("For the most selective schools,
    graduates of the most expensive schools tend to earn more.
    The highest earning graduates come from Harvard, MIT, and Stanford, but these three schools also
    rank among the most expensive, with a tuition of around 60k each.
    ")

    )

bod_3 <- fluidPage(
	titlePanel("Do colleges that receive more financial aid have better debt repayment rates?"),
	plotlyOutput('jai_plot1'),

    tags$br(),
    p("Unfortunately, the opposite is true: colleges that have a higher percentage of pell grant receivers
    tend to have lower debt repayment rates."),

	titlePanel("Do public school graduates end up with less debt?"),
	plotlyOutput('jai_plot2'),
    tags$br(),
    p("One interesting thing to note is that the debt distribution of public and private school graduates
    is unimodal, but for for-profit schools, the distribution is bimodal."))

bod_4 <- fluidPage(
	titlePanel("Do more selective colleges have lower default rates?"),
	inputPanel(
    	sliderInput("adm_rate_2", "Filter By Rate of Admissions",
            0, 1, value = c(0, 1), step = .05)),
	plotlyOutput('plot_7'),

    tags$br(),
    p("Unsurprisingly, for-profit schools have the highest default rates.
    Without adjusting for acceptance rates, public schools have higher default rates, but this trend reverses in the most selective colleges (<25% acceptance rate)."),

    titlePanel("Is your family's income related to how much you make post-graduation?"),

	plotlyOutput('eric_plot2', width = 'auto'),
    tags$br(),
    p("Your family's income is a better predictor of your postgraduate earnings than the type of school
    that you go to")
    )

ui <- dashboardPage(
  dashboardHeader(title = "Hurky White"),
  dashboardSidebar(
      sidebarMenu(
          menuItem("Introduction", tabName = "introduction"),
          menuItem("Which college should I choose?",tabName= "part1"),
          menuItem("How much will I earn?", tabName = "part2"),
          menuItem("Is college worth it?", tabName = "part3"),
          menuItem("Is college worth it? (pt 2)", tabName = "part4")
      )
  ),
  dashboardBody(
      tabItems(
          tabItem(tabName = Introduction",
            h1("Which college is right for me?"),
            box("Choosing a college is often a stressful and confusing process. In this application,
            we analyze the different factors that may contribute to selecting a college
            For example, how much money will you make, vs how much debt will you go through?
            The following dataset was taken from the US department of education
            "),

            fluidRow(
                box(title = "Data Source", status = 'info',
                    "College Scorecard Data (US department of Education)"
                    ),
                box(title = "Authors", status = 'info',
                    "Edgar Xi", br(),
                    "Taylor Vigliotti", br(),
                    "Eric Wang", br(),
                    "Jai Ghose"
                    )
            )
        ),

          tabItem(tabName = "part1",
              bod_1),
          tabItem(tabName = "part2",
              bod_2),
          tabItem(tabName = "part3",
              bod_3),
          tabItem(tabName = "part4",
              bod_4)
        )
    )
)
