library(mlbench)
library(caret)

setwd("C:/Users/TheUnlikelyMonk/Desktop/Analytics Vidhya/LTFS")
traindata <- read.csv("newtraindata.csv",header=T)
str(traindata)
traindata <- traindata[,-1]
testdata <- read.csv("newtest.csv",header = T)
str(testdata)
testdata <- testdata[,-1]


originaltest <- read.csv("test.csv",header = T)
str(originaltest)


sam <- sample(1:nrow(traindata),0.8*nrow(traindata),replace = F)
sam

valid <- traindata[-sam,]
train <- traindata[sam,]


ControlParameters <- trainControl(method = "cv",
                                  number = 4,
                                  savePredictions = T,
                                  classProbs = T
                                 )

parametersGrid <- expand.grid(eta = 0.01,
                              colsample_bytree = c(0.5,0.7),
                              max_depth = c(3,6),
                              nrounds = 500,
                              gamma = 0.5,
                              min_child_weight = 2,
                              subsample = c(0.5, 0.75, 1)
)

modelxgboost <- train(loan_default~.,
                      data = train,
                      method = 'xgbTree',
                      trControl = ControlParameters,
                      tuneGrid = parametersGrid
)


modelxgboost


pred <- predict(modelxgboost,valid)
pred
valid$pred <- ifelse(pred >= 0.5,1,0)

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
