#Stop credit card fraud: Implement the concept of a simple anti-fraud.

#For the classification of transactions into fraudulent and non fraudulent,
#I choose the classification method known as Logistic Regression wich belongs
#to the Generalized Linear Models (GLM) family. 
#I have chosen this model since the binary outcome of chargeback variable.

#Libraries#

library(tidyverse)
library(caret)
library(ROCR)


#Removing the card_number since it is a character vector and won't help in the prediction
transactional_sample_ud=transactional.sample[,-4]
str(transactional_sample_ud)

#First, i'm going to show, through some graphics, the relationship between the chargebacks variable and two potentially "good" predictors : transaction_date and transaction_amount

par(mfrow=c(2,2))
plot(has_cbk~transaction_date,data=transactional_sample_ud,xlab="transaction_date",ylab = "has_cbk")
plot(has_cbk~transaction_amount,data=transactional_sample_ud,xlab="transaction_amount",ylab = "has_cbk")
boxplot(transaction_date~has_cbk,data=transactional_sample_ud,main="Chargebacks & transaction dates",xlab="has_cbk",ylab = "transaction_date")
boxplot(transaction_amount~has_cbk,data=transactional_sample_ud,main="Chargebacks & transaction amounts",xlab="has_cbk",ylab = "transaction_amount")

#Let's take a look at the proportion of fraudulous and non fraudulous transactions
table(transactional_sample_ud$has_cbk)/3199 #12% vs 88% : very high rate of non fraudulous transactions, which could push the model to privilege classifications of inputs as non fraudulous  


#Now, I’ll randomly split the data into training set (80% for building a predictive model) and test set (20% for evaluating the model).

set.seed(123)
training.samples <- transactional_sample_ud$has_cbk %>% 
  createDataPartition(p = 0.8, list = FALSE)
train.data  <- transactional_sample_ud[training.samples, ] 
table(train.data$has_cbk)/dim(train.data)[1] #12% vs 88%, proportions kept

test.data <- transactional_sample_ud[-training.samples, ]
table(test.data$has_cbk)/dim(test.data)[1] #14% vs 86%, also kept here

print(summary(train.data))
print(summary(test.data))


#I. Fitting the model
model <- glm( has_cbk ~., data = train.data, family = binomial(logit))

# Summarize the model
summary(model)

#The last column (Pr(>|z|)) of the table coefficients, represents the p-values of the predictors
#If the p-value is under 0,05, we can say that the correspondant predictor has significant importance in the prediction of the model
#transaction_id (p-value=8.17e-06), transaction_amount (p-value< 2e-16) and with less importance than the previous ones transaction_date (p-value=0.0428) are the only three predictors that are significantly important for the predictions

#II. Diagnostic and validation of the model

#In logistic regression, we are often interested in the deviance residuals. 
#They usually take values between -2 and 2. An index plot is usually constructed 
#to detect outliers (outside the lines)

res=residuals(model)
par(mfrow=c(1,1))
plot(res,type = "p",cex=0.5,col="springgreen2",ylim = c(-3,3))
abline(h=c(-2,2),col="red")

#The majority of the values of residuals is between -2  and 2, but this criteria is not enough to validate the predictions of the model

#Other criterias to validate the model
p <- predict(model,newdata = test.data , type="response")

pr <- prediction(p, test.data$has_cbk)

prf <- performance(pr, measure = "tpr", x.measure = "fpr")

plot(prf) #ROC curve showing a good power of prediction (the more the area under the curve is high, the more the power of prediction is good)


#Finally, i'm going to compare predictions on the testing sample with the actual values of has_cbk 

probabilities <- model %>% predict(test.data, type = "response")

predicted.classes <- ifelse(probabilities > 0.5, 1, 0) #If the prediction which has a probability is higher than 0.5, the transaction is considered as fraudulous (has_cbk=1)

mean(predicted.classes == test.data$has_cbk) #Accuracy of the model : 86% , which is a very good rate


#III. Creating an Anti-fraud function that receives transaction data and returns a recommendation to “approve/deny” the transaction.


estimate=c(2.327e+04,-1.039e-03,-1.310e-06,4.016e-06,-7.118e-07,7.423e-04,-2.761e-08)

anti_fraud <- function(transaction_data) 
{
  
  logit_ypredit=estimate[1]+transaction_data[1]*estimate[2]+transaction_data[2]*estimate[3]+transaction_data[3]*estimate[4]+as.double(transaction_data[4])*estimate[5]+transaction_data[5]*estimate[6]+transaction_data[6]*estimate[7]
  
  ypredit=exp(logit_ypredit)/(1+ exp(logit_ypredit))
  
  return(ypredit)
  
}

#Trial
anti_fraud(transactional_sample_ud[5,])

