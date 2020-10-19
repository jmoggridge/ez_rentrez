library(rentrez)
library(seqinr)
library(Biostrings)
library(tidyverse)

## NCBI ----

# ncbi api key
apikey <- 'b15a151c3a183199be1617b6de4f030ade08' 


#' @title get_ncbi_ids
#'
#' @param searchexp the search expression string with booleans, etc.
#'
#' @return the search results for the given expression with all available ids, and a webhistory token for entrez_summary or entrez_fetch
get_ncbi_ids <- function(searchexp){
  
  # find out how many ids available from 1st search
  Esearch <- entrez_search(db = "nuccore", term = searchexp, retmax = 100)
  # use 'count' from first search to get all ids; get webenv with
  Esearch2 <- entrez_search(db = "nuccore", 
                            term = searchexp, retmax = Esearch$count,
                            use_history = TRUE)
  message('Returning ids from Entrez nuccore search:')
  print(Esearch2)
  return(Esearch2)
}


#' get_Esmmaries
#'
#' A wrapper around entrez_summary to get large volumes of summary records for a given search expression in 500 records/query steps.
#' 
#' @param web_history a web history token returned by entrez_search
#' @param id.count the total number of available records from entrez_search
#' @param apikey an apikey is necessary to do multiple downloads/second
#'
#' @return a list of summary records. Same as output from entrez_summary but with multiple queries' results concatenated into a larger list
#' 
#' @examples Esummary_list <- get_Esummaries(webhist, id.count, apikey)
#' 
get_Esummaries <- function(web_history, id.count, apikey) {
  # init list to gather downloads
  Esummary_list <- list()
  # iterate until all summary records obtained
  for (i in seq(1, id.count, 500)) {
    # display downloads progress
    print(paste0(round(i/id.count*100), '%'))
    # add each query to growing Esummary list
    Esummary_list <-  c(
      Esummary_list,
      entrez_summary(db = "nuccore", web_history = web_history,
                     retstart = i-1, retmax=500, api_key = apikey,
                     always_return_list = TRUE, retmode = 'json')
    )
    Sys.sleep(0.11)
  }
  return(Esummary_list)
}

#' get_ESummary_df
#'
#' A wrapper for entrez_search and entrez_summary that takes your search expression, gets all the summaries, then takes the list of sumaries and makes it a tidy tibble.
#' @param searchexp the search expression for ncbi
#' @param apikey your apikey from ncbi
#'
#' @return a tibble of all summary records available for given search expression
#'
#' @examples
#' searchexp <- '18S AND apicomplexa[ORGN] AND 0:10000[SLEN]) NOT (genome[TITL])'
#' summary.df <- get_ESummary_df(searchexp, apikey)

get_ESummary_df <- function(searchexp, apikey){
  basic_search <- get_ncbi_ids(searchexp)
  webhist <- basic_search$web_history
  id.count <- basic_search$count
  df <- tibble(id = basic_search$ids)
  print(glimpse(df))
  message('Getting summaries....')
  Esummary_list <- get_Esummaries(webhist, id.count, apikey)
  message('done downloads....\nflattening lists....')
  df <- df %>%
    mutate(listcol = Esummary_list) %>%
    unnest_wider(listcol)
  return(df)
  }

searchexp <- '18S AND apicomplexa[ORGN] AND 0:10000[SLEN]) NOT (genome[TITL])'
summary.df <- get_ESummary_df(searchexp, apikey)
