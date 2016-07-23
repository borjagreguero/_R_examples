
# r charts 

# 2.1 pie charts and bars 
lungcapdata = read.table(file.choose(),header = T, sep = "\t")
attach(lungcapdata)
dim(lungcapdata)

names(lungcapdata)
class(lungcapdata)

?barplot
help(barplot)

# freq table 
count = table(Gender)
count 
 
percent = table(Gender)/725

barplot(percent)
barplot(percent,main = "title", xlab = "gender", ylab = "%", 
        las = 1, names.arg = c("female","male")) # vertical bars
barplot(percent,main = "title", xlab = "gender", ylab = "%", 
        las = 1, names.arg = c("female","male"), horiz = T ) # horizontal

pie(count) # pie chart 
pie(count,main = "title")
box() # add box 


