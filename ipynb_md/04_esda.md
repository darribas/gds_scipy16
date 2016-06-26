
# Exploratory Spatial Data Analysis (ESDA)

> [`IPYNB`](../content/part1/04_esda.ipynb)



```python
%matplotlib inline
import pysal as ps
import pandas as pd
import numpy as np
from pysal.contrib.viz import mapping as maps
```

A well-used functionality in PySAL is the use of PySAL to conduct exploratory spatial data analysis. This notebook will provide an overview of ways to conduct exploratory spatial analysis in Python. 

First, let's read in some data:


```python
data = ps.pdio.read_files("../data/texas.shp")
```


```python
data.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>NAME</th>
      <th>STATE_NAME</th>
      <th>STATE_FIPS</th>
      <th>CNTY_FIPS</th>
      <th>FIPS</th>
      <th>STFIPS</th>
      <th>COFIPS</th>
      <th>FIPSNO</th>
      <th>SOUTH</th>
      <th>HR60</th>
      <th>...</th>
      <th>BLK90</th>
      <th>GI59</th>
      <th>GI69</th>
      <th>GI79</th>
      <th>GI89</th>
      <th>FH60</th>
      <th>FH70</th>
      <th>FH80</th>
      <th>FH90</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Lipscomb</td>
      <td>Texas</td>
      <td>48</td>
      <td>295</td>
      <td>48295</td>
      <td>48</td>
      <td>295</td>
      <td>48295</td>
      <td>1</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.031817</td>
      <td>0.286929</td>
      <td>0.378219</td>
      <td>0.407005</td>
      <td>0.373005</td>
      <td>6.724512</td>
      <td>4.5</td>
      <td>3.835360</td>
      <td>6.093580</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6da8ad...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Sherman</td>
      <td>Texas</td>
      <td>48</td>
      <td>421</td>
      <td>48421</td>
      <td>48</td>
      <td>421</td>
      <td>48421</td>
      <td>1</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.139958</td>
      <td>0.288976</td>
      <td>0.359377</td>
      <td>0.415453</td>
      <td>0.378041</td>
      <td>5.665722</td>
      <td>1.7</td>
      <td>3.253796</td>
      <td>3.869407</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6da8ad...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Dallam</td>
      <td>Texas</td>
      <td>48</td>
      <td>111</td>
      <td>48111</td>
      <td>48</td>
      <td>111</td>
      <td>48111</td>
      <td>1</td>
      <td>0.0</td>
      <td>...</td>
      <td>2.050906</td>
      <td>0.331667</td>
      <td>0.385996</td>
      <td>0.370037</td>
      <td>0.376015</td>
      <td>7.546049</td>
      <td>7.2</td>
      <td>9.471366</td>
      <td>14.231738</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6da8ad...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Hansford</td>
      <td>Texas</td>
      <td>48</td>
      <td>195</td>
      <td>48195</td>
      <td>48</td>
      <td>195</td>
      <td>48195</td>
      <td>1</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.000000</td>
      <td>0.253527</td>
      <td>0.357813</td>
      <td>0.393938</td>
      <td>0.383924</td>
      <td>7.591786</td>
      <td>4.7</td>
      <td>5.542986</td>
      <td>7.125457</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6da8ad...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Ochiltree</td>
      <td>Texas</td>
      <td>48</td>
      <td>357</td>
      <td>48357</td>
      <td>48</td>
      <td>357</td>
      <td>48357</td>
      <td>1</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.021911</td>
      <td>0.236998</td>
      <td>0.352940</td>
      <td>0.343949</td>
      <td>0.374461</td>
      <td>5.172414</td>
      <td>4.0</td>
      <td>4.758392</td>
      <td>9.159159</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6da8ad...</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 70 columns</p>
</div>




```python
import matplotlib.pyplot as plt

import geopandas as gpd
shp_link = "../data/texas.shp"
tx = gpd.read_file(shp_link)
hr10 = ps.Quantiles(data.HR90, k=10)
f, ax = plt.subplots(1, figsize=(9, 9))
tx.assign(cl=hr10.yb).plot(column='cl', categorical=True, \
        k=10, cmap='OrRd', linewidth=0.1, ax=ax, \
        edgecolor='white', legend=True)
