# ez_rentrez
Convenience functions for performing large queries using the Rentrez package 

### read the functions from the script
source('./ez_rentrez.R')

### Set your parameters:  

ncbi api key, you'll need to put your own key  
`apikey <- 'never1gonna2give3you4up' `

### set your search expression

Use the ncbi browser online to refine your search; there is a window that shows you the search string that you can paste for `searchexp` below.  
**Don't any of the following terms to your search expression**: retstart, retmax, retmode  

`searchexp <- '18S AND apicomplexa[ORGN] AND 0:10000[SLEN] NOT (genome[TITL])'`

### Get search metadata 

`apicomplexa.search <- get_ncbi_ids(searchexp)`

### download all summaries, get a df
`apicomplexa.summary.df <- get_ESummary_df(searchexp, apikey)`

### download all fastas, get a df
`apicomplexa.fasta.df <- get_Efasta(searchexp, apikey)`
