rm(list = ls(all=T))
library(rpart)
library(ada)
library(rpart.plot)
library(neuralnet)
setwd("C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS")

traindata <- read.csv("train.csv", header = T, stringsAsFactors = T)
testdata <- read.csv("test.csv", header = T, stringsAsFactors = T)
str(traindata)
summary(traindata)
sum(is.na(traindata))
table(traindata$loan_default)


traindata$Date.of.Birth <-gsub("-","",traindata$Date.of.Birth)
traindata$Date.of.Birth <- as.numeric(traindata$Date.of.Birth)

traindata$Employment.Type <- as.numeric(traindata$Employment.Type)

traindata$DisbursalDate<- gsub("-","",traindata$DisbursalDate)
traindata$DisbursalDate <- as.numeric(traindata$DisbursalDate)

traindata$PERFORM_CNS.SCORE.DESCRIPTION <- as.numeric(traindata$PERFORM_CNS.SCORE.DESCRIPTION)

traindata$AVERAGE.ACCT.AGE <- gsub("yrs","",traindata$AVERAGE.ACCT.AGE)
traindata$AVERAGE.ACCT.AGE <-gsub("mon","",traindata$AVERAGE.ACCT.AGE)
traindata$AVERAGE.ACCT.AGE <-gsub(" ","",traindata$AVERAGE.ACCT.AGE)
traindata$AVERAGE.ACCT.AGE <- as.numeric(traindata$AVERAGE.ACCT.AGE)

traindata$CREDIT.HISTORY.LENGTH <- gsub("yrs","",traindata$CREDIT.HISTORY.LENGTH)
traindata$CREDIT.HISTORY.LENGTH <- gsub("mon","",traindata$CREDIT.HISTORY.LENGTH)
traindata$CREDIT.HISTORY.LENGTH <- gsub(" ","",traindata$CREDIT.HISTORY.LENGTH)
traindata$CREDIT.HISTORY.LENGTH <- as.numeric(traindata$CREDIT.HISTORY.LENGTH)
str(traindata)


str(testdata)
testdata$Date.of.Birth <-gsub("-","",testdata$Date.of.Birth)
testdata$Date.of.Birth <- as.numeric(testdata$Date.of.Birth)

testdata$Employment.Type <- as.numeric(testdata$Employment.Type)

testdata$DisbursalDate<- gsub("-","",testdata$DisbursalDate)
testdata$DisbursalDate <- as.numeric(testdata$DisbursalDate)

testdata$PERFORM_CNS.SCORE.DESCRIPTION <- as.numeric(testdata$PERFORM_CNS.SCORE.DESCRIPTION)

testdata$AVERAGE.ACCT.AGE <- gsub("yrs","",testdata$AVERAGE.ACCT.AGE)
testdata$AVERAGE.ACCT.AGE <-gsub("mon","",testdata$AVERAGE.ACCT.AGE)
testdata$AVERAGE.ACCT.AGE <-gsub(" ","",testdata$AVERAGE.ACCT.AGE)
testdata$AVERAGE.ACCT.AGE <- as.numeric(testdata$AVERAGE.ACCT.AGE)

testdata$CREDIT.HISTORY.LENGTH <- gsub("yrs","",testdata$CREDIT.HISTORY.LENGTH)
testdata$CREDIT.HISTORY.LENGTH <- gsub("mon","",testdata$CREDIT.HISTORY.LENGTH)
testdata$CREDIT.HISTORY.LENGTH <- gsub(" ","",testdata$CREDIT.HISTORY.LENGTH)
testdata$CREDIT.HISTORY.LENGTH <- as.numeric(testdata$CREDIT.HISTORY.LENGTH)
str(testdata)






write.csv(traindata,file="trainpros.csv")
write.csv(testdata,file = "testpros.csv")


sum(traindata$MobileNo_Avl_Flag)
nrow(traindata)
sum(testdata$MobileNo_Avl_Flag)
nrow(testdata)
colnames(traindata)
sum(is.na(traindata))
sum(is.na(testdata))

normalize<-function(x){
  (x- min(x)) /(max(x)-min(x))
}
newtraindata<-as.data.frame(lapply(traindata, normalize))
newtestdata<-as.data.frame(lapply(testdata, normalize))

newtraindata$MobileNo_Avl_Flag <- 1
newtestdata$MobileNo_Avl_Flag <- 1

write.csv(newtraindata,file = "newtraindatapros.csv")
write.csv(newtestdata, file = "newtestdatapros.csv")

sum(is.na(traindata))
sum(is.na(testdata))


str(newtraindata)
set.seed(1000)

## Model building
fitgentleadaboostm1 <- ada(loan_default~., data=newtraindata, loss="exponential",
                           type="gentle",control=rpart.control(), nu=0.01)


fitgentleadaboostm1

plot(fitgentleadaboostm1)
plot(fitgentleadaboostm1, test=T)
summary(fitgentleadaboostm1)
summary(fitgentleadaboostm1, n.iter = 50)
summary(fitgentleadaboostm1, n.iter = 20)
varplot(fitgentleadaboostm1)