ax.set_axis_off()
plt.title("HR90 Deciles")
plt.show()
```


![png](04_esda_files/04_esda_6_0.png)


## Spatial Autocorrelation

Visual inspection of the map pattern for HR90 deciles allows us to search for spatial structure. If the spatial distribution of the rates was random, then we should not see any clustering of similar values on the map. However, our visual system is drawn to the darker clusters in the south west as well as the east, and a concentration of the lighter hues (lower homicide rates) moving north to the pan handle.

Our brains are very powerful pattern recognition machines. However, sometimes they can be too powerful and lead us to detect false positives, or patterns where there are no statistical patterns. This is a particular concern when dealing with visualization of irregular polygons of differning sizes and shapes.

The concept of *spatial autocorrelation* relates to the combination of two types of similarity: spatial similarity and attribute similarity. Although there are many different measures of spatial autocorrelation, they all combine these two types of simmilarity into a summary measure.

Let's use PySAL to generate these two types of similarity measures.

### Spatial Similarity

We have already encountered spatial weights in a previous notebook. In spatial autocorrelation analysis, the spatial weights are used to formalize the notion of spatial similarity. As we have seen there are many ways to define spatial weights, here we will use queen contiguity:


```python

data = ps.pdio.read_files("../data/texas.shp")
W = ps.queen_from_shapefile("../data/texas.shp")
W.transform = 'r'
```

### Attribute Similarity

So the spatial weight between counties $i$ and $j$ indicates if the two counties are neighbors (i.e., geographically similar). What we also need is a measure of attribute similarity to pair up with this concept of spatial similarity.
The **spatial lag** is a derived variable that accomplishes this for us. For county $i$ the spatial lag is defined as:
$$HR90Lag_i = \sum_j w_{i,j} HR90_j$$




```python
HR90Lag = ps.lag_spatial(W, data.HR90)
```


```python
HR90LagQ10 = ps.Quantiles(HR90Lag, k=10)
```


```python
f, ax = plt.subplots(1, figsize=(9, 9))
tx.assign(cl=HR90LagQ10.yb).plot(column='cl', categorical=True, \
        k=10, cmap='OrRd', linewidth=0.1, ax=ax, \
        edgecolor='white', legend=True)
ax.set_axis_off()
plt.title("HR90 Spatial Lag Deciles")

plt.show()
```


![png](04_esda_files/04_esda_12_0.png)


The decile map for the spatial lag tends to enhance the impression of value similarity in space. However, we still have the challenge of visually associating the value of the homicide rate in a county with the value of the spatial lag of rates for the county. The latter is a weighted average of homicide rates in the focal county's neighborhood.

To complement the geovisualization of these associations we can turn to formal statistical measures of spatial autocorrelation.


```python
HR90 = data.HR90
b,a = np.polyfit(HR90, HR90Lag, 1)
```


```python
f, ax = plt.subplots(1, figsize=(9, 9))

plt.plot(HR90, HR90Lag, '.', color='firebrick')

 # dashed vert at mean of the last year's PCI
plt.vlines(HR90.mean(), HR90Lag.min(), HR90Lag.max(), linestyle='--')
 # dashed horizontal at mean of lagged PCI
plt.hlines(HR90Lag.mean(), HR90.min(), HR90.max(), linestyle='--')

