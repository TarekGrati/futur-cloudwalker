
library(usethis)
use_github(protocol = 'https',auth_token = Sys.getenv("GITHUB_PAT"))
#3.1 - Understand the Industry
#1.	Explain the money flow and the information flow in the acquirer market and the role of the main players.
#Answer : 
#-	Money Flow : In the acquirer market, the money flow is composed of the gross sales of the merchants, reversals, interchange fees and acquirer fees.

#-	Information flow : It represents all the informations needed for the verification of the transaction, applying anti-fraud measures against the transaction, and also to supply authorizations, settlement services to the merchants. This informations are composed of all the details related to the credit card including the card’s country of issue and its previous payment history, informations related to the merchant, the cardholder, the device being sold, the date and time of the transaction and its amount, the card’s number and security number.

#-	The main players of the acquirer market and their roles : Every use of a credit card activates an entire network of companies, technologies, and commerce that transfers money between consumer and merchant. At the center of this network is the acquirer, an entity that reconciles the payment between the merchant selling the goods, the customer’s card network (Visa, Mastercard …), and the bank that issues the credit card. Merchants accepting credit card payments pay a fee for each transaction that gets divided up among the acquirer, the card network, and the bank.

#2.	Explain the difference between acquirer, sub-acquirer and payment gateway and how the flow explained in question 1 changes for these players.
#Answer :
#-	Payment gateway : It is a system that transmits data from purchases made in a store at checkout to companies specialized in payments technology. As the first player in the flow, it's responsible for sending this information to acquirers, card brands and issuing banks then obtain a response about the continuation of the process or its cancellation. In other words, the gateway sends data and receives responses so that the store knows whether or not a particular purchase should be confirmed, showing whether the payment was approved or not. As an intermediary between an e-commerce and its payment method used, the gateway acts as a terminal, integrating in all the transactions carried out between the players of the payment flow in a single place. By activating the connectors and registering gateway affiliations, the client's shopping data can be sent to acquirers or other gateways and thus move on through the approval flow in financial institutions.

#-	Acquirer : An acquirer is a company that specializes in processing payments, meaning that it processes credit or debit card payments on behalf of a merchant. Through its network of accredited partners (or acquiring network), it enables a store to offer various payment conditions to its customers. The acquirer receives the payment information, processes it and passes it to the card brand (when the payment method is credit card) and the issuing bank. For a store to be able to receive payments, it must enable its communication with an acquirer. This is done through a gateway, which must be configured to process the payment conditions. With that, purchases can follow the approval flow. 
#When everything is in order and a purchase is authorized by the other players within the purchase flow, the acquirer is responsible for transferring the values (which the issuing bank receives from the customer) to the account of the store.

#-	Sub-acquirer : It is a company that processes payments and transmits the generated data to the other players involved in the payment flow. Its role is similar to that of an acquirer, but it doesn't completely replace it due to the lack of autonomy to perform all the funcilnatilies of an acquirer. A sub-acquirer can therefore be understood as a kind of intermediary player between acquirer and store. The main advantages of a sub-acquirer are its low implementation cost, own anti-fraud system and ease of integration which makes this a very attractive solution for small stores. On the other hand, the choice of using the sub-acquirer may jeopardize the retailer's profits because of the high rates charged for each transaction (greater than the acquirers). Another negative factor for retailers is the redirection of the customer to the sub-acquirer's own page during the final steps of the checkout, which can lead to higher withdrawal rates.

#3.	Explain what chargebacks are, how they differ from cancellations and what is their connection with fraud in the acquiring world.
#Answer :
#-	Chargebacks : A chargeback is a reversal of a credit card payment that comes directly from the bank. This happens after a cardholder contacts his bank to dispute a transaction, claiming that it resulted from fraud or abuse. The funds are pulled from the merchant's account, and returned to the cardholder's account as part of the chargeback process. 
#For a merchant, chargebacks can be a frustrating threat to his livelihood. 
#For a consumer, chargebacks represent a shield between him and dishonest merchants. 

#-	Cancellations vs Chargebacks : While chargebacks involve the customer, the merchant, the acquirer and the issuer bank, a cancellation process involves only the merchant and the customer. However, a cancellation could result into a chargeback if asked by the customer. 

#-	Connection with fraud in the acquiring world : Two types of chargebacks are considered as a fraud : 

#•	Criminal fraud : Criminal fraud chargebacks occur when a scammer or identity thief makes an unauthorized transaction on a credit card. Merchants can reduce these chargebacks by implementing powerful antifraud systems that utilize either a pre-authorization, post-authorization, or combined strategy.
#•	Friendly fraud : Friendly fraud chargebacks refer to customers who abuse the chargebacks procedure by reporting valid transactions as being fraudulent to get a refund. Customers can behave this way on purpose, or they might do it by mistake or out of confusion. 

