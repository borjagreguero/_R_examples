# EXAMPLE GRADE ANALYSIS R 
# me, other_199, and previous_4 are available in the workspace

# Merge me and other_199: my_class
my_class = c(me,other_199)

# cbind() my_class and previous_4: last_5
last_5 = cbind(my_class, previous_4)

# Name last_5 appropriately
colnames(last_5)=c("year_1", "year_2", "year_3", "year_4","year_5")

# Build histogram of my_class
hist(my_class)

# Generate summary of last_5
summary(last_5)

# Build boxplot of last_5
boxplot(last_5)

# Is your grade equal to 72?
me ==72

# Which grades in your class are higher than 75?
my_class[my_class>75]
my_class > 75

# Which grades in the last 5 years are below or equal to 64?
last_5[last_5<=64]
last_5 <= 64

# How many grades in your class are higher than 75?
sum(my_class>75)

# How many students in your class scored strictly higher than you?
sum(my_class>89)

# What's the proportion of grades below or equal to 64 in the last 5 years?
sum(last_5<=64)/length(last_5)

# Is your grade greater than 87 and smaller than or equal to 89?
me>87 & me<=89

# Which grades in your class are below 60 or above 90?
my_class<60 | my_class>90

# Which grades in the last five years are divisible by 3 or by 4?
last_5 %% 3 ==0 |  last_5 %% 4 ==0

# What's the proportion of grades in your class that is average?
mean(my_class >= 70 & my_class <= 85)

# How many students in the last 5 years had a grade of 80 or 90?
sum(last_5 == 80 | last_5 == 90)

# What's the proportion of students with an even score two years ago?
mean(last_5[,3] %% 2 == 0)

if (me > 80) {
        print("Good student!")
} else {
        print("Better luck next year!")
}
# Define n_smart
n_smart = sum(my_class>=80)

# Code the if-else construct
if (n_smart>50) {
        print("smart class")
} else {
        print("rather average")
}

# Define prop_less
prop_less  = mean(my_class<me)

# Code the control construct
if (prop_less >0.9) {
        print("you're among the best 10 percent")
} else if (prop_less >0.8){
        print("you're among the best 20 percent")
} else {
        print ("need more analysis")
}

# Create top_grades
top_grades <- my_class[my_class >= 85]

# Create worst_grades
worst_grades <- my_class[my_class < 65]

# Write conditional statement
if (length(top_grades) > length(worst_grades)) {
        print("top grades prevail")
}