# red line of best fit using global I as slope
plt.plot(HR90, a + b*HR90, 'r')
plt.title('Moran Scatterplot')
plt.ylabel('Spatial Lag of HR90')
plt.xlabel('HR90')
plt.show()
```


![png](04_esda_files/04_esda_15_0.png)


## Global Spatial Autocorrelation

In PySAL, commonly-used analysis methods are very easy to access. For example, if we were interested in examining the spatial dependence in `HR90` we could quickly compute a Moran's $I$ statistic:


```python
I_HR90 = ps.Moran(data.HR90.values, W)
```


```python
I_HR90.I, I_HR90.p_sim
```




    (0.085976640313889768, 0.012999999999999999)



Thus, the $I$ statistic is $0.859$ for this data, and has a very small $p$ value. 


```python
b # note I is same as the slope of the line in the scatterplot
```




    0.085976640313889505



We can visualize the distribution of simulated $I$ statistics using the stored collection of simulated statistics:


```python
I_HR90.sim[0:5]
```




    array([-0.05640543, -0.03158917,  0.0277026 ,  0.03998822, -0.01140814])



A simple way to visualize this distribution is to make a KDEplot (like we've done before), and add a rug showing all of the simulated points, and a vertical line denoting the observed value of the statistic:


```python
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline
```


```python
sns.kdeplot(I_HR90.sim, shade=True)
plt.vlines(I_HR90.sim, 0, 0.5)
plt.vlines(I_HR90.I, 0, 10, 'r')
plt.xlim([-0.15, 0.15])
```

    /home/serge/anaconda2/envs/gds-scipy16/lib/python3.5/site-packages/statsmodels/nonparametric/kdetools.py:20: VisibleDeprecationWarning: using a non-integer number instead of an integer will result in an error in the future
      y = X[:m/2+1] + np.r_[0,X[m/2+1:],0]*1j





    (-0.15, 0.15)




![png](04_esda_files/04_esda_26_2.png)


Instead, if our $I$ statistic were close to our expected value, `I_HR90.EI`, our plot might look like this:


```python
sns.kdeplot(I_HR90.sim, shade=True)
plt.vlines(I_HR90.sim, 0, 1)
plt.vlines(I_HR90.EI+.01, 0, 10, 'r')
plt.xlim([-0.15, 0.15])
```

    /home/serge/anaconda2/envs/gds-scipy16/lib/python3.5/site-packages/statsmodels/nonparametric/kdetools.py:20: VisibleDeprecationWarning: using a non-integer number instead of an integer will result in an error in the future
      y = X[:m/2+1] + np.r_[0,X[m/2+1:],0]*1j





    (-0.15, 0.15)




![png](04_esda_files/04_esda_28_2.png)


The result of applying Moran's I is that we conclude the map pattern is not spatially random, but instead there is a signficant spatial association in homicide rates in Texas counties in 1990.

This result applies to the map as a whole, and is sometimes referred to as "global spatial autocorrelation". Next we turn to a local analysis where the attention shifts to detection of hot spots, cold spots and spatial outliers.

## Local Autocorrelation Statistics

In addition to the Global autocorrelation statistics, PySAL has many local autocorrelation statistics. Let's compute a local Moran statistic for the same data shown above:


```python
LMo_HR90 = ps.Moran_Local(data.HR90.values, W)
```

Now, instead of a single $I$ statistic, we have an *array* of local $I_i$ statistics, stored in the `.Is` attribute, and p-values from the simulation are in `p_sim`. 


```python
LMo_HR90.Is[0:10], LMo_HR90.p_sim[0:10]
```




    (array([ 1.12087323,  0.47485223, -1.22758423,  0.93868661,  0.68974296,
             0.78503173,  0.71047515,  0.41060686,  0.00740368,  0.14866352]),
     array([ 0.013,  0.169,  0.037,  0.015,  0.002,  0.009,  0.053,  0.063,
             0.489,  0.119]))



We can adjust the number of permutations used to derive every *pseudo*-$p$ value by passing a different `permutations` argument:


```python
LMo_HR90 = ps.Moran_Local(data.HR90.values, W, permutations=9999)
```

In addition to the typical clustermap, a helpful visualization for LISA statistics is a Moran scatterplot with statistically significant LISA values highlighted. 

This is very simple, if we use the same strategy we used before:

First, construct the spatial lag of the covariate:


```python
Lag_HR90 = ps.lag_spatial(W, data.HR90.values)
HR90 = data.HR90.values
```

Then, we want to plot the statistically-significant LISA values in a different color than the others. To do this, first find all of the statistically significant LISAs. Since the $p$-values are in the same order as the $I_i$ statistics, we can do this in the following way


```python
sigs = HR90[LMo_HR90.p_sim <= .001]
W_sigs = Lag_HR90[LMo_HR90.p_sim <= .001]
insigs = HR90[LMo_HR90.p_sim > .001]
W_insigs = Lag_HR90[LMo_HR90.p_sim > .001]
```

Then, since we have a lot of points, we can plot the points with a statistically insignficant LISA value lighter using the `alpha` keyword. In addition, we would like to plot the statistically significant points in a dark red color. 


```python
b,a = np.polyfit(HR90, Lag_HR90, 1)
```

Matplotlib has a list of [named colors](http://matplotlib.org/examples/color/named_colors.html) and will interpret colors that are provided in hexadecimal strings:


```python
plt.plot(sigs, W_sigs, '.', color='firebrick')
plt.plot(insigs, W_insigs, '.k', alpha=.2)
 # dashed vert at mean of the last year's PCI
