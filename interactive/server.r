# team members: edgar xi [esx], eric wang [ewang1], taylor vigliot [tvigliot], jai ghose (jghose)
# url: https://edgar-eric-taylor-315.shinyapps.io/interactive/
library(shiny)
library(ggplot2)
# library(RCurl)
library(dplyr)
# library(magrittr)
library(plotly)
library(ggmap)
library(plyr)
# library(radarchart)

function(input, output) {
    df = read.csv("undergrad.csv")
    df$adm_rate = as.numeric(as.character(df$adm_rate))
    df$STEM <- df$eng_deg + df$engtech_deg + df$math_deg + df$sci_deg
    df$repay_rate <- as.numeric(as.character(df$repay_rate))
    df$default_rate <- as.numeric(as.character(df$default_rate))

    filtered_scatter = reactive({
      scatter = subset(df, adm_rate >= input$adm_rate[1] & adm_rate <= input$adm_rate[2])
        #df %>% filter(., adm_rate <= input$acc_adjust)
      return (scatter)
      })

    filtered_scatter_2 = reactive({
      scatter = subset(df, adm_rate >= input$adm_rate_2[1] & adm_rate <= input$adm_rate_2[2])
        #df %>% filter(., adm_rate <= input$acc_adjust)
      return (scatter)
      })


    school_type = reactive({
    if (input$school_type == 'All') { #Filter based on selected school type (All, Public, Private, Non-Profit)
      (df_sub = df)
    } else if (input$school_type == 'Public') {
      # print(df$school_type)
      (df_sub = subset(df, school_type == 'Public'))
    } else if (input$school_type == 'Private Non-Profit') {
      (df_sub = df %>%  filter(., school_type == 'PrivateNonProfit'))
    } else {
      (df_sub = df %>%  filter(., school_type == 'PrivateForProfit'))
    }
    # filter by acceptance rate as well
    df_sub_acc <- subset(df_sub, adm_rate >= input$adm_rate2[1] & adm_rate <= input$adm_rate2[2] )
    return (df_sub_acc)
    })


    output$earnings_plot <- renderPlotly({
      p2 <- ggplot(filtered_scatter(),
                  aes(x = md_earnings_10 , y =avg_cost, text = college ) )+
                  geom_point() +
                  labs(
                      x= "median earnings 10 years after graduation",
                      y = "average yearly cost",
                      title = "10 year earnings vs college cost, filtered by college selectivity")
      ggplotly(p2)
    })
    #
    # output$earnings_by_school <- renderPlot({
    #   ggplot(school_type(), aes(x = md_earnings_10)) + geom_density() +
    #   labs(x = "Median earnings 10 years after graduation", y= "Density", title = "Median postgraduate earnings filtered by type of school (profit, nonprofit, not-for-profit")
    #   })

    #TODO: handle missing data
    # TODO: avoid rerendering ggmap layer every time call to reactive is made
    output$plot2 <- renderPlotly({
        map_base <- get_map(location='united states', zoom=4, maptype = "terrain",
             source='google',color='color')
        plot_2 <- ggmap(map_base) +
        geom_point(aes(x = long, y = lat, size = population, color = adm_rate), data = school_type())
        # scale_color_distiller(palette = "RdPu")
        ggplotly(plot_2)
    })

    df$school_type <- factor(df$school_type)
    df$school_type <- fct_recode(df$school_type, Public = "1", PrivateNonProfit = "2", PrivateForProfit = "3")

    output$eric_plot1 <- renderPlotly({
      p3 <- ggplot(df, aes(x = avg_fam_inc, fill = school_type)) +
        geom_histogram(binwidth = 10000) + facet_grid(~factor(school_type)) +
        labs(title = "Average Family Income by School Type",x = "Average Family Income",
          y = "Number of Schools", fill = "School Type")
      ggplotly(p3)
      })

    output$eric_plot2 <- renderPlotly({
      p4 <- ggplot(df, aes(x = avg_fam_inc, y = md_earnings_10, color = school_type)) +
        geom_point(cex = 0.75) +
        labs(title = "Earnings vs. Average Family Income",
          x = "Average Family Income",
          y = "Earnings",
          color = "School Type")
      ggplotly(p4)
      })

    output$jai_plot1 <- renderPlotly({
      p5 <- ggplot(df, aes(x=STEM, y=repay_rate, color=adm_rate)) +
        geom_jitter() +
        geom_smooth(method = "loess", se = TRUE) +
        labs(x="Proportion of Students in STEM Majors",
             y="Debt Repayment Rate",
             title="Student Debt Repayment vs STEM Enrollment",
             color="Admit Rate")
      ggplotly(p5)
      })

    output$jai_plot2 <- renderPlotly({
      p6 <- ggplot(df, aes(x = md_debt, col = school_type)) +
        geom_density() +
        labs(x="Median Debt (USD)", y="Density",
             color="School Type", title="Median Student Debt Distributions by School Type")
      ggplotly(p6)
      })

    output$plot_7 <- renderPlotly({

      p7 <- ggplot(filtered_scatter_2(), aes(x = default_rate, col = school_type), alpha = 0.3) + geom_density() +
        labs (x = "default rate", y = "density", title = "default rates as a function of selectivity")
      ggplotly(p7)
      })

    output$plot_8 <- renderPlotly({
      p8 <- ggplot(df, aes(x = adm_rate, y = avg_cost)) +
        stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = 0.4) +
        geom_point(aes(text = college)) +
        labs(title = "Admissions Rate vs Average Cost", x = "Admission Rate", y = "Average Cost", color = "school type")

      ggplotly(p8)

      })

  }
