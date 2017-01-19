# example caret 

###### INSTALLATION ----------- 
# install.packages("caret", dependencies = c("Depends", "Suggests")) 

#### load data ----------- 

#Loading caret package
library("caret")

#Loading training data
train<-read.csv("./data/train_u6lujuX_CVtuZ9i.csv",stringsAsFactors = T)
str(train)

# we have to predict the Loan Status of a person based on his/ her profile. 

############# 2. Pre-processing using Caret-----------

# check missing values 
sum(is.na(train))

# Imputing missing values using KNN. Also centering and scaling numerical columns
preProcValues <- preProcess(train, method = c("knnImpute","center","scale"))

library('RANN')
train_processed <- predict(preProcValues, train)
sum(is.na(train_processed))

head(train_processed)

#Converting outcome variable to numeric
train_processed$Loan_Status<-ifelse(train_processed$Loan_Status=='N',0,1)

id<-train_processed$Loan_ID
train_processed$Loan_ID<-NULL # clear var 

#Checking the structure of processed train file
str(train_processed)

#Converting every categorical variable to numerical using dummy variables
dmy <- dummyVars(" ~ .", data = train_processed,fullRank = T)
train_transformed <- data.frame(predict(dmy, newdata = train_processed))
# “fullrank=T” will create only (n-1) columns for a categorical column with
# n different levels

#Checking the structure of transformed train file
str(train_transformed)

#Converting the dependent variable back to categorical
train_transformed$Loan_Status<-as.factor(train_transformed$Loan_Status)

######## 3. Splitting data using caret-----------

# We’ll be creating a cross-validation set from the training set to evaluate our model against
# Spliting training set into two parts based on outcome: 75% and 25%
index <- createDataPartition(train_transformed$Loan_Status, p=0.75, list=FALSE)
trainSet <- train_transformed[ index,]
testSet <- train_transformed[-index,]

#Checking the structure of trainSet
str(trainSet)

######## 4. Feature selection using Caret -----------
######## how to select the right variables? 

# Feature selection is an extremely crucial part
# we’ll be using Recursive Feature elimination which is a wrapper method 
# to find the best subset of features to use for modeling.

# Feature selection using rfe in caret
control <- rfeControl(functions = rfFuncs,
                      method = "repeatedcv",
                      repeats = 3,
                      verbose = FALSE)

# predictand 
outcomeName<-'Loan_Status'
# select predictors 
predictors<-names(trainSet)[!names(trainSet) %in% outcomeName]
# predict 
Loan_Pred_Profile <- rfe(trainSet[,predictors], trainSet[,outcomeName],
                         rfeControl = control)
Loan_Pred_Profile

# Taking only the top 5 predictors
predictors<-c("Credit_History", "LoanAmount", "Loan_Amount_Term", "ApplicantIncome", "CoapplicantIncome")

######## 5. Training models using Caret -----------

# caret provides the ability for implementing 200+ machine learning algorithms using consistent syntax. 
# To get a list of all the algorithms that Caret supports, you can use: 
names(getModelInfo())

# details of models: 
# http://topepo.github.io/caret/available-models.html 

# For example, to apply, GBM, Random forest, Neural net and Logistic regression :
model_gbm<-train(trainSet[,predictors],trainSet[,outcomeName],method='gbm')
model_rf<-train(trainSet[,predictors],trainSet[,outcomeName],method='rf')
model_nnet<-train(trainSet[,predictors],trainSet[,outcomeName],method='nnet')
model_glm<-train(trainSet[,predictors],trainSet[,outcomeName],method='glm')

##### 6. parameter tuning techniques.  -----------

# The resampling technique used for evaluating the performance of the model using a set of parameters in Caret by default is bootstrap
# but it provides alternatives for using k-fold, repeated k-fold as well as Leave-one-out cross validation (LOOCV) which can be specified using trainControl(). 
# In this example, we’ll be using 5-Fold cross-validation repeated 5 times.
fitControl <- trainControl(
        method = "repeatedcv",
        number = 5,
        repeats = 5)
# 6.1.Using tuneGrid
modelLookup(model='gbm')

#Creating grid
grid <- expand.grid(n.trees=c(10,20,50,100,500,1000),shrinkage=c(0.01,0.05,0.1,0.5),n.minobsinnode = c(3,5,10),interaction.depth=c(1,5,10))
grid

# for all the parameter combinations that you listed in expand.grid(), 
# a model will be created and tested using cross-validation. 
# The set of parameters with the best cross-validation performance will 
# be used to create the final model which you get at the end.

# training the model
model_gbm<-train(trainSet[,predictors],trainSet[,outcomeName],
                 method='gbm',
                 trControl=fitControl,tuneGrid=grid)

# summarizing the model
print(model_gbm)

# Accuracy was used to select the optimal model using  the largest value.
# The final values used for the model were: 
# n.trees = 10, interaction.depth = 1, shrinkage = 0.05 and n.minobsinnode = 3

plot(model_gbm)

# 6.2. Using tuneLength
# Instead, of specifying the exact values for each parameter for tuning 
# we can simply ask it to use any number of possible values for each tuning parameter through tuneLength. Let’s try an example using tuneLength=10.

#using tune length
model_gbm<-train(trainSet[,predictors],trainSet[,outcomeName],
                 method='gbm',
                 trControl=fitControl,tuneLength=10)
print(model_gbm)
plot(model_gbm)
# The final values used for the model were 
# n.trees = 100, interaction.depth = 1, shrinkage = 0.1 and n.minobsinnode = 10.

##### 7. Variable importance estimation using caret-----------
#Checking variable importance for GBM

#Variable Importance
varImp(object=model_gbm)

#Plotting Varianle importance for GBM
plot(varImp(object=model_gbm),main="GBM - Variable Importance")

#Checking variable importance for RF
varImp(object=model_rf)
plot(varImp(object=model_rf),main="RF - Variable Importance")

#Checking variable importance for NNET
varImp(object=model_nnet)
plot(varImp(object=model_nnet),main="NNET - Variable Importance")

#Checking variable importance for GLM
varImp(object=model_glm)
plot(varImp(object=model_glm),main="GLM - Variable Importance")

# Clearly, the variable importance estimates of different models differs and thus might be used to get a more holistic view of importance of each predictor. Two main uses of variable importance from various models are:
#         
# A) Predictors that are important for the majority of models represents genuinely important predictors.
# B) Foe ensembling, we should use predictions from models that have significantly different variable importance as their predictions are also expected to be different. Although, one thing that must be make sure is that all of them are sufficiently accurate.

####### 8. Making Predictions and assessing models -----------

# For predicting the dependent variable for the testing set, Caret offers predict.train(). 
# For classification problems, Caret also offers another feature named type which can be
# set to either “prob” or “raw”. For type=”raw”, the predictions will just be the outcome classes for the testing data while for type=”prob”, it will give probabilities for the occurrence of each observation in various classes of the outcome variable.

#Predictions
predictions<-predict.train(object=model_gbm,testSet[,predictors],type="raw")
table(predictions)
confusionMatrix(predictions,testSet[,outcomeName])