plt.vlines(HR90.mean(), Lag_HR90.min(), Lag_HR90.max(), linestyle='--')
 # dashed horizontal at mean of lagged PCI
plt.hlines(Lag_HR90.mean(), HR90.min(), HR90.max(), linestyle='--')

# red line of best fit using global I as slope
plt.plot(HR90, a + b*HR90, 'r')
plt.text(s='$I = %.3f$' % I_HR90.I, x=50, y=15, fontsize=18)
plt.title('Moran Scatterplot')
plt.ylabel('Spatial Lag of HR90')
plt.xlabel('HR90')
```




    <matplotlib.text.Text at 0x7fd6cf324d30>




![png](04_esda_files/04_esda_44_1.png)


We can also make a LISA map of the data. 


```python
sig = LMo_HR90.p_sim < 0.05
```


```python
sig.sum()
```




    44




```python
hotspots = LMo_HR90.q==1 * sig
```


```python
hotspots.sum()
```




    10




```python
coldspots = LMo_HR90.q==3 * sig
```


```python
coldspots.sum()
```




    17




```python
data.HR90[hotspots]
```




    98      9.784698
    132    11.435106
    164    17.129154
    166    11.148272
    209    13.274924
    229    12.371338
    234    31.721863
    236     9.584971
    239     9.256549
    242    18.062652
    Name: HR90, dtype: float64




```python
data[hotspots]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>NAME</th>
      <th>STATE_NAME</th>
      <th>STATE_FIPS</th>
      <th>CNTY_FIPS</th>
      <th>FIPS</th>
      <th>STFIPS</th>
      <th>COFIPS</th>
      <th>FIPSNO</th>
      <th>SOUTH</th>
      <th>HR60</th>
      <th>...</th>
      <th>BLK90</th>
      <th>GI59</th>
      <th>GI69</th>
      <th>GI79</th>
      <th>GI89</th>
      <th>FH60</th>
      <th>FH70</th>
      <th>FH80</th>
      <th>FH90</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>98</th>
      <td>Ellis</td>
      <td>Texas</td>
      <td>48</td>
      <td>139</td>
      <td>48139</td>
      <td>48</td>
      <td>139</td>
      <td>48139</td>
      <td>1</td>
      <td>9.217652</td>
      <td>...</td>
      <td>10.009746</td>
      <td>0.325785</td>
      <td>0.365177</td>
      <td>0.352516</td>
      <td>0.372783</td>
      <td>12.418831</td>
      <td>10.5</td>
      <td>9.076165</td>
      <td>12.031635</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc81a...</td>
    </tr>
    <tr>
      <th>132</th>
      <td>Hudspeth</td>
      <td>Texas</td>
      <td>48</td>
      <td>229</td>
      <td>48229</td>
      <td>48</td>
      <td>229</td>
      <td>48229</td>
      <td>1</td>
      <td>9.971084</td>
      <td>...</td>
      <td>0.514580</td>
      <td>0.312484</td>
      <td>0.373474</td>
      <td>0.440944</td>
      <td>0.476631</td>
      <td>14.115899</td>
      <td>7.7</td>
      <td>8.959538</td>
      <td>11.363636</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7a1...</td>
    </tr>
    <tr>
      <th>164</th>
      <td>Jeff Davis</td>
      <td>Texas</td>
      <td>48</td>
      <td>243</td>
      <td>48243</td>
      <td>48</td>
      <td>243</td>
      <td>48243</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.359712</td>
      <td>0.316019</td>
      <td>0.367719</td>
      <td>0.437014</td>
      <td>0.399655</td>
      <td>14.438503</td>
      <td>10.1</td>
      <td>5.970149</td>
      <td>8.255159</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7ae...</td>
    </tr>
    <tr>
      <th>166</th>
      <td>Schleicher</td>
      <td>Texas</td>
      <td>48</td>
      <td>413</td>
      <td>48413</td>
      <td>48</td>
      <td>413</td>
      <td>48413</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.903010</td>
      <td>0.300170</td>
      <td>0.387936</td>
      <td>0.419192</td>
      <td>0.419375</td>
      <td>10.155148</td>
      <td>9.8</td>
      <td>7.222914</td>
      <td>8.363636</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7ae...</td>
    </tr>
    <tr>
      <th>209</th>
      <td>Chambers</td>
      <td>Texas</td>
      <td>48</td>
      <td>071</td>
      <td>48071</td>
      <td>48</td>
      <td>71</td>
      <td>48071</td>
      <td>1</td>
      <td>3.211613</td>
      <td>...</td>
      <td>12.694146</td>
      <td>0.299847</td>
      <td>0.374105</td>
      <td>0.378431</td>
      <td>0.364723</td>
      <td>9.462037</td>
      <td>9.2</td>
      <td>8.568120</td>
      <td>10.598911</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7bb...</td>
    </tr>
    <tr>
      <th>229</th>
      <td>Frio</td>
      <td>Texas</td>
      <td>48</td>
      <td>163</td>
      <td>48163</td>
      <td>48</td>
      <td>163</td>
      <td>48163</td>
      <td>1</td>
      <td>3.296414</td>
      <td>...</td>
      <td>1.358373</td>
      <td>0.390980</td>
      <td>0.463020</td>
      <td>0.435098</td>
      <td>0.473507</td>
      <td>14.665445</td>
      <td>9.4</td>
      <td>11.842919</td>
      <td>18.330362</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7c2...</td>
    </tr>
    <tr>
      <th>234</th>
      <td>La Salle</td>
      <td>Texas</td>
      <td>48</td>
      <td>283</td>
      <td>48283</td>
      <td>48</td>
      <td>283</td>
      <td>48283</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>1.008755</td>
      <td>0.421556</td>
      <td>0.482174</td>
      <td>0.489173</td>
      <td>0.492687</td>
      <td>18.167702</td>
      <td>14.1</td>
      <td>13.052937</td>
      <td>20.088626</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7c2...</td>
    </tr>
    <tr>
      <th>236</th>
      <td>Dimmit</td>
      <td>Texas</td>
      <td>48</td>
      <td>127</td>
      <td>48127</td>
      <td>48</td>
      <td>127</td>
      <td>48127</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.575098</td>
      <td>0.417976</td>
      <td>0.452789</td>
      <td>0.456840</td>
      <td>0.479503</td>
      <td>13.826043</td>
      <td>10.1</td>
      <td>10.944363</td>
      <td>17.769080</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7c2...</td>
    </tr>
    <tr>
      <th>239</th>
      <td>Webb</td>
      <td>Texas</td>
      <td>48</td>
      <td>479</td>
      <td>48479</td>
      <td>48</td>
      <td>479</td>
      <td>48479</td>
      <td>1</td>
      <td>2.057899</td>
      <td>...</td>
      <td>0.117083</td>
      <td>0.382594</td>
      <td>0.443082</td>
      <td>0.439100</td>
      <td>0.461075</td>
      <td>20.292824</td>
      <td>15.5</td>
      <td>17.419676</td>
      <td>20.521271</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7c2...</td>
    </tr>
    <tr>
      <th>242</th>
      <td>Duval</td>
      <td>Texas</td>
      <td>48</td>
      <td>131</td>
      <td>48131</td>
      <td>48</td>
      <td>131</td>
      <td>48131</td>
      <td>1</td>
      <td>2.487934</td>
      <td>...</td>
      <td>0.092894</td>
      <td>0.370217</td>
      <td>0.427660</td>
      <td>0.421041</td>
      <td>0.458937</td>
      <td>15.829478</td>
      <td>13.2</td>
      <td>12.803677</td>
      <td>20.699881</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7fd6cc7c2...</td>
    </tr>
  </tbody>
