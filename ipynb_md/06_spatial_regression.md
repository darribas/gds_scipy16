
# Spatial Regression

> [`IPYNB`](../content/part2/06_spatial_regression.ipynb)

> **NOTE**: much of this material has been ported and adapted from the Spatial Econometrics note in [Arribas-Bel (2016b)](http://darribas.org/spa_notes).

This notebook covers a brief and gentle introduction to spatial econometrics in Python. To do that, we will use a set of Austin properties listed in AirBnb.

The core idea of spatial econometrics is to introduce a formal representation of space into the statistical framework for regression. This can be done in many ways: by including predictors based on space (e.g. distance to relevant features), by splitting the datasets into subsets that map into different geographical regions (e.g. [spatial regimes](http://pysal.readthedocs.io/en/latest/library/spreg/regimes.html)), by exploiting close distance to other observations to borrow information in the estimation (e.g. [kriging](https://en.wikipedia.org/wiki/Kriging)), or by introducing variables that put in relation their value at a given location with those in nearby locations, to give a few examples. Some of these approaches can be implemented with standard non-spatial techniques, while others require bespoke models that can deal with the issues introduced. In this short tutorial, we will focus on the latter group. In particular, we will introduce some of the most commonly used methods in the field of spatial econometrics.

The example we will use to demonstrate this draws on hedonic house price modelling. This a well-established methodology that was developed by [Rosen (1974)](https://en.wikipedia.org/wiki/Kriging) that is capable of recovering the marginal willingness to pay for goods or services that are not traded in the market. In other words, this allows us to put an implicit price on things such as living close to a park or in a neighborhood with good quality of air. In addition, since hedonic models are based on linear regression, the technique can also be used to obtain predictions of house prices.

## Data

Before anything, let us load up the libraries we will use:


```python
%matplotlib inline

import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import pysal as ps
import geopandas as gpd

sns.set(style="whitegrid")
```

    /home/dani/anaconda/envs/pydata/lib/python2.7/site-packages/matplotlib/font_manager.py:273: UserWarning: Matplotlib is building the font cache using fc-list. This may take a moment.
      warnings.warn('Matplotlib is building the font cache using fc-list. This may take a moment.')


Let us also set the paths to all the files we will need throughout the tutorial, which is only the original table of listings:


```python
# Adjust this to point to the right file in your computer
abb_link = '../data/listings.csv.gz'
```

And go ahead and load it up too:


```python
lst = pd.read_csv(abb_link)
```

## Baseline (nonspatial) regression

Before introducing explicitly spatial methods, we will run a simple linear regression model. This will allow us, on the one hand, set the main principles of hedonic modeling and how to interpret the coefficients, which is good because the spatial models will build on this; and, on the other hand, it will provide a baseline model that we can use to evaluate how meaningful the spatial extensions are.

Essentially, the core of a linear regression is to explain a given variable -the price of a listing $i$ on AirBnb ($P_i$)- as a linear function of a set of other characteristics we will collectively call $X_i$:

$$
\ln(P_i) = \alpha + \beta X_i + \epsilon_i
$$

For several reasons, it is common practice to introduce the price in logarithms, so we will do so here. Additionally, since this is a probabilistic model, we add an error term $\epsilon_i$ that is assumed to be well-behaved (i.i.d. as a normal).

For our example, we will consider the following set of explanatory features of each listed property:


```python
x = ['host_listings_count', 'bathrooms', 'bedrooms', 'beds', 'guests_included']
```

Additionally, we are going to derive a new feature of a listing from the `amenities` variable. Let us construct a variable that takes 1 if the listed property has a pool and 0 otherwise:


```python
def has_pool(a):
    if 'Pool' in a:
        return 1
    else:
        return 0
    
lst['pool'] = lst['amenities'].apply(has_pool)
```

For convenience, we will re-package the variables:


```python
yxs = lst.loc[:, x + ['pool', 'price']].dropna()
y = np.log(\
           yxs['price'].apply(lambda x: float(x.strip('$').replace(',', '')))\
           + 0.000001
          )
```

To run the model, we can use the `spreg` module in `PySAL`, which implements a standard OLS routine, but is particularly well suited for regressions on spatial data. Also, although for the initial model we do not need it, let us build a spatial weights matrix that connects every observation to its 8 nearest neighbors. This will allow us to get extra diagnostics from the baseline model.


```python
w = ps.knnW_from_array(lst.loc[\
                               yxs.index, \
                              ['longitude', 'latitude']\
                              ].values)
w.transform = 'T'
w
```

    unsupported weights transformation





    <pysal.weights.weights.W at 0x7f3c066107d0>



At this point, we are ready to fit the regression:


```python
m1 = ps.spreg.OLS(y.values[:, None], yxs.drop('price', axis=1).values, \
                  w=w, spat_diag=True, \
                  name_x=yxs.drop('price', axis=1).columns.tolist(), name_y='ln(price)') 
```

To get a quick glimpse of the results, we can print its summary:


```python
print(m1.summary)
```

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            :     unknown
    Weights matrix      :     unknown
    Dependent Variable  :   ln(price)                Number of Observations:        5767
    Mean dependent var  :      5.1952                Number of Variables   :           7
    S.D. dependent var  :      0.9455                Degrees of Freedom    :        5760
    R-squared           :      0.4042
    Adjusted R-squared  :      0.4036
    Sum squared residual:    3071.189                F-statistic           :    651.3958
    Sigma-square        :       0.533                Prob(F-statistic)     :           0
    S.E. of regression  :       0.730                Log likelihood        :   -6366.162
    Sigma-square ML     :       0.533                Akaike info criterion :   12746.325
    S.E of regression ML:      0.7298                Schwarz criterion     :   12792.944
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT       4.0976886       0.0223530     183.3171506       0.0000000
     host_listings_count      -0.0000130       0.0001790      -0.0726772       0.9420655
               bathrooms       0.2947079       0.0194817      15.1273879       0.0000000
                bedrooms       0.3274226       0.0159666      20.5067654       0.0000000
                    beds       0.0245741       0.0097379       2.5235601       0.0116440
         guests_included       0.0075119       0.0060551       1.2406028       0.2148030
                    pool       0.0888039       0.0221903       4.0019209       0.0000636
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            9.260
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2     1358479.047           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                6        1414.297           0.0000
    Koenker-Bassett test              6          36.756           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Lagrange Multiplier (lag)         1         255.796           0.0000
    Robust LM (lag)                   1          13.039           0.0003
    Lagrange Multiplier (error)       1         278.752           0.0000
    Robust LM (error)                 1          35.995           0.0000
    Lagrange Multiplier (SARMA)       2         291.791           0.0000
    
    ================================ END OF REPORT =====================================


Results are largely unsurprising, but nonetheless reassuring. Both an extra bedroom and an extra bathroom increase the final price around 30%. Accounting for those, an extra bed pushes the price about 2%. Neither the number of guests included nor the number of listings the host has in total have a significant effect on the final price.

Including a spatial weights object in the regression buys you an extra bit: the summary provides results on the diagnostics for spatial dependence. These are a series of statistics that test whether the residuals of the regression are spatially correlated, against the null of a random distribution over space. If the latter is rejected a key assumption of OLS, independently distributed error terms, is violated. Depending on the structure of the spatial pattern, different strategies have been defined within the spatial econometrics literature to deal with them. If you are interested in this, a very recent and good resource to check out is [Anselin & Rey (2015)](https://geodacenter.asu.edu/category/access/public/spatial-regress). The main summary from the diagnostics for spatial dependence is that there is clear evidence to reject the null of spatial randomness in the residuals, hence an explicitly spatial approach is warranted.

## Spatially lagged exogenous regressors (`WX`)

The first and most straightforward way to introduce space is by "spatially lagging" one of the explanatory variables.


```python
yxs_w = yxs.assign(w_pool=ps.lag_spatial(w, yxs['pool'].values))

m2 = ps.spreg.OLS(y.values[:, None], \
                  yxs_w.drop('price', axis=1).values, \
                  w=w, spat_diag=True, \
                  name_x=yxs_w.drop('price', axis=1).columns.tolist(), name_y='ln(price)') 
```


```python
print(m2.summary)
```

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: ORDINARY LEAST SQUARES
    -----------------------------------------
    Data set            :     unknown
    Weights matrix      :     unknown
    Dependent Variable  :   ln(price)                Number of Observations:        5767
    Mean dependent var  :      5.1952                Number of Variables   :           8
    S.D. dependent var  :      0.9455                Degrees of Freedom    :        5759
    R-squared           :      0.4044
    Adjusted R-squared  :      0.4037
    Sum squared residual:    3070.363                F-statistic           :    558.6139
    Sigma-square        :       0.533                Prob(F-statistic)     :           0
    S.E. of regression  :       0.730                Log likelihood        :   -6365.387
    Sigma-square ML     :       0.532                Akaike info criterion :   12746.773
    S.E of regression ML:      0.7297                Schwarz criterion     :   12800.053
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     t-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT       4.0906444       0.0230571     177.4134022       0.0000000
     host_listings_count      -0.0000108       0.0001790      -0.0603617       0.9518697
               bathrooms       0.2948787       0.0194813      15.1365024       0.0000000
                bedrooms       0.3277450       0.0159679      20.5252404       0.0000000
                    beds       0.0246650       0.0097377       2.5329419       0.0113373
         guests_included       0.0076894       0.0060564       1.2696250       0.2042695
                    pool       0.0725756       0.0257356       2.8200486       0.0048181
                  w_pool       0.0188875       0.0151729       1.2448141       0.2132508
    ------------------------------------------------------------------------------------
    
    REGRESSION DIAGNOSTICS
    MULTICOLLINEARITY CONDITION NUMBER            9.605
    
    TEST ON NORMALITY OF ERRORS
    TEST                             DF        VALUE           PROB
    Jarque-Bera                       2     1368880.320           0.0000
    
    DIAGNOSTICS FOR HETEROSKEDASTICITY
    RANDOM COEFFICIENTS
    TEST                             DF        VALUE           PROB
    Breusch-Pagan test                7        1565.566           0.0000
    Koenker-Bassett test              7          40.537           0.0000
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Lagrange Multiplier (lag)         1         255.124           0.0000
    Robust LM (lag)                   1          13.448           0.0002
    Lagrange Multiplier (error)       1         276.862           0.0000
    Robust LM (error)                 1          35.187           0.0000
    Lagrange Multiplier (SARMA)       2         290.310           0.0000
    
    ================================ END OF REPORT =====================================


## Spatially lagged endogenous regressors (`WY`)


```python
m3 = ps.spreg.GM_Lag(y.values[:, None], yxs.drop('price', axis=1).values, \
                  w=w, spat_diag=True, \
                  name_x=yxs.drop('price', axis=1).columns.tolist(), name_y='ln(price)') 
```


```python
print(m3.summary)
```

    REGRESSION
    ----------
    SUMMARY OF OUTPUT: SPATIAL TWO STAGE LEAST SQUARES
    --------------------------------------------------
    Data set            :     unknown
    Weights matrix      :     unknown
    Dependent Variable  :   ln(price)                Number of Observations:        5767
    Mean dependent var  :      5.1952                Number of Variables   :           8
    S.D. dependent var  :      0.9455                Degrees of Freedom    :        5759
    Pseudo R-squared    :      0.4224
    Spatial Pseudo R-squared:  0.4056
    
    ------------------------------------------------------------------------------------
                Variable     Coefficient       Std.Error     z-Statistic     Probability
    ------------------------------------------------------------------------------------
                CONSTANT       3.7085715       0.1075621      34.4784213       0.0000000
     host_listings_count      -0.0000587       0.0001765      -0.3324585       0.7395430
               bathrooms       0.2857932       0.0193237      14.7897969       0.0000000
                bedrooms       0.3272598       0.0157132      20.8270544       0.0000000
                    beds       0.0239548       0.0095848       2.4992528       0.0124455
         guests_included       0.0065147       0.0059651       1.0921407       0.2747713
                    pool       0.0891100       0.0218383       4.0804521       0.0000449
             W_ln(price)       0.0392530       0.0106212       3.6957202       0.0002193
    ------------------------------------------------------------------------------------
    Instrumented: W_ln(price)
    Instruments: W_bathrooms, W_bedrooms, W_beds, W_guests_included,
                 W_host_listings_count, W_pool
    
    DIAGNOSTICS FOR SPATIAL DEPENDENCE
    TEST                           MI/DF       VALUE           PROB
    Anselin-Kelejian Test             1          31.545          0.0000
    ================================ END OF REPORT =====================================


## Prediction performance of spatial models


```python
from sklearn.metrics import mean_squared_error as mse

mses = pd.Series({'OLS': mse(y, m1.predy.flatten()), \
                     'OLS+W': mse(y, m2.predy.flatten()), \
                     'Lag': mse(y, m3.predy_e)
                    })
mses.sort_values()
```




    Lag      0.531327
    OLS+W    0.532402
    OLS      0.532545
    dtype: float64



## Exercise

> *Run a regression including both the spatial lag of pools and of the price. How does its predictive performance compare?*

