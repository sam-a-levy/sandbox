#!/usr/bin/env Rscript
library(data.table)
library(tsbox)
library(zoo)
library(OECD)
library(tidyverse)
small_UK <- get_dataset("STLABOUR", filter = list("GBR","LRHUTTTT"))

dt_l_UK <- data.table(small_UK)
tsdt_UK <- dt_l_UK[
  SUBJECT == "LRHUTTTT" & FREQUENCY == "Q",
  list(id = tolower(paste(SUBJECT,MEASURE,sep=".")),
       time = as.Date(as.yearqtr(gsub("-"," ",obsTime))),
       ukvalue = obsValue)
]

small_CH <- get_dataset("STLABOUR", filter = list("CHE","LRHUTTTT"))

dt_l_CH <- data.table(small_CH)
tsdt_CH <- dt_l_CH[
  SUBJECT == "LRHUTTTT" & FREQUENCY == "Q",
  list(id = tolower(paste(SUBJECT,MEASURE,sep=".")),
       time = as.Date(as.yearqtr(gsub("-"," ",obsTime))),
       chvalue = obsValue)
]


tsdt_all <- left_join(tsdt_CH,tsdt_UK,by=c("id","time"))
tsdt_all$ukbetter <- ifelse(tsdt_all$chvalue<tsdt_all$ukvalue,0,1)

fwrite(tsdt_all, file="unemployment_rate_ch_uk.csv")