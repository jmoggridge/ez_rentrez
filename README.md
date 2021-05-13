# *ez_rentrez*

Simple functions for retreiving larger queries for summaries and sequences from the NCBI nucleotide database using the Rentrez package. You'll need to first [register an account with NCBI](https://www.ncbi.nlm.nih.gov/account/register/) and [request an api key](https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/#:~:text=To%20create%20the%20key%2C%20go,and%20copy%20the%20resulting%20key.) to allow rapid downloads; this solves the issue of API requests being sent too quickly for unregistered users (NCBI limits the rate of requests from unregistered users). The dependancies of this code are `tidyverse`, `rentrez`, and `Biostrings`

#### Read the functions from the script into your environment

Assuming the script is saved in your current working directory

`source('./ez_rentrez.R')`

#### Set your api-key:  

You'll need to put your own key here

`apikey <- 'never1gonna2give3you4up' `

#### Set your search expression

Use the ncbi browser online to refine your search; there is a window that shows you the search string that you can paste for `searchexp` below.  

**Don't put any of the following terms to your search expression**: retstart, retmax, retmode  

`searchexp <- '18S AND apicomplexa[ORGN] AND 0:10000[SLEN] NOT (genome[TITL])'`

#### Get search metadata 

`apicomplexa.search <- get_ncbi_ids(searchexp)`

#### Download all summaries, get a dataframe of summary records (sequence-associated data)

`apicomplexa.summary.df <- get_ESummary_df(searchexp, apikey)`

#### Download all fastas, get a dataframe of sequence records (title, sequence)

`apicomplexa.fasta.df <- get_Efasta(searchexp, apikey)`
