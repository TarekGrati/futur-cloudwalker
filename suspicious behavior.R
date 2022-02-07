#I. Analyze the data provided and present your conclusions (consider that all 
#transactions are made using a mobile device).

#Processing carried out



## Libraries ##
library(tidyr)
library(dplyr)
library(stringr)
library(tidyverse)
library(ggplot2)
library(hrbrthemes)
library(corrplot)
library(plyr)
library(readr)
library(GGally)
library(mlbench)
library(lubridate)
library(plotly)
library(stats)
library(factoextra)
library(FactoMineR)



#1- Loading and description of data
### converting transaction_date to posixct type ##
transactional.sample$transaction_date=as.POSIXct(strptime(transactional.sample$transaction_date, "%Y-%m-%dT%H:%M:%S"))
str(transactional.sample)

#First 6 lines
print(head(transactional.sample))

#descriptive statistics
print(summary(transactional.sample)) 

#Device_id has 830 NA, lets take a look on these lines
no_device_id=transactional.sample[rowSums(is.na(transactional.sample)) > 0, ]
print(summary(no_device_id)) 

#First conclusion : Only 67 transactions out of 830 had chargebacks, So  the fact that a device does not have an ID has nothing to do with chargebacks 

#replacing na in device id with 0s
transactional.sample[is.na(transactional.sample)] <- 0
print(summary(transactional.sample)) 

#Evolution of transaction amount through time with chargeback differenciation

ggplot(transactional.sample, aes(x=transaction_date, y=transaction_amount, color=has_cbk)) + 
  geom_point(size=2) +
  theme_ipsum()

#Second conclusion : 
#We can see that the more we go through time the more we have transactions.
#We can also see that the more we have transactions, the more we have chargebacks
#Finally, we can see that higher amounts are more likely to have chargebacks, so let's take a look at correlations.

#transforming has-cbk to numeric
transactional.sample <- transactional.sample %>% mutate(has_cbk = as.numeric(has_cbk))
str(transactional.sample)


#correlation between numeric variables

#only numeric database
num_transaction_df=transactional.sample[,-(4:5)]
str(num_transaction_df)
num_transaction_df=num_transaction_df[,-1]


mcor <- cor(num_transaction_df)
mcor
corrplot(mcor, type="upper", order="hclust", tl.col="black", tl.srt=45)

#Third conclusion : 
#We can see a positive correlation between transaction amount and chargebacks, wich means transactions with high amounts are more likely to have chargebacks

#2- Clustering with kmeans()

#Scaling the Data
num_transaction_df[,1:4] <- scale(num_transaction_df[,1:4],center=T,scale=T)
print(summary(num_transaction_df)) 

groupes.kmeans <- kmeans(num_transaction_df,centers=4,nstart=5)

#results
print(groupes.kmeans)

#Assessing the proportion of inertia explained
inertie.expl <- rep(0,times=10)
for (k in 2:10){
  clus <- kmeans(num_transaction_df,centers=k,nstart=5)
  inertie.expl[k] <- clus$betweenss/clus$totss
}

#graphique
plot(1:10,inertie.expl,type="b",xlab="Number of groups",ylab="% inertia explained")

#Fourth conclusion : From k = 2 classes (maybe 3),the addition of an extra group does not "significantly' increase the share of inertia explained by the partition. 
#We can make 2 clusters for our transactions, interpretation of the two clusters : fraudulous and not fraudulous

#3-Focus on lines with chargebacks
transactions_with_cbks = transactional.sample[transactional.sample$has_cbk==1,] 

#frequency of chargebacks for merchants 
merchants=table(transactions_with_cbks$merchant_id)
barplot(merchants)                                    

#Fifth conclusion : We  can see that some merchants has more chargebacks than others.
#Card associantions like Visa and Mastercards, consider merchants having more than 1% of their transactions in chargebacks are risky.
#Based on this information, we can detect many risky merchants and potentielly fraudulent 

#frequency of chargebacks for users 
users=table(transactions_with_cbks$user_id)
barplot(users)                                   

#Sixth conclusion : We  can see that some users has more chargebacks than others wich is suspicious too.

#For example, the device_id 486 had 4 chargebacks for different amounts for the same user 81152 and the same merchant 56107

#Merchant 56107
transactions_with_chargebacks=transactions_with_cbks[transactions_with_cbks$merchant_id==56107,]
all_transactions=transactional.sample[transactional.sample$merchant_id==56107,]

view(transactions_with_chargebacks)
view(all_transactions)

#For merchant 56107, we can conclude a fraudulous behaviour, since 4 out of 5 transactions resulted in chargebacks


#II. In addition to the spreadsheet data, what other data would you look at to 
#try to find patterns of possible frauds?
#Answer :
#I would look to the card’s country/city of issue and its previous payment history. I will also look for the history of chargbacks for both, merchants and users.




