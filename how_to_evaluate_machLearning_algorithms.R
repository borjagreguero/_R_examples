# http://machinelearningmastery.com/evaluate-machine-learning-algorithms-with-r/
#
# load libraries
library(mlbench)
library(caret)

# load data
data(PimaIndiansDiabetes)
# rename dataset to keep code below generic
dataset <- PimaIndiansDiabetes

# A ------- TEST HARNESS

# test options 
#   1. Train/Test split:
#   2. cross validation - 5 to 10 
#   3. Repeated Cross Validation  - 5 to 10 x3 times 
control <- trainControl(method="repeatedcv", number=10, repeats=3)
seed <- 7

# Test Metric
#Classification:
#     Accuracy: x correct divided by y total instances. Easy to understand and widely used.
#     Kappa: easily understood as accuracy that takes the base distribution of classes into account.

#Regression:
#     RMSE: root mean squared error. Again, easy to understand and widely used.
#     Rsquared: the goodness of fit or coefficient of determination.
# OTHERS> ROC and LogLoss. 
metric <- "Accuracy"

# B -------- MODEL BUILDING 

# Algorithms 
# Linear methods: Linear Discriminant Analysis and Logistic Regression.
# Non-Linear methods: Neural Network, SVM, kNN and Naive Bayes
# Trees and Rules: CART, J48 and PART
# Ensembles of Trees: C5.0, Bagged CART, Random Forest and Stochastic Gradient Boosting

# preprocess the data 
preProcess=c("center", "scale")

# Linear Discriminant Analysis
set.seed(seed)
fit.lda <- train(diabetes~., data=dataset, method="lda", metric=metric, preProc=c("center", "scale"), trControl=control)
# Logistic Regression
set.seed(seed)
fit.glm <- train(diabetes~., data=dataset, method="glm", metric=metric, trControl=control)
# GLMNET
set.seed(seed)
fit.glmnet <- train(diabetes~., data=dataset, method="glmnet", metric=metric, preProc=c("center", "scale"), trControl=control)
# SVM Radial
set.seed(seed)
fit.svmRadial <- train(diabetes~., data=dataset, method="svmRadial", metric=metric, preProc=c("center", "scale"), trControl=control, fit=FALSE)
# kNN
set.seed(seed)
fit.knn <- train(diabetes~., data=dataset, method="knn", metric=metric, preProc=c("center", "scale"), trControl=control)
# Naive Bayes
set.seed(seed)
fit.nb <- train(diabetes~., data=dataset, method="nb", metric=metric, trControl=control)
# CART
set.seed(seed)
fit.cart <- train(diabetes~., data=dataset, method="rpart", metric=metric, trControl=control)
# C5.0
set.seed(seed)
fit.c50 <- train(diabetes~., data=dataset, method="C5.0", metric=metric, trControl=control)
# Bagged CART
set.seed(seed)
fit.treebag <- train(diabetes~., data=dataset, method="treebag", metric=metric, trControl=control)
# Random Forest
set.seed(seed)
fit.rf <- train(diabetes~., data=dataset, method="rf", metric=metric, trControl=control)
# Stochastic Gradient Boosting (Generalized Boosted Modeling)
set.seed(seed)
fit.gbm <- train(diabetes~., data=dataset, method="gbm", metric=metric, trControl=control, verbose=FALSE)


# C ---------- MODEL SELECTION 

results <- resamples(list(lda=fit.lda, logistic=fit.glm, glmnet=fit.glmnet,
                          svm=fit.svmRadial, knn=fit.knn, nb=fit.nb, cart=fit.cart, c50=fit.c50,
                          bagging=fit.treebag, rf=fit.rf, gbm=fit.gbm))
# Table comparison
summary(results)

# boxplot comparison
bwplot(results)
# Dot-plot comparison
dotplot(results)