</table>
<p>10 rows × 70 columns</p>
</div>




```python
from matplotlib import colors
hmap = colors.ListedColormap(['grey', 'red'])
f, ax = plt.subplots(1, figsize=(9, 9))
tx.assign(cl=hotspots*1).plot(column='cl', categorical=True, \
        k=2, cmap=hmap, linewidth=0.1, ax=ax, \
        edgecolor='grey', legend=True)
ax.set_axis_off()
plt.show()
```


![png](04_esda_files/04_esda_54_0.png)



```python
data.HR90[coldspots]
```




    0      0.000000
    3      0.000000
    4      3.651767
    5      0.000000
    13     5.669899
    19     3.480743
    21     3.675119
    32     2.211607
    33     4.718762
    48     5.509870
    51     0.000000
    62     3.677958
    69     0.000000
    81     0.000000
    87     3.699593
    140    8.125292
    233    5.304688
    Name: HR90, dtype: float64




```python
cmap = colors.ListedColormap(['grey', 'blue'])
f, ax = plt.subplots(1, figsize=(9, 9))
tx.assign(cl=coldspots*1).plot(column='cl', categorical=True, \
        k=2, cmap=cmap, linewidth=0.1, ax=ax, \
        edgecolor='black', legend=True)
ax.set_axis_off()
plt.show()

```


