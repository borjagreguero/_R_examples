#
# https://www.analyticsvidhya.com/blog/2016/12/introduction-to-feature-selection-methods-with-an-example-or-how-to-select-the-right-variables/ 
#

##### HOW TO SELECT THE RIGHT VARIABLES 

# it boils down to creating variables which capture hidden business insights and then making the right choices about which variable to choose for your predictive models! 

##### 1. Importance of Feature Selection

# Machine learning works on a simple rule:
#  if you put garbage in, you will only get garbage to come out. 

# This becomes even more important when the number of features are very large. 
# You need not use every feature at your disposal for creating an algorithm. 
# You can assist your algorithm by feeding in only those features that are really important.

# top reasons to use feature selection: 
# a) train faster
# b) reduces complexity of model and makes it easier to interpret 
# c) improves accuracy 
# d) reduces overfitting 

######## 2. Filter Methods

# preprocessing step.
# selection of features is independent of any machine learning algorithms
# features are selected on the basis of their scores in various statistical tests for their correlation with the outcome variable. 
# For basic guidance, you can refer to the following table for defining correlation co-efficients.

# Pearson’s Correlation: It is used as a measure for quantifying linear dependence between two continuous variables X and Y. 
# LDA: Linear discriminant analysis is used to find a linear combination of features that characterizes or separates two or more classes (or levels) of a categorical variable.
# ANOVA: ANOVA stands for Analysis of variance. It is similar to LDA except for the fact that it is operated using one or more categorical independent features and one continuous dependent feature. It provides a statistical test of whether the means of several groups are equal or not.
# Chi-Square: It is a is a statistical test applied to the groups of categorical features to evaluate the likelihood of correlation or association between them using their frequency distribution.

# filter methods do not remove multicollinearity.

###### 3. Wrapper Methods

# use a subset of features and train a model using them. 
# Based on the inferences that we draw from the previous model, we decide to add or remove features from your subset. 
# The problem is essentially reduced to a search problem. 

# forward feature selection, backward feature elimination, recursive feature elimination, etc

# One of the best ways for implementing feature selection with wrapper methods is to use Boruta package that finds the importance of a feature by creating shadow features.
# 1. adds randomness, by creating copies, i.e. shadows 
# 2. trains a random forest and evaluates the importance of each feature 
# 3. checks if a real feature has higher importance at every iteration, i.e. higher zscore 
# 4. stops when all features get confirmed or rejected, or reachees the limit of rnd forests runs 

##### 4. Embedded Methods 
# Embedded methods combine the qualities’ of filter and wrapper methods. 
# It’s implemented by algorithms that have their own built-in feature selection methods.

# lasso and ridge regression

####### 5. Difference between Filter and Wrapper methods

# Filter methods measure the relevance of features by their correlation with dependent variable while wrapper methods measure the usefulness of a subset of feature by actually training a model on it.
# Filter methods are much faster compared to wrapper methods as they do not involve training the models. On the other hand, wrapper methods are computationally very expensive as well.
# Filter methods use statistical methods for evaluation of a subset of features while wrapper methods use cross validation.
# Filter methods might fail to find the best subset of features in many occasions but wrapper methods can always provide the best subset of features.
# Using the subset of features from the wrapper methods make the model more prone to overfitting as compared to using subset of features from the filter methods.

########## 6. Walkthrough example

# we’ll predict whether the stock will go up or down based on 100 predictors in R. 
# This dataset contains 100 independent variables from X1 to X100 representing profile of a stock and one outcome variable Y with two levels : 1 for rise in stock price and -1 for drop in stock price.

# let’s start with applying random forest for all the features on the dataset first
library('randomForest')
library('ggplot2')
library('ggthemes')
library('dplyr')

#set random seed
set.seed(101)

#loading dataset
data<-read.csv("./data/stock_data.csv",stringsAsFactors= T)

#checking dimensions of data
dim(data)
summary(data)

#specifying outcome variable as factor
data$Y<-as.factor(data$Y)
data$Time<-NULL

#dividing the dataset into train and test
train<-data[1:2000,]
test<-data[2001:3000,]

#applying Random Forest
model_rf<-randomForest(Y ~ ., data = train)
preds<-predict(model_rf,test[,-101])
table(preds)

#checking accuracy
library("Metrics")
auc(preds,test$Y)

# look at the feature importance 
importance(model_rf)
# plot(importance(model_rf),main="Variable Importance")

# Random forest for most important 20 features only
data<-randomForest(Y ~ X55+X11+X15+X64+X30
                       +X37+X58+X2+X7+X89
                       +X31+X66+X40+X12+X90
                       +X29+X98+X24+X75+X56,
                       data = train)
preds<-predict(model_rf,test[,-101])
table(preds)
auc(preds,test$Y)

# by just using 20 most important features,
# we have improved the accuracy from 0.452 to 0.476
# but also the interpretability, complexity and training time 

plot(varImp(object=model_rf),main="Variable Importance")





