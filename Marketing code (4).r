#library
library("tidyr")
library("ggplot2")
library("dplyr")
library("NPS")
library("readxl")

#setting up a working directory
setwd("C:/Users/Gargi/Bsc ASA/TYBsc/Sem VI/Marketing PROJECT/Datasets")

#Importing data
DataCampaignDetails <- read.csv("Campaign Details.csv")

DataCampaignResponse <- read.csv("Campaign Response  Data.csv")

DataMAsterLookup <- read.csv("MasterLookUp.csv")

DataTransaction <- read.csv("Transaction data.csv")

#head
head(DataMAsterLookup)
head(DataCampaignDetails)
head(DataCampaignResponse)
head(DataTransaction)

#merging Campaign Details and Campaign Response
Master1 <- merge(DataCampaignDetails, DataCampaignResponse, by.x = "ChannelPartnerID")

#Details
head(Master1)
tail(Master1)
dim(Master1)

#merging Master1 and MasterLookUp
Master2 <- merge(Master1, DataMAsterLookup, by.x = "ChannelPartnerID")

#Details
head(Master2)
tail(Master2)
dim(Master2)

#merging Master2 and DataTransaction
Master3 <- merge(Master2, DataTransaction, by.x = "ChannelPartnerID")

#Details
head(Master3)
tail(Master3)
dim(Master3)

#find subset of only 2019
datatransactions = subset(DataTransaction , Year == 2019)  
head(datatransactions)

#merging Master2 and datatransactions
Master4 <- merge(Master2, datatransactions, by.x = "ChannelPartnerID")
head(Master4)

#find subset of only 2018
datatransactions_2018 = subset(DataTransaction , Year == 2018)  
head(datatransactions_2018)

#merging Master2 and datatransactions_2018
Master5 <- merge(Master2, datatransactions_2018, by.x = "ChannelPartnerID")
head(Master5)

#DERIVED VARIABLE
#1-Sales for 2019
#dropping column "Month" and "Brand"
drop <- c("Month" , "Brand")
data_2019_D1 <- datatransactions[!(names(datatransactions)%in% drop)]
head(data_2019_D1)

#aggregating 2019 sales in datatransactions
Sales_2019 <- data_2019_D1 %>%group_by(ChannelPartnerID) %>% summarise(Sales_2019= sum(Sales))
Sales_2019<- data.frame(Sales_2019)
head(Sales_2019)
dim(Sales_2019)


#merging Master2 and aggregate_2019
MasterD1 <- merge(Master2, Sales_2019, by = "ChannelPartnerID",all.x=TRUE)
head(MasterD1)
tail(MasterD1)
dim(MasterD1)

#DERIVED VARIABLE
#2-Sales for 2018

#dropping column "Month" and "Brand"
drop <- c("Month" , "Brand")
data_2018_D2 <- datatransactions_2018[!(names(datatransactions_2018)%in% drop)]
head(data_2018_D2)

#aggregating 2018 sales in datatransactions
Sales_2018 <- data_2018_D2 %>%group_by(ChannelPartnerID) %>% summarise(Sales_2018= sum(Sales))
head(Sales_2018)
dim(Sales_2018)

#merging Master2 and Sales_2018
MasterD2 <- merge(Master2, Sales_2018, by = "ChannelPartnerID",all.x=TRUE)
head(MasterD2)
tail(MasterD2)
dim(MasterD2)

#DERIVED VARIABLE
#3-Buying Freq-2019
head(datatransactions)

#Subset of unique Months
unique_months <- datatransactions %>% group_by(ChannelPartnerID)%>% distinct(Month, .keep_all = TRUE)
head(unique_months)

#Count of the months
channel_partners_uniqueD4 <- unique_months %>% count(Month)
head(channel_partners_uniqueD4)

#Adding the count of the months by Channel Partner ID
BF_2019 <- channel_partners_uniqueD4 %>%group_by(ChannelPartnerID) %>% summarise(BF_2019= sum(n))
BF_2019 = as.data.frame(BF_2019)
head(BF_2019)


#DERIVED VARIABLE
#4-Buying Freq-2019-B1
head(datatransactions )

#subset of B1 Brand
B1_Brand <- subset(datatransactions, Brand=="B1")
head(B1_Brand)

#Subset of unique Months
unique_months2 <- B1_Brand %>% group_by(ChannelPartnerID)%>% distinct(Month, .keep_all = TRUE)
head(unique_months2)

#Count of the months
channel_partners_uniqueD4 <- unique_months2 %>% count(Month)
head(channel_partners_uniqueD4)

#Adding the count of the months by Channel Partner ID
BF_2019_B1 <- channel_partners_uniqueD4 %>%group_by(ChannelPartnerID) %>% summarise(BF_2019_B1= sum(n))
head(BF_2019_B1)


#DERIVED VARIABLE
#5-Active Channel Partners[purchased in the last quarter]
#Dropping columns "Year", "Brand", "Sales" from 2019 dataset of sales and creating a new dataset
drop <- c("Year", "Brand", "Sales")
ACP_2019 <- datatransactions[!(names(datatransactions)%in% drop)]

