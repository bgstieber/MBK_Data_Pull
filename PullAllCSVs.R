library(rvest)
library(stringr)
library(RCurl)
library(data.table)

page <- read_html("http://www2.ed.gov/rschstat/statistics/surveys/mbk/index.html")

page %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
  str_subset("\\.csv") %>%
  paste0('www2.ed.gov', .) -> all.files

#fix file names

substr(all.files, nchar(all.files) - 3, nchar(all.files)) <- '.csv'

file.names <- substr(all.files, 45, nchar(all.files) - 4)

failed_files <- character()
i <- 1

for(j in seq_along(file.names)){
  #read the url and read the data
  my.url <- getURL(all.files[j])
  
  dat <- tryCatch(fread(my.url),
                  error = function(e) paste('This failed', e))
  
  if(is.character(dat)){
    failed_files[i] <- all.files[j]
    i <- i + 1
  }else{
  
  #write the data where we want to write it
  write.csv(x = dat, 
            file = paste0("YOUR FILE NAME",
                          file.names[j], '.csv'),
            row.names = FALSE)
  }
    
}