![png](04_esda_files/04_esda_56_0.png)



```python
from matplotlib import colors
hcmap = colors.ListedColormap(['grey', 'red','blue'])
hotcold = hotspots*1 + coldspots*2
f, ax = plt.subplots(1, figsize=(9, 9))
tx.assign(cl=hotcold).plot(column='cl', categorical=True, \
        k=2, cmap=hcmap,linewidth=0.1, ax=ax, \
        edgecolor='black', legend=True)
ax.set_axis_off()
plt.show()
```


![png](04_esda_files/04_esda_57_0.png)



```python
sns.kdeplot(data.HR90)
```

    /home/serge/anaconda2/envs/gds-scipy16/lib/python3.5/site-packages/statsmodels/nonparametric/kdetools.py:20: VisibleDeprecationWarning: using a non-integer number instead of an integer will result in an error in the future
      y = X[:m/2+1] + np.r_[0,X[m/2+1:],0]*1j





    <matplotlib.axes._subplots.AxesSubplot at 0x7fd6ccc17358>




![png](04_esda_files/04_esda_58_2.png)



```python
sns.kdeplot(data.HR90)
sns.kdeplot(data.HR80)
sns.kdeplot(data.HR70)
sns.kdeplot(data.HR60)
```

    /home/serge/anaconda2/envs/gds-scipy16/lib/python3.5/site-packages/statsmodels/nonparametric/kdetools.py:20: VisibleDeprecationWarning: using a non-integer number instead of an integer will result in an error in the future
      y = X[:m/2+1] + np.r_[0,X[m/2+1:],0]*1j





    <matplotlib.axes._subplots.AxesSubplot at 0x7fd6da838908>




![png](04_esda_files/04_esda_59_2.png)



```python
data.HR90.mean()
```




    8.302494460285041




```python
data.HR90.median()
```




    7.23234613355



## Exercises

1. Repeat the global analysis for the years 1960, 70, 80 and compare the results to what we found in 1990.
2. The local analysis can also be repeated for the other decades. How many counties are hot spots in each of the periods?
3. The recent [Brexit vote](http://www.bbc.com/news/uk-politics-32810887) provides a timely example where local spatial autocorrelation analysis can provide interesting insights.  One [local analysis of the vote to leave](https://gist.github.com/darribas/691ad184280590d1219ffcf9a1678030) has recently been repored. Extend this to do an analysis of the attribute `Pct_remain`. Do the hot spots for the leave vote concord with the cold spots for the remain vote?
