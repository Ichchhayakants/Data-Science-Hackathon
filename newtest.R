setwd("C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS")
data <- read.csv("test.csv", header = T, stringsAsFactors = T)

str(data)
colnames(data)
data$Date.of.Birth <- as.numeric(data$Date.of.Birth)
data$Employment.Type <- as.numeric(data$Employment.Type)
data$DisbursalDate <- as.numeric(data$DisbursalDate)
data$PERFORM_CNS.SCORE <- as.numeric(data$PERFORM_CNS.SCORE)
data$PERFORM_CNS.SCORE.DESCRIPTION <- as.numeric(data$PERFORM_CNS.SCORE.DESCRIPTION)
data$AVERAGE.ACCT.AGE <- as.numeric(data$AVERAGE.ACCT.AGE)
data$CREDIT.HISTORY.LENGTH <- as.numeric(data$CREDIT.HISTORY.LENGTH)

str(data)
sum(data$MobileNo_Avl_Flag)
sum(data$Aadhar_flag)
mob <- data$MobileNo_Avl_Flag




normalize<-function(x){
  (x- min(x)) /(max(x)-min(x))
}

data<-as.data.frame(lapply(data[,-14], normalize))
data[,14] <- mob

write.csv(data, file = "newtest.csv")

sum(data$Aadhar_flag)
str(data)
sum(is.na(data))
