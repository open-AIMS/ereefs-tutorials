########################################################################
## PLOT TIME SERIES BY YEAR OVER A GIVEN PERIOD <= 12 MONTHS          ##
## ------------------------------------------------------------------ ##
## RETURNS: ggplot object (without geoms)                             ##
## REQUIRES: ggplot, dplyr, magritter, lubridate                      ##
## ------------------------------------------------------------------ ##
## Example:                                                           ##
##    salinity_time_series_plot <-                                    ##
##      ggTS_byYear(                                                  ##
##        data = eReefs_data,                                         ##
##        date_col_name = date_time,                                  ##
##        response_col_name = daily_mean_salinity,                    ##
##        start_month = 6,                                            ##
##        end_month = 5                                               ##
##      ) +                                                           ##
##      geom_line() +                                                 ##
##      labs(y = "Daily mean salinity", x = "Date", colour = "Year")  ##
##                                                                    ##
## Warning: not designed for plot periods > 12 months                 ##
##                                                                    ##
## Function concept: fake year(s) is used to put data for all years   ##
##                   on same x-axis, where as plot period denotes     ##
##                   real year(s)pertaining to the data dates         ##
##                                                                    ##
## Note: x-axis major breaks are months, if a different period is     ##
##       required, use the ggplot2::scale_x_datetime() function       ##
##                                                                    ##
########################################################################
ggTS_byYear <- function(
    data, # dataframe with POSIX dates and continuous response
    date_col_name, # the name of the dataframe column with the date variable to plot
    response_col_name, # the name of the dataframe column with the response variable to plot
    start_month = 1, # lower time series limit (default January)
    end_month = 12, # upper time series limit (default December)
    minor_breaks_period = "1 day" # the period for the graph's x-axis minor breaks (e.g. 1 week, 1 day)
) {
  # SETUP
  require(ggplot2)  # for plotting
  require(magrittr) # source of the pipe (%>%) function
  require(dplyr)    # data manipulation
  require(lubridate) # date handling
  fake_year <- 0001 # fake year used to have all dates over same period (grouped by real year)
  
  # APPEND VARIABLES TO DATA FOR USE IN PLOTTING
  data = data %>%  
    mutate(
      datetime = as_datetime({{date_col_name}}), # Ensure dates in POSIX format
      year = year(datetime), # Create columns for real year and
      month = month(datetime) # real month
    )
  
  # THE CASE WHEN THE PLOT PERIOD IS WITHNIN A SINGLE CALENDER YEAR (e.g. June 2016 - Nov 2016)
  if (start_month <= end_month) {
    # Get x-axis breaks and labels:
    plot_months = c(start_month:(end_month+1)) # vector of months to plot (including end_month)
    plot_breaks = make_datetime(fake_year, plot_months) # x-axis major breaks at each month
    # Assign data to plot periods and fake years and filter out data not needed:
    data <- data %>% 
      mutate(
        # Plot period is within the real year (e.g. June 2016 - October 2016) 
        plot_period_label = paste(year), # data for all months pertain to respective year
        dummy_date = update(datetime, year = fake_year) # all data plotted over fake year (e.g. 0001)
      ) %>% 
      filter(month >= start_month & month <= end_month)
  }
  
  # THE CASE WHEN THE PLOT PERIOD IS SPREAD ACROSS TWO CALENDER YEARS (e.g. Nov 2016 - June 2017)
  if (start_month > end_month) {
    # Get x-axis breaks and labels
    plot_months_y1 = c(start_month:12) # a vector of months to plot in the former year
    plot_months_y2 = c(1:(end_month+1)) # a vector of months to plot in the latter year
    plot_months = c(plot_months_y1, plot_months_y2)
    plot_breaks <- c(
      make_datetime(fake_year, plot_months_y1),
      make_datetime(fake_year+1, plot_months_y2)
    ) 
    # Assign data to plot periods (i.e. based on real dates), create the fake date 
    # (using fake_year and fake_year +1), and filter out data not needed:
    data <- data %>% 
      mutate(
        # Plot period crosses two calender years, therefore
        # data for months prior to start_month pertain to preceding plot period
        plot_period_start = ifelse(month >= start_month, year, year-1), 
        plot_period_end = plot_period_start+1,
        plot_period_label = paste(plot_period_start, substr(plot_period_end, 3, 4), sep = '-'), 
        # Dummy dates: months after start_month plotted in fake year (e.g. 0001), months prior plotted in 0002
        dummy_year = ifelse(month >= start_month, fake_year, fake_year + 1), 
        dummy_date = update(datetime, year = dummy_year)
      ) %>% 
      filter(month >= start_month | month <= end_month)
  }
  
  # CREATE X-AXIS (DATES) BREAK LABELS 
  # If end_month is 12 (December), plot_months ends at 13 (January of next year)
  plot_months <- replace(plot_months, plot_months==13, 1) # Change 13 to 1
  break_labels <- month.abb[plot_months]

  # CREATE PLOT
  ts_plot <- data %>% 
    ggplot(aes(x = dummy_date, y = {{response_col_name}}, group = plot_period_label, colour = plot_period_label)) + 
    labs(x = "Date", y = "Response",  colour = "Year") + 
    theme_bw(base_size = 14) + 
    scale_x_datetime(breaks = plot_breaks, labels = break_labels, date_minor_breaks = minor_breaks_period)

  return(ts_plot)
}