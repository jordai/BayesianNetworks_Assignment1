# Set Working Directory (where data and R script are located)

set.seed(007)

## Import Packages
library('dagitty')
library( 'bayesianNetworks' )
library('lavaan')
library('bnlearn')

# Import Data
d <- read.csv("explored_forestfires.csv", colClasses=c("numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

# Show head of data
head(d)

# Now we can generate a correlation matrix as if the dataset is fully continuous:
M <- lavCor(d)
M

# Create Bayesian Causal Diagram with Dagitty
g <- dagitty('dag{
  bb="0,0,1,1"
  area [outcome,pos="0.5,0.8"]
  ISI [pos="0.2,0.6"]
  FFMC [pos="0.4,0.6"]
  DMC [pos="0.6,0.6"]
  DC [pos="0.8,0.6"]
  month [pos="0.7,0.25"]
  RH [pos="0.4,0.4"]
  rain [pos="0.8,0.4"]
  temp [pos="0.6,0.4"]
  wind [pos="0.2,0.4"]
  DC -> area
  DMC -> area
  FFMC -> area
  ISI -> area
  month -> rain
  month -> temp
  RH -> DMC
  RH -> FFMC
  rain -> DC
  rain -> DMC
  rain -> FFMC
  temp -> DC
  temp -> DMC
  temp -> FFMC
  temp -> RH
  wind -> FFMC
  wind -> ISI
  }')
png(file="graph0.png",
    width=600, height=350)
plot(g)
dev.off()
  
# Check implied conditional independencies
impliedConditionalIndependencies( g )
  
# Test independencies of G against our data D, using the correlation Matrix M
localTests(g, sample.cov = M, sample.nobs=nrow(d))
  
# We see that DC _||_ mnth | rain, temp has an estimated correlation of 0.852661472
# So there is some correlation between the two.
# Is this sensible? 
# DC is Drought Code, and it makes sense that in some months it is more dry than in other months. Let's introduce the connection mnth -> DC:
  
g <- dagitty('dag{
  bb="0,0,1,1"
  area [outcome,pos="0.5,0.8"]
  ISI [pos="0.2,0.6"]
  FFMC [pos="0.4,0.6"]
  DMC [pos="0.6,0.6"]
  DC [pos="0.8,0.6"]
  month [pos="0.7,0.25"]
  RH [pos="0.4,0.4"]
  rain [pos="0.8,0.4"]
  temp [pos="0.6,0.4"]
  wind [pos="0.2,0.4"]
  DC -> area
  DMC -> area
  FFMC -> area
  ISI -> area
  month -> rain
  month -> temp
  month -> DC
  RH -> DMC
  RH -> FFMC
  rain -> DC
  rain -> DMC
  rain -> FFMC
  temp -> DC
  temp -> DMC
  temp -> FFMC
  temp -> RH
  wind -> FFMC
  wind -> ISI
}')
png(file="graph1.png",
    width=600, height=350)
plot(g)
dev.off()

# Check implied conditional independencies
impliedConditionalIndependencies( g )

# Test independencies of G against our data D, using the correlation Matrix M
localTests(g, sample.cov = M, sample.nobs=nrow(d))


# Now we see that:            Estimate      p.value
# DC _||_ DMC | rain, temp    0.591113602   2.014520e-52
# FFMC _||_ ISI | wind        -0.782529376  2.751288e-123
# We are not certain about the first one, so let's tackle the second one first.
# ISI incoorporates the FFMC values (https://www.nwcg.gov/publications/pms437/cffdrs/fire-weather-index-system)
# So let's make a connection FFMC -> ISI:

g <- dagitty(
'dag{
  bb="0,0,1,1"
  area [outcome,pos="0.5,0.8"]
  ISI [pos="0.2,0.6"]
  FFMC [pos="0.4,0.6"]
  DMC [pos="0.6,0.6"]
  DC [pos="0.8,0.6"]
  month [pos="0.7,0.25"]
  RH [pos="0.4,0.4"]
  rain [pos="0.8,0.4"]
  temp [pos="0.6,0.4"]
  wind [pos="0.2,0.4"]
  DC -> area
  DMC -> area
  FFMC -> area
  FFMC -> ISI
  ISI -> area
  month -> rain
  month -> temp
  month -> DC
  RH -> DMC
  RH -> FFMC
  rain -> DC
  rain -> DMC
  rain -> FFMC
  temp -> DC
  temp -> DMC
  temp -> FFMC
  temp -> RH
  wind -> FFMC
  wind -> ISI
}')
png(file="graph2.png",
    width=600, height=350)
plot(g)
dev.off()

# Check implied conditional independencies
impliedConditionalIndependencies( g )

# Test independencies of G against our data D, using the correlation Matrix M
localTests(g, sample.cov = M, sample.nobs=nrow(d))

# Now we see that:            Estimate      p.value
# DC _||_ DMC | rain, temp    0.591113602   2.014520e-52
# We are not certain about how DC and DMC are correlated
# So let's make a connection DC <-> DMC:

g <- dagitty(
'dag{
  bb="0,0,1,1"
  area [outcome,pos="0.5,0.8"]
  ISI [pos="0.2,0.6"]
  FFMC [pos="0.4,0.6"]
  DMC [pos="0.6,0.6"]
  DC [pos="0.8,0.6"]
  month [pos="0.7,0.25"]
  RH [pos="0.4,0.4"]
  rain [pos="0.8,0.4"]
  temp [pos="0.6,0.4"]
  wind [pos="0.2,0.4"]
  DC -> area
  DMC -> area
  FFMC -> area
  FFMC -> ISI
  ISI -> area
  month -> rain
  month -> temp
  month -> DC
  RH -> DMC
  RH -> FFMC
  rain -> DC
  rain -> DMC
  rain -> FFMC
  temp -> DC
  temp -> DMC
  temp -> FFMC
  temp -> RH
  wind -> FFMC
  wind -> ISI
  DC -> DMC
}')
png(file="graph3.png",
    width=600, height=350)
plot(g)
dev.off()

# Check implied conditional independencies
impliedConditionalIndependencies( g )

# Test independencies of G against our data D, using the correlation Matrix M
localTests(g, sample.cov = M, sample.nobs=nrow(d))

# Now we have a network that describes the data pretty well.
# We only have some implied independencies that have moderate correlations or less.

# Split Train and Test Set
tsize = 0.8
split_ids = sample(nrow(d), nrow(d)*tsize)
dtrain <- d[split_ids,]
dtest <- d[-split_ids,]

# Fit network using train set
bayesnet <- model2network(toString(g, "bnlearn"))
fit <- bn.fit( bayesnet, as.data.frame(dtrain))
fit

# Predict train set:
ptrain <- predict( fit, node="area", data=dtrain)

# Predict test set:
ptest <- predict( fit, node="area", data=dtest)

## Calculate errors, by transforming output back to hectare using inverse of log(x+1) (which is exp(x -1))

# Train Set:
train_errors <- (exp(ptrain)-1) - (exp(dtrain$area)-1)
train_abs_errors <- abs((exp(ptrain)-1) - (exp(dtrain$area)-1))

# Mean Absolute Error on train set
train_MAE <- mean(train_abs_errors)

# Root Mean Squared Error on train set
train_RMSE <- sqrt(mean(train_errors^2))

# Test Set:
test_errors <- (exp(ptest)-1) - (exp(dtest$area)-1)
test_abs_errors <- abs((exp(ptest)-1) - (exp(dtest$area)-1))

# Mean Absolute Error on test set
test_MAE <- mean(test_abs_errors)

# Root Mean Squared Error on test set
test_RMSE <- sqrt(mean(test_errors^2))

# Printing predicted and real area
png(file="prediction_train.png", width=600, height=350)
plot(exp(dtrain$area), main = 'Overview of the predicted area (Red) and \nthe actual area in the training data (Blue) ',ylab = 'Area (Ha)', col = "blue")
points(exp(ptrain),  col = "red")
dev.off()

png(file="train_predict_vs_actual.png", width=600, height=350)
plot(dtrain$area, main = 'Overview of the predicted area (Red) and \nthe actual area in the training data (Blue) ',ylab = 'Log of the Area (Ha)', col = "blue")
points(ptrain,  col = "red")
dev.off()

png(file="prediction_test.png", width=600, height=350)
plot(exp(dtest$area), main = 'Overview of the predicted area (Red) and \nthe actual area in the test data (Blue) ',ylab = 'Area (Ha)', col = "blue")
points(exp(ptest),  col = "red")
dev.off()

png(file="test_predict_vs_actual.png", width=600, height=350)
plot(dtest$area, main = 'Overview of the predicted area (Red) and \nthe actual area in the test data (Blue) ',ylab = 'Log of the Area (Ha)', col = "blue")
points(ptest,  col = "red")
dev.off()

