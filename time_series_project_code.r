# Load dependencies
library(MASS)
library(forecast)

# Read the data into R and plot the time series
tobacco.csv <- read.table("./data/value-of-manufacturers-total-inv-adj.csv", sep = ",", header = FALSE, skip = 1, nrows = 106)
tobacco <- ts(tobacco.csv[,2], start = 2000, frequency = 12)
ts.plot(tobacco, main = "Value of Manufacturers Total Inventory of Nondurable Goods -
Tobacco, Seasonally Adjusted Data", ylab = "Million of Dollars", xlab = "Year")
tobacco

# Check mean and variance
mean(tobacco)
var(tobacco)
#got mean 4733.019
#got variance 344523.4

# Transform the data using Box-Cox Transformation
require(MASS)
t <- 1:length(tobacco)
fit <- lm(tobacco ~ t)
bcTransform <- boxcox(tobacco ~ t)
lambda <- bcTransform$x[which(bcTransform$y == max(bcTransform$y))]
lambda

#got lambda is 1.070707
x11()
tobacco.tr <- tobacco
ts.plot(tobacco.tr)
tobacco.bc <- (tobacco^lambda - 1) * (1 / lambda)
var(tobacco.bc)

# Remove trend from the transformed data
x11()
tobacco.tr.diff <- diff(tobacco.tr)
ts.plot(tobacco.tr.diff, main = "... - Tobacco, Seasonally Adjusted Data, Differenced at Lag 1", ylab <- "Million of Dollars", xlab = "Year")
diff.len <- length(tobacco.tr.diff)
diff.trend <- lm(tobacco.tr.diff ~ as.numeric(1 : diff.len))
abline(diff.trend, col = "red")
m <- mean(tobacco.tr.diff)
abline(b = m, col="blue")

# Check variance
var(tobacco.tr.diff)
#got variance 3399.553

# Try diff again
tobacco.tr.diff2 <- diff(tobacco.tr.diff)
var(tobacco.tr.diff2)
#got variance 7690.539
#keep result from difference once

# Plot ACF/PACF for the transformed data
x11()
acf(tobacco.tr.diff, main = "Autocorrelation Function (ACF) of Differenced Data", ylab= "")
x11()
pacf(tobacco.tr.diff, main = "Parital Autocorrelation Function (PACF) of Differenced Data", ylab= "")

#suspect ARMA(6,6)
ar(tobacco.tr.diff, method = "mle")

# Test for ARMA(p,q) parameter
library(qpcR)
aicc <- 0
for (i in 6:6){
	for (j in 0:6){
		print(i); 
		print(j); 
		sum = AICc(arima(tobacco.tr.diff, order = c(i, 1, j), method = "ML"));
		print(sum)
		}
	}
print(aicc)
#give p=6,q=5 which is smallest, 1147.859
#give p=6,q=1 which is second smallest, 1149.292
#give p=6,q=6 which is third smallest, 1149.609

# Calculate coefficients to give model estimation
arima(tobacco.tr.diff, order = c(6, 1, 1), method = "ML")

# Fit the data to arima model with coefficients (6,1,5)
fit.arma <- arima(tobacco.tr.diff, order = c(6, 1, 5), method = "ML")
plot(residuals(fit.arma), main = "Residuals of the Fitting Data to ARIMA(6,1,5)", ylab = "", xlab = "Year")

# Do diagnostic tests
hist(tobacco.tr.diff, main = "Histogram of Differenced Data")
#looks normal
# n=106, sqrt(n)=10.29 use lag 10
Box.test(residuals(fit.arma), lag = 10, type = c("Box-Pierce"))
#passed with p-value=0.4213
Box.test(residuals(fit.arma), lag = 10, type = c("Ljung-Box"))
#passed with p-value=0.3711
Box.test(residuals(fit.arma)^2, lag = 10, type = c("Ljung-Box"))
#passed with p-value=0.9966
shapiro.test(residuals(fit.arma))
#not passed
#comment on not passing normality test

# Do causality and invertibility test
source("plot.roots.R")
plot.roots(NULL, polyroot(c(0.064, -0.8332, 0.0991, -0.5232, -0.1649, -0.1947)), main = "roots of AR part")
plot.roots(NULL, polyroot(c(-1.159, 1.2193, -1.3562, 1.1249, -0.8291)), main = "roots of MA part")

# Reassign the axis
tobacco.forecast <- ts(tobacco.csv[,2], start = 0)
ts.plot(tobacco.forecast, xlim = c(0, 116), ylim = c(3000, max(tobacco.forecast)), 
	main = "Value of Manufacturers Total Inventory of Nondurable Goods - Tobacco, Seasonally Adjusted Data", 
	ylab = "Million of Dollars", 
	xlab = "# of Month")

# Fit the data to ARIMA(6,1,5)
library(forecast)
model <- arima(tobacco.forecast, order = c(6, 1, 5), seasonal = c(0, 0, 0), method = "ML", optim.control = list(maxit = 1000))

# Do forecasting
fc <- predict(model, n.ahead = 10)
fc.orig <- fc$pred
fc.se <- fc$se

# Plot the forecast data
points(106:115, fc.orig, col = "red")
lines(106:115, fc.orig + 1.96 * fc.se, lty = 2, col = "blue")
lines(106:115, fc.orig - 1.96 * fc.se, lty = 2, col = "blue")

# Real result
tobacco.orig.csv <- read.table(".data/value-of-manufacturers-total-inv-adj.csv", sep = "," ,header = FALSE, skip = 1, nrows = 116)
tobacco.real <- ts(tobacco.orig.csv[,2], start = 0)
ts.plot(tobacco.real, xlim = c(0, 120), ylim=c(3000,max(tobacco.forecast)), 
	main = "Value of Manufacturers Total Inventory of Nondurable Goods - Tobacco, Seasonally Adjusted Data", 
	ylab = "Million of Dollars", 
	xlab = "Year")