#Subset of SAles occuring in the last quarter of the year 2019-October, November, December
ACP_2019$active<-ifelse(ACP_2019$Month>=10,1,0)
head(ACP_2019)

#Adding up all the points
ACP_2019<-ACP_2019 %>% group_by(ChannelPartnerID) %>% summarise(Active = sum(active))
datadf2<-as.data.frame(ACP_2019)

#Creating a binary variable
ACP_2019$Active<-ifelse(ACP_2019$Active>=1,1,0)
head(ACP_2019)
tail(ACP_2019)

#DERIVED VARIABLE
#6-Active Channel Partners[purchased in the last quarter] for B1
#Dropping columns "Year", "Sales" from 2019 dataset of sales and creating a new dataset
drop <- c("Year", "Sales")
ACP_2019_B1 <- datatransactions[!(names(datatransactions)%in% drop)]

#Subset of Sales occuring in the last quarter of the year 2019-October, November, December for the Brand 'B1'
ACP_2019_B1$active<-ifelse(ACP_2019_B1$Month>=10 & ACP_2019_B1$Brand=="B1" ,1,0)

#Adding up all the points
ACP_2019_B1<-ACP_2019_B1 %>% group_by(ChannelPartnerID) %>% summarise(Active = sum(active))
ACP_2019_B1<-as.data.frame(ACP_2019_B1)

#Creating a binary variable
ACP_2019_B1$Active<-ifelse(ACP_2019_B1$Active>=1,1,0)
head(ACP_2019_B1)

#DERIVED VARIABLE
#7-NPS-2019

#creating datasets for nps scores for 2019
df_NPS <- subset(MasterD1)
head(df_NPS)
library("NPS")

#Creating a new variable with NPS variables from the NPS library in the same data
df_NPS$NPS_2019 <- npc(df_NPS$nps,breaks =list(0:6, 7:8, 9:10))
head(df_NPS)

#dropping all columns other than NPS and ChannelPartnerID
drop <- c("email" , "sms", "call", "response", "n_comp", "loyalty", "nps", "n_yrs", "Region", "Sales_2019", "portal", "rewards")
NPS_2019 <- df_NPS[!(names(df_NPS)%in% drop)]
head(NPS_2019)

#DERIVED VARIABLE
#9-NPS-2018

#creating datasets for nps scores for 2018
df_NPS_2018 <- subset(MasterD2)
head(df_NPS_2018)
NPS_2018<-npc(df_NPS$nps,breaks =list(0:6, 7:8, 9:10))
NPS_2018<-data.frame(NPS_2018)
head(NPS_2018)
df_NPS_2018$NPS_2018 <- NPS_2018
head(df_NPS_2018)

#dropping all columns other than NPS and ChannelPartnerID
drop <- c("email" , "sms", "call", "response", "n_comp", "loyalty", "nps", "n_yrs", "Region", "Sales_2018", "portal", "rewards")
NPS_2018 <- df_NPS_2018[!(names(df_NPS_2018)%in% drop)]
head(NPS_2018)

#DERIVED VARIABLE
#9-Brand Engagement_2019
head(datatransactions)

#Total no. of brands bought
Brands_D10 <- datatransactions %>% group_by(ChannelPartnerID)%>% distinct(Brand, .keep_all = TRUE)
head(Brands_D10)

#Count
Brand_D10 <- Brands_D10 %>% count(Brand)
head(Brand_D10)

#Adding up the count for each Channel Partner
BrandEngagement_2019 <- Brand_D10 %>%group_by(ChannelPartnerID) %>% summarise(BrandEngagement_2019= sum(n))
head(BrandEngagement_2019)

#DERIVED VARIABLE
#12-Buying interval

#sorting Month in ascending order by Channel Partner ID
sort_2019_Month <- datatransactions %>% group_by(ChannelPartnerID) %>% arrange(ChannelPartnerID, Month)
head(sort_2019_Month)
sort_2019_Month <- as.data.frame(sort_2019_Month)

#Finding the difference between each row of Month
sort_2019<-sort_2019_Month%>%group_by(ChannelPartnerID)%>%mutate(Difference=Month-lag(Month,default=first(Month)))
head(sort_2019)

#Saving it in a dataframe
sort_2019 <- as.data.frame(sort_2019)

#Finding the mean of the buying intervals for each Channel Partner 
sort_2019 <- sort_2019 %>% group_by(ChannelPartnerID)%>% summarise(Buying_Interval = mean(Difference))

#Saving it in a dataframe
Buying_Interval <- as.data.frame(sort_2019)
head(Buying_Interval)


#DERIVED VARIABLE
#13-B1 sales percentage

#Adding the total sales for Brand B1 in 2019
head(datatransactions)
Sales_2019_B1 <- datatransactions %>% group_by(ChannelPartnerID, Brand=='B1') %>% summarise(Sales_2019_B1= sum(Sales))

#Create a Dataframe
df <- data.frame(Sales_2019_B1)
head(df)

