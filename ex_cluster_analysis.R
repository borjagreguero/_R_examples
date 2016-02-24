# CLUSTER ANALYSIS 
mydata <- mtcars
 
# data preparation 
mydata <- na.omit(mydata) # listwise deletion of missing
mydata <- scale(mydata) # standardize variables

#-----------------------------------------
# partioning - KMEANS 
#   Determine number of clusters
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
wss
i = 5 
clusters  <- kmeans(mydata, centers=i)
sum(clusters$withinss)

for (i in 2:15)   wss[i] <- sum(kmeans(mydata, centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")

# K-Means Cluster Analysis
fit <- kmeans(mydata, 5) # 5 cluster solution
# get cluster means 
aggregate(mydata,by=list(fit$cluster),FUN=mean)
fit$centers
# append cluster assignment
mydata <- data.frame(mydata, fit$cluster)
head(mydata)

#-----------------------------------------
# Hierarchical Agglomerative 
#
# Ward Hierarchical Clustering
d <- dist(mydata, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward") 
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
rect.hclust(fit, k=5, border="red")

# Ward Hierarchical Clustering with Bootstrapped p values
library(pvclust) # works by rows, not columns, --> t() 
fit <- pvclust(t(mydata), method.hclust="ward",method.dist="euclidean")
plot(fit) # dendogram with p values

# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
pvpick(fit)

#-----------------------------------------
# Model Based
# assume a variety of data models and apply maximum likelihood estimation and Bayes criteria to identify the most likely model and number of clusters 

# Model Based Clustering
library(mclust)
fit <- Mclust(mydata)
plot(fit) # plot results 
summary(fit) # display the best model

#-----------------------------------------
# Plotting Cluster Solutions
# K-Means Clustering with 5 clusters
fit <- kmeans(mydata, 5)

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
library(cluster) 
clusplot(mydata, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
library(fpc)
plotcluster(mydata, fit$cluster)

#-----------------------------------------
# Validating cluster solutions
# comparing 2 cluster solutions
library(fpc)
fit1 <- kmeans(mydata, 5)
fit2 <- pvclust(t(mydata), method.hclust="ward",method.dist="euclidean")
fit2 <- pvpick(fit2, alpha = 0.95)

library(reshape2)
fit2s <- melt(fit2, variable.name='Variable',value.name='name')
colnames(fit2s)[2] <- "clusterId"
fit2s

mydata2 <- data.frame(mydata,rownames(mydata))
colnames(mydata2)[ncol(mydata2)] <- "name"

fit2 <- merge(mydata2,fit2s,by = "name")

mydata2$ cluster2 <- NA
mydata2[fit2s$name,"cluster2"] <- fit2s$clusterId

clusplot(mydata, fit1$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)
clusplot(mydata2, fit2$clusterId, color=TRUE, shade=TRUE, labels=2, lines=0)

cluster.stats(d, fit1$cluster, fit2s$cluster)