## Assesment of the model

pred <- predict(fitgentleadaboostm1, newtestdata, type="both")
pred
table(pred$class)  


#-----------------------------------**********------------------------------------#

fitgentleadaboostm2 <- ada(loan_default~., data=newtraindata,loss="exponential",
                        type="gentle",control=rpart.control(), iter=100, nu=0.01)
fitgentleadaboostm2
plot(fitgentleadaboostm2, test=T)
summary(fitgentleadaboostm2)
summary(fitgentleadaboostm2, n.iter = 50)
summary(fitgentleadaboostm2, n.iter = 20)
varplot(fitgentleadaboostm2)
scores <- varplot(fitgentleadaboostm2, type = "scores")
scores


## Assesment of the model

pred <- predict(fitgentleadaboostm2, newtestdata, type="both")
pred
table(pred$class)  



#####**********************************************************************######


### Neural Net model
str(newtraindata)
allVars<- colnames(newtraindata)
predictorVars <- allVars[!allVars%in%"loan_default"]
predictorVars[[1]]
predictorVars <- paste(predictorVars,collapse = "+")

form= as.formula(paste("loan_default~",predictorVars,collapse = "+"))

str(newtraindata)

sum(is.na(newtraindata))
is.na(newtraindata)
nn <- neuralnet(formula = form,
               data=newtraindata,
               hidden = c(10,5),
               err.fct = "ce",
               linear.output = F)


plot(nn)

output <- compute(nn,newtrainingdata[,-40])
output
head(output$net.result)
head(trainingdata[1,])



## Confusion matrix for testining data
output <- compute(nn,newtestingdata)
p2<- output$net.result
pred2 <- ifelse(p2>0.5,1,0)
pred2
write.csv(newtestdata,file = "newtraindata.csv")
write.csv(newtestdata, file = "newtesrdata.csv")





#######***************************************#############################


### Random forest

library(randomForest)
rf <- randomForest(loan_default~.,data = newtraindata,
                   do.trace=T,
                   ntree=10,
                   importance = T)

print(rf)
attributes(rf)
rf$confusion

plot(rf)

library(caret)
pred<- predict(rf, newtraindata)
head(pred)
head(newtraindata$loan_default)
predi <- ifelse(pred>=0.5,1,0)
tab <- table(predi, traindata$loan_default)
error = 1- sum(diag(tab))/sum(tab)
error*100


confusionMatrix(predi,newtraindata$loan_default)
p1 <- predict(rf,newtestdata)
p1
str(traindata)
str(testdata)


t<-tunerf(newtraindata[,-40], newtestdata,
          stepFactor = 0.5,
          plot=T,
          ntreeTry =300,
          trace =T,
          improve= 0.05)


## improved tree
rf <- randomForest(loan_default~.,data = newtraindata,
                   ntree=300,
                   mtry = 8,
                   importance = T,
                   proximity =T)
print(rf)

hist(treesize(rf),
     main="No of Nodes for the trees",
     col = "green")


varImpPlot(rf,
           sort = T,
           n.var= 10,
           main= "Top 10 important Variables")
importance(rf)
varUsed(rf)


partialplot(rf,newtraindata,feature,"class(1/2")


## Extract info about single tree

getTree(rf, 1, labelvar =T)


## Multi dimensional scaling plot of proximity matrix
MDSplot(rf, newtraindata$loan_default)




####################################_____________________________##################

## XG Boosting
library(mlbench)
library(caret)

ControlParameters <- trainControl(method = "cv",
                                  number = 4,
                                  savePredictions = T,
                                  classProbs = T
)

parametersGrid <- expand.grid(eta = 0.001,
                              colsample_bytree = c(0.5,0.7),
                              max_depth = c(3,6),
                              nrounds = 500,
                              gamma = 0.1,
                              min_child_weight = 2,
                              subsample = c(0.5, 0.75, 1)
)

modelxgboost <- train(loan_default~.,
                      data = newtraindata,
                      method = 'xgbTree',
                      trControl = ControlParameters,
                      tuneGrid = parametersGrid
)


modelxgboost


pred <- predict(modelxgboost,newtraindata)
pred
pred
sum(pred)
pred <- ifelse(pred >= 0.5,1,0)
tab <- table(pred,newtraindata$loan_default)
tab

pred <- predict(modelxgboost, newtestdata)
pred <- ifelse(pred >=0.5,1,0)
pred
sum(pred)


t <- table(valid$pred, valid$loan_default)
t

(1-sum(diag(t))/sum(t))*100


pred1 <- predict(modelxgboost, testdata)

pred1

testdata$pred <- ifelse(pred1 >=0.5,1,0) 

t <- testdata
str(t)

t <- as.data.frame(cbind(originaltest$UniqueID,testdata$pred))
str(t)

colnames(t) <- c("UniqueID","loan_default")
str(t)

write.csv(t, file = "xgbtune.csv")
