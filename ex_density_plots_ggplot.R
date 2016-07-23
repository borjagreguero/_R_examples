# DENSITY PLOTS WITH GGPLOT 
# http://petewerner.blogspot.com/2012/12/density-plot-with-ggplot.html

m <- matrix(data=cbind(rnorm(30, 0), rnorm(30, 2), rnorm(30, 5)), nrow=30, ncol=3)
m

colnames(m)= c('method1','method2','method3')
head(m)

df <- as.data.frame(m)
df

# What we would really like is to have our data in 2 columns, where the first column contains the data values, and the second column contains the method name. 
dfs = stack(df)
head(dfs)
is.factor(dfs[,2])

unstack(dfs)

ggplot(dfs, aes(x=values)) + geom_density()

# We want to group the values by each method used. 
ggplot(dfs, aes(x=values)) + geom_density(aes(group=ind))

#Let's try colour the different methods, based on the ind column in our data frame.
ggplot(dfs, aes(x=values)) + geom_density(aes(group=ind, colour=ind))

# use fill and an alpha value of 0.3 to make them transparent.
ggplot(dfs, aes(x=values)) + geom_density(aes(group=ind, colour=ind, fill=ind), alpha=0.3)
# Note that the alpha argument is passed to geom_density() rather than aes().
