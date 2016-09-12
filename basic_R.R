# https://rdisorder.wordpress.com/2016/08/06/data-science-in-minutes/
        
# Read data from csv
df = read.csv('some_data.csv')

# Make a plot of the data
plot(df$debt, df$gdp)

# Fit a linear regression
lm(gdp ~ debt, data = df)


# Generate some random number
x = runif(10)
y = runif(10)

# Print generated numbers
x
y

# Sum the two vectors
x + y

# As a primer you saw also earlier that I wrote
# some text in the code, but it wasn't evaluated.
# These are comments, you can use them by simply
# using '#' before text.

###### I can add also more '#' to draw the attention
# on that comment.

# Another thing about R:
# '<-' and '=' are the same when assigning values

# Assign names
# We can do math with R as we would do in a simple calculator
5 + 6 # Returns 11
2 * 5 # Returns 10
2 ^ 2 # Returns 2 to the power of 2 = 4
10 / 2 # Returns 5

# But this is an inefficient way to deal with data: think about a 1000 rows dataset,
# and you want to find the sum.
# It's going to take a bit to sum by hand every value in it
# So we can assign names to values
x = 5
x # This prints the value of x, so we will se 5
x = 7
x # As you can see the value of x has changed to 7

# We can store whatever we want in a name
x = 'hello world'
x

x = 5 * 5 # R will evaluate the expression 5 * 5 and then store its result in x

# We can do operations with variables
x = 5
y = 2
x * y # Returns 10
x + y # Returns 7
x # The values of x and y are unchanged
y

z = x + y * x / y
z
x
y

# Getting back to our previous example, to manage many elements we need vectors
x = c(1, 2, 3, 4, 5) # We create vectors with the c() function
x

# Vectors can contain integers (as above), floats or strings
x = c(1.5, 2.3, 7.4) # Floats
y = c('hello', 'world', 'bye', 'moon') # Strings of text

# We can combine vectors,
# but remember that one vector can contain only one type among floats or strings
z = c(x, 3, 5)
z
z = c(x, y) # Here R converts the floats in x to strings
z

# Operations with vectors
x = c(1, 2, 3)
y = c(4, 5, 6)
x + y # R sums every value of x with the corresponding value of y
x * y

# What if we want to sum only the first value of x with the second value of y?
# We use indexing
x[1] # This prints the first element of x
y[2] # This prints the second element of y
x[1] + y[2] # Returns 6
x[1:2] # Returns the first two elements of x
x[1:2] + y[2:3] # Returns 6, 8

# Above we used ':' between two indexes
# we can use it also to generate sequences of values
x = 1:10
x # Returns 1 2 3 4 5 6 7 8 9 10
x = 10:1
x # Returns the same sequence as before, but inverted

# Returning to the same example, 1000 values to sum.
# We will use a couple of functions to demonstrate
# the speed and the capability of vectors and R
set.seed(123)
x = runif(1000)
# runif() is a function, a function takes various
# arguments and will do some operation with them.
# When in doubt go with help '?functionName'.
# In this case we generate 1000 random numbers.
# set.seed() is another function that blocks the seed
# for random generation, we need it otherwise you wouldn't get
# the same results as me
# (see previous sections Install R and Install RStudio)
sum(x) # sum() is a function that sums every element in a vector
# We can do the same for larger vectors
x = runif(100000)
sum(x) # Returns 49931.65

x = runif(1000000)
sum(x) # Returns 499638.4

# Data Frame
# Usually when we deal with data we want them in tabular format:
# organized by columns and rows.
# R has an internal method to deal with tabular data: data frames
x = 1:10
y = letters[1:10] # We take the first 10 letters of the alphabet
z = rep(c('male', 'female'), 5) # rep() replicates the first argument x times
df = data.frame(id = x, status = y, sex = z)
df

# We created a dataframe from 3 vectors,
# as you can see it's organized as a table, and every column is a vector.
# We can call single or groups of rows and columns and do operations on them
df[1,1] # Returns the first row in the first column
df[1, ] # Returns the whole first row
df[ ,1] # Returns the first column
df[ ,'sex'] # Returns the sex column

# Another way to select columns is with the '$' operator
df$sex # Returns sex column
sum(df$id)

