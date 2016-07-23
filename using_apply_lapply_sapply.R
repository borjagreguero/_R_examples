#  USE OF APPLY, LAPPLY AND SAPPLY
m <- matrix(data=cbind(rnorm(30, 0), rnorm(30, 2), rnorm(30, 5)), nrow=30, ncol=3)
head(m)
# apply 
# We tell apply to traverse row wise or column wise by the second argument.
# In this case we expect to get three numbers at the end, 
# the mean value for each column, so tell apply to work along columns by passing
# 2 as the second argument. But let’s do it wrong for the point of illustration:

apply(m, 1, mean)
apply(m, 2, mean)

apply(m, 2, function(x) length(x[x<0]))
apply(m, 2, function(x) is.matrix(x))
apply(m, 2, is.vector)
apply(m, 2, length(x[x<0]))
apply(m, 2, function(x) mean(x[x>0]))

# Using sapply and lapply
# These two functions work in a similar way, traversing over a set of data like a 
# list or vector, and calling the specified function for each item.
sapply(1:3, function(x) x^2)

#lapply is very similar, however it will return a list rather than a vector:
lapply(1:3, function(x) x^2)

# Passing simplify=FALSE to sapply will also give you a list:
sapply(1:3, function(x) x^2, simplify=F)
# And you can use unlist with lapply to get a vector.
unlist(lapply(1:3, function(x) x^2))

# Anyway, a cheap trick is to pass sapply a vector of indexes and write your function 
# making some assumptions about the structure of the underlying data. 
# Let’s look at our mean example again:
sapply(1:3, function(x) mean(m[,x]))
sapply(1:3, function(x, y) mean(y[,x]), y=m)












