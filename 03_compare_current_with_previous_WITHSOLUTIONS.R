library(tidyverse)
library(janitor)
library(readxl)
library(writexl)

#to run new scrape(s) from the live Biden site currently:
source("01_scrape_agencyteams.R")
source("02_scrape_nominees.R")



#### WHITE HOUSE SENIOR STAFF ##### --------------------------------------------------------

#Assignment Part 1:

#Write your code here that will compare the current white house staff names on the site to the
#archived rds file storied in the archived_data folder to determine which names are new (archive file name
#is staff_data_archived_2020_11_24t14_00.rds)

# https://buildbackbetter.gov/the-administration/white-house-senior-staff/

#You can use the filled-in version for the agency teams below to help model yours after if it's helpful,
#since the steps should be much the same.

#Your code here:

# compare senior staff names with previous archived version 

#load current data
staff_data_current <- readRDS("processed_data/staff_data_scraped.rds")
staff_data_current

# load archived data to compare against
staff_data_previous <- readRDS("archived_data/staff_data_archived_2020_11_24t14_00.rds")
staff_data_previous

#find new records of names added since previous
newnames_staff <- anti_join(staff_data_current, staff_data_previous, by = "idstring")

#see what we have
newnames_staff


### SAVE results #### 
#names of new senior staffers
saveRDS(newnames_staff, "processed_data/newnames_staff.rds")
#entire wh senior staff current file
saveRDS(staff_data_current, "processed_data/staff_data_current.rds")







########################################################################################





#### AGENCY TEAMS ##### --------------------------------------------------------


### COMPARE agency team members with previous archived version ######

#load current data
transition_data_current <- readRDS("processed_data/transition_data_scraped.rds")
transition_data_current

# load archived data to compare against
transition_data_previous <- readRDS("archived_data/transition_data_archived_2020_11_24t09_52.rds")
# transition_data_previous <- readRDS("archived_data/transition_data_archived_2020_11_25t09_34.rds")
transition_data_previous

#find new records of names added since previous
newnames <- anti_join(transition_data_current, transition_data_previous, by = "idstring")

#see what we have
newnames


### Compare TOTALS by department #######

temp1 <- transition_data_current %>% 
  mutate(status = "current")

temp2 <- transition_data_previous %>% 
  mutate(status = "previous")

#combine
agencycount_combined <- bind_rows(temp1, temp2) %>% 
  select(status, everything())

#do the counts
agencycount_compare <- agencycount_combined %>% 
  count(agency, status)

#transform to wide and add change columns
agencycount_compare <- agencycount_compare %>% 
  pivot_wider(names_from = status, values_from = n) %>% 
  mutate(
    change = current - previous
  )

agencycount_compare


#we'll create a NEW NAMED OBJECT to use from here on out for the full dataset
agencyteams <- transition_data_current


### SAVE results #### 

#names of new agency review team members
saveRDS(newnames, "processed_data/newnames.rds")
#aggregate county of agency totals compared
saveRDS(agencycount_compare, "processed_data/agencycount_compare.rds")
#entire combined agency teams file
saveRDS(agencyteams, "processed_data/agencyteams.rds")

