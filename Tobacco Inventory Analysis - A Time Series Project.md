### Tobacco Inventory Analysis - A Time Series Project

**Siyuan Li, PSTAT 174 - Time Series, UCSB**

**Instructor: Raya E. Feldman**

***

#### 1 Overview

##### 1.1 Introduction to the data

Smoking is one of the most important consumptions in the modern society. People are paying more and more attention to the harmful effects of smoking. It is interesting to investigate how people’s raising awareness has affected the tobacco producing industry. However, the financial crisis happened during the 4thquarter of 2008 has brought a lot of changes to many industries. Thus I will belooking at the changes brought to the tobacco production industry. The data Iam looking at is the tobacco manufacturer’s total inventory from January 2000 to October 2013, but for comparison purpose, I excluded November 2008 to October 2013. I will address this excluded part of data in the conclusion section. The inventory of goods is in currency unit which indicated how much value of goods the manufacturers has in stock in the market. It not only means the value of the good but also the amounts of good manufacturers have.

The data is found from “datamarket.com” and is provided by Federal Reserve Bank of St. Louis.

##### 1.2 Introduction to the project

For the project, I analyzed the data as a time series. Using the materials I learned from the PSTAT 174 course, I have conducted a series of calculations based on the data. The purpose of these calculations was to estimate a time series model to fit the data. With the estimated model, I could then predict future changes. I compared the prediction with the real data, which showed that although my forecast is accurate due to unknown factors in the market, the real data still fell inside the confidence interval which made my forecasting acceptable. 

All the calculations, computations and graphing are done using R programming language. 

#### 2 Data Analysis

##### 2.1 Spectating Original Data

Let’s first look at my original data:

![]()

We can conclude the following:

1. The data has a decreasing trend.
2. The data has no visible seasonal trend. As a matter of fact, the data I choseis already seasonally adjusted by the source.
3. The variance between entries some how similar, but I am not sure to say if thevariance is stable.

These findings suggests:

1. Differencing the data is needed to achieve a stationary time series process.
2. There is no precise indication whether to difference the data according to someperiod.
3. Certain transformation has to be done to the data to stabilize the variancealthough the result may not be significant.

 Some important values: for original data: Mean: 4733.019, Variance: 344523.4 

##### 2.2 Data Transformation

Based on the finding from the previous part, I was able to do some calculations.
First, I chose to calculate the power coefficient (![lambda](http://www.sciweavers.org/tex2img.php?eq=%20%5Clambda%20&bc=White&fc=Black&im=jpg&fs=12&ff=mathdesign&edit=0)) for power transformation. This process was done in the R programming interface.

![]()

This gave a graph of the log-Likelihood function respect to power coefficient ![lambda](http://www.sciweavers.org/tex2img.php?eq=%20%5Clambda%20&bc=White&fc=Black&im=jpg&fs=12&ff=mathdesign&edit=0):

![]()

Using the following code, I obtained the preferred power coefficient ![lambda](http://www.sciweavers.org/tex2img.php?eq=%20%5Clambda%20&bc=White&fc=Black&im=jpg&fs=12&ff=mathdesign&edit=0):

![]()

This result of power coefficient suggests that I could either perform standard power transformation using the coefficient, or keep using the original data. Note that the function to perform power transformation is:

##### 2.3 Autocorrelation and Partial Autocorrelation Functions

##### 2.4 Model Fitting

#### 3 Forecasting

#### 4 Conclusion

#### 5 Reference

#### Appendix

