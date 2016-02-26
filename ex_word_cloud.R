
library(wordcloud)
pal <- brewer.pal(4, "BuGn")
wordcloud(words = c("climate","adaptation","ecosystem","risk"), 
          freq = c(0.5,0.3,0.2,0.2), min.freq = 1,
          random.order = F, colors = pal)