# data loading 
iris_data <- read.csv(
        'http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data',
        header = FALSE)
head(iris_data,10)

# Create a vector with column names, use &amp;quot;_&amp;quot; as a best practice instead of whitespace
iris_names = c(
        'Sepal_Length', 
        'Sepal_Width', 
        'Petal_Length', 
        'Petal_Width', 
        'Species'
)

# Rename columns with the created vector
names(iris_data) = iris_names

# Check that everything went fine
head(iris_data)

summary(iris_data)
class(iris_data$Species)
levels(iris_data$Species)
str(iris_data)

# You can use tapply() to apply a function 
# to a vector split by another vector
tapply(
        iris_data$Sepal_Length, 
        iris_data$Species, 
        mean
)
# Use aggregate()
aggregate(
        iris_data[,1:4], # Columns you want to calculate and collapse
        list(iris_data$Species), # List of columns with splitting values
        mean # Function to calculate and collapse data
)

# To use dplyr you have to install it
install.packages(&amp;quot;dplyr&amp;quot;)

# Then just call it before using it
library(dplyr)

# The first argument is always the dataset
# This '%>%' is the pipe operator and says to R to take
# what comes before it and pass it through the following function
iris_data %>% 
        group_by(Species) %>%
        summarize_each(funs(mean))

plot(iris_data)

library(ggplot2)

# Call ggplot()
ggplot(iris_data, # The dataset is the first argument
       aes( # aes() = aesthetics
               Petal_Width, # x axis
               Sepal_Width, # y axis
               color = Species # color values by Species
       )
) + # ggplot() creates an empty plot
        geom_point() # add points to the empty plot

# modeling 
# With filter() in dplyr you can filter rows by a condition,
# in this case we keep all rows where Species is not equal (!=)
# to Iris - setosa
iris_subset <- iris_data %>% filter(Species != 'Iris-setosa')

# R is smart, but not so smart, it will keep all levels for Species
# unless you tell him to drop unused levels
iris_subset$Species <- droplevels(iris_subset$Species)
dim(iris_subset)

# Since you will use a random function is always 
# a best practice setting a seed
set.seed(123)

# With the sample() function we draw a random sequence of ids
train <- sample(1:nrow(iris_subset), 85)

# Train is just an index of ids we will use to subset data
head(train)

# Then we subset iris_data using the train index
iris_train <- iris_subset[train,]
iris_test <- iris_subset[-train,]

# Create a logistic regression model
iris_lr <- glm(Species ~ Petal_Width, 
               data = iris_train, 
               family = binomial)

# Predict the probability of the observation being virginica
probs <- predict(iris_lr, iris_test, type = 'response')

# Create a vector for the prediction with the base category
pred <- rep('Iris - versicolor', 15)

# Every probability &amp;gt; 0.5 means predicting virginica
pred[probs > 0.5] <- 'Iris - virginica'

# Build a confusion matrix
table(iris_test$Species, pred)



# LINEAR DISCRIMINANT ANALYSIS 
set.seed(999)
train <- sample(1:nrow(iris_data), 100)
iris_train <- iris_data[train,]
iris_test <- iris_data[-train,]

# The lda() function is in the MASS package
library(MASS)

# As I told you before algos in R
# are fed in a similar manner
iris_lda <- lda(Species ~ Petal_Width, data = iris_train)

# Add '$class' at the end of predict to get
# only the predicted classes
preds <- predict(iris_lda, iris_test[,1:4])$class

# Confusion matrix as before
table(iris_test$Species, preds)

iris_lda <- lda(Species ~ ., data = iris_train)
preds <- predict(iris_lda, iris_test[,1:4])$class
table(iris_test$Species, preds)

set.seed(789)
# KNN is in class package
library(class)

# knn works a bit differently than 
# other methods we tried

# Take all the columns you want to
# use for prediction
knn_train <- iris_train[,-5]
knn_test <- iris_test[,-5]

# Take only the vector of correct 
# classes for the train set
train_class <- iris_train[,5]

# Feed knn() with them, 'k' indicates the number
# neighbors that can vote for classifying other neighbours
iris_knn <- knn(knn_train, knn_test, train_class, k = 6)

# Confusion matrix
table(iris_knn, iris_test$Species)



