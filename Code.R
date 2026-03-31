setwd("~/Documents/project sem VI/PM")
#library
library("tidyr")
library("ggplot2")

#setting up a working directory
#setwd("C:/Users/Gargi/ACADEMICS/Projects/Sankhya Analytics-Project/Datasets")

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
dim <- (Master1)
dim

#merging Master1 and MasterLookUp
Master2 <- merge(Master1, DataMAsterLookup, by.x = "ChannelPartnerID")

#Details
head(Master2)
tail(Master2)
dim(Master2)


#dropping column "Month" and "Brand"
drop <- c("Month" , "Brand") 
datatransactions = DataTransaction[!(names(DataTransaction)%in% drop)]
head(datatransactions)

#find subset of only 2019
data_2019 <- subset(datatransactions , Year == 2019)
head(data_2019)

#aggregating 2019 sales in datatransactions
aggregate_2019 <- aggregate(Sales~ChannelPartnerID , data=data_2019 , FUN = sum)
head(aggregate_2019)
dim(aggregate_2019)

#merging Master2 and aggregate_2019
Master3 <- merge(Master2, aggregate_2019, by = "ChannelPartnerID",all.x=TRUE)
head(Master3)
tail(Master3)
dim(Master3)

#crosstable response and email
table(Master3$response, Master3$email)

#crosstable response and sms
table(Master3$response, Master3$sms)

#crosstable response and call
table(Master3$response, Master3$call)

#crosstable response and Region
table(Master3$response, Master3$Region)

#crosstable response and Loyalty
table(Master3$response, Master3$loyalty)

#crosstable response and Portal
table(Master3$response, Master3$portal)

#crosstable response and Rewards
table(Master3$response, Master3$rewards)

#boxplot for response and n_comp 
boxplot(n_comp~response,data=Master3)

#boxplot for response and nps 
boxplot(nps~response,data=Master3)

#boxplot for response and n_yrs 
boxplot(n_yrs~response,data=Master3)

#boxplot for response and Sales 
boxplot(Sales~response,data=Master3)


#?write.table
#write.table(Master3, file= "Master3.csv", row.names = F, sep=",")


#Predictive modeling
model = glm(response~email + sms + call + n_comp + loyalty + portal + rewards + nps + n_yrs + Region + Sales, data = Master3, family = "binomial")
model
s= summary(model)
s


#Test Mining
data<-readLines("74responses.txt")
head(data)

library(tm)
corp <- Corpus(VectorSource(data))

#Clean the corpus for further analysis 

#Convert to lower case and remove punctuation
corp <- tm_map(corp, tolower)
corp <- tm_map(corp, removePunctuation)

#Remove numbers
corp <- tm_map(corp, removeNumbers)

#Remove  stop words like: and, the, is, etc.
corp <- tm_map(corp,removeWords, stopwords("english"))

#Display  a particular document from corpus
writeLines(as.character(corp[[1]]))

#Inspect corpus
inspect(corp[1:3])

#Find Frequency Terms
tdm <- TermDocumentMatrix(corp)
findFreqTerms(tdm)

#Find terms with frequency of at least 10
findFreqTerms(tdm,10)

findAssocs(tdm, 'coffee', 0.30)
findAssocs(tdm, 'flavor', 0.30)
findAssocs(tdm, 'taste', 0.30)
findAssocs(tdm, 'great', 0.30)
findAssocs(tdm, 'chocolate', 0.30)
findAssocs(tdm, 'like', 0.30)

#Word cloud
library(wordcloud)
# Convert to a matrix
m <- as.matrix(tdm) 
m
# Calculate the total frequency of words
v <- sort(rowSums(m), decreasing=TRUE)
v
myNames <- names(v)
d <- data.frame(word=myNames, freq=v)
d

#Create colour palette
pal2 <- brewer.pal(8,"Dark2")

#Word cloud
wordcloud(d$word, d$freq,random.order = FALSE , min.freq=1, colors=pal2)

#Using ggplot 
term.freq <- rowSums(m)
term.freq <- subset(term.freq, term.freq >= 10)

#Transform as a dataframe
df <- data.frame(term = names(term.freq), freq = term.freq)

library(ggplot2)
ggplot(df, aes(x = term, y = freq))+ geom_bar(stat = "identity") + xlab("Terms") + ylab("Count") + coord_flip()


-------------------------------------------------------------------------------------------------------------

#DERIVED VARIABLE 6: ACTIVE CHANNEL PARTNERS
#Logic: bought during last 4 months of 2019
#steps: filter data for 2019 => create a vector for channelpartnerid => 
  head(DataTransaction)
#find subset of only 2019
data_2019 <- subset(DataTransaction , Year == 2019)
head(data_2019)
data_2019_Month <- subset(DataTransaction , Month>=10&Year==2019)
head(data_2019_Month)

channel_partners_unique<-unique(data_2019)
channel_partners_unique<-unique(data_2019_Month$ChannelPartnerID)
channel_partners_unique
                                
                                
  
td <- data.frame(DataTransaction)
td
td <- td %>% filter(Year == 2019 & Month >= 9)
td

active_CP <- function(){
  print("Channel Partners active in the last quarter of 2019 :")
  while (DataTransaction$Year = 2019) {
    #and DataTransaction$Month > 9
    #try to print the values in a vector form 
    print(DataTransaction$ChannelPartnerID)
  } 
}
active_CP
-------------------------------------------------------------------------------------------------------------
#DERIVED VARIABLE: Brand Engagement
#no of unique brands brought by each channel partners
#unique brands groupby channel partners
unique_brands_cp <- unique(DataTransaction$Brand, group_by(channel_partners_unique))




