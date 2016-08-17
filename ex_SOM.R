library(kohonen) 

data(wines)
set.seed(7)

training <- sample(nrow(wines), 120)
Xtraining <- scale(wines[training, ])
Xtest <- scale(wines[-training, ],
               center = attr(Xtraining, "scaled:center"),
               scale = attr(Xtraining, "scaled:scale"))

som.wines <- som(Xtraining, grid = somgrid(5, 5, "hexagonal"))

som.prediction <- predict(som.wines, newdata = Xtest,
                          trainX = Xtraining,
                          trainY = factor(wine.classes[training]))
table(wine.classes[-training], som.prediction$prediction)

plot(som.wines, type="changes")
plot(som.wines, type="count")
plot(som_model, type="dist.neighbours")
plot(som_model, type="codes") # codes / weights vectors 