#Rename Column
names(df)[2] <- 'BrandB1'

#Drop rows with BrandB1=FALSE
Sales_2019_B1 <- df[!(df$BrandB1=="FALSE"),]
head(Sales_2019_B1)

#Drop the col BrandB1
drop <- c("BrandB1")
B1_Sales_2019 <- Sales_2019_B1[!(names(Sales_2019_B1)%in% drop)]
head(B1_Sales_2019)

#Merging data of total sales in 2019 and total sales of B1 in 2019
Sales_B1 <- merge(Sales_2019, B1_Sales_2019, by = "ChannelPartnerID",all.x=TRUE)
head(Sales_B1)
DV13 <- Sales_B1%>%group_by(ChannelPartnerID)%>%summarise(B1Sales_Percentage = ((Sales_2019_B1/Sales_2019)*100))
head(DV13)
DV13 <- as.data.frame(DV13)
DV13[is.na(DV13)] <- 0
head(DV13)



#Merging all variables
#DV1
MasterData <- merge(Master2, Sales_2018, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV2
MasterData <- merge(MasterData, Sales_2019, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV3
MasterData <- merge(MasterData, BF_2019, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV4
MasterData <- merge(MasterData, BF_2019_B1, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV5
MasterData <- merge(MasterData, ACP_2019, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV6
MasterData <- merge(MasterData, ACP_2019_B1, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV7
MasterData <- merge(MasterData, NPS_2019, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV8
MasterData <- merge(MasterData, NPS_2018, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV9
MasterData <- merge(MasterData, BrandEngagement_2019, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV10
MasterData <- merge(MasterData, Buying_Interval, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#DV11
MasterData <- merge(MasterData, DV13, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#########################################
#DV12
#MasterData <- merge(MasterData, Buying_Interval, by = "ChannelPartnerID",all.x=TRUE)
#head(MasterData)

#DV13
MasterData <- merge(MasterData, DV13, by = "ChannelPartnerID",all.x=TRUE)
head(MasterData)

#write.table(MasterData, file= "MasterData.csv", row.names = F, sep=",")

#we have a series of unique active channel partners. find out all the unique channel active. next, find elements which are in main channel partner id list but not in active channel list mark those as  non active.
########################################

#Converting all NA values to 0
MasterData[is.na(MasterData)] <- 0
head(MasterData)
dim(MasterData)

#write.csv(MasterData, file= "MasterData.csv", row.names = F, sep=",")
#dim(MasterData)

#ANALYSIS

#Analysis
#1-Response Rate
#Response Rate$email
head(Master3)

data_email_resp1 <- Master3 %>% filter(response== 1)
resp1 <- count(data_email_resp1)
resp1
data_email_totalresponse <- Master3 %>% filter(response >=0 & email >= 0)
resp2 <- count(data_email_totalresponse)
RR1 <- (resp1/resp2)*100


head(MasterData)
dim(MasterData)
table(MasterData$email,MasterData$response)
table(MasterData$sms,MasterData$response)
table(MasterData$call,MasterData$response)
chan_0<-MasterData%>%group_by(ChannelPartnerID)%>%filter(response==0)
chan_0
install.packages("combinat")
library(combinat)
com<-combn(chan_0) 

if(MasterData$email == 1){
  if(MasterData$sms == 1){
    if(MasterData$call == 1){
      print(MasterData$email, MasterData$sms, MasterData$call, MasterData$response)
    }
  }
}

esc1111 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 1 & call == 1 & response == 1)
esc1111
dim(esc1111)

esc1110 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 1 & call == 1 & response == 0)
esc1110
dim(esc1110)

esc1101 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 1 & call == 0 & response == 1)
esc1101
dim(esc1101)

esc1100 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 1 & call == 0 & response == 0)
esc1100
dim(esc1100)

esc1001 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 0 & call == 0 & response == 1)
esc1001
dim(esc1001)

esc1000 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 0 & call == 0 & response == 0)
esc1000
dim(esc1000)

esc1011 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 0 & call == 1 & response == 1)
esc1011
dim(esc1011)

esc1010 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 1 & sms == 0 & call == 1 & response == 0)
esc1010
dim(esc1010)

esc0111 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 1 & call == 1 & response == 1)
esc0111
dim(esc0111)

esc0110 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 1 & call == 1 & response == 0)
esc0110
dim(esc0110)

esc0101 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 1 & call == 0 & response == 1)
esc0101
dim(esc0101)

esc0100 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 1 & call == 0 & response == 0)
esc0100
dim(esc0100)

esc0011 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 0 & call == 1 & response == 1)
esc0011
dim(esc0011)

esc0010 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 0 & call == 1 & response == 0)
esc0010
dim(esc0010)

esc0001 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 0 & call == 0 & response == 1)
esc0001
dim(esc0001)

esc0000 <- MasterData %>% group_by(ChannelPartnerID) %>% filter(email == 0 & sms == 0 & call == 0 & response == 0)
esc0000
dim(esc0000)
