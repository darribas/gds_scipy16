
#  Spatial Clustering

> [`IPYNB`](../content/part2/07_spatial_clustering.ipynb)

> **NOTE**: much of this material has been ported and adapted from "Lab 8" in [Arribas-Bel (2016)](http://darribas.org/gds15).

This notebook covers a brief introduction to spatial regression. To demonstrate this, we will use a dataset of all the AirBnb listings in the city of Austin (check the Data section for more information about the dataset).

Many questions and topics are complex phenomena that involve several dimensions and are hard to summarize into a single variable. In statistical terms, we call this family of problems *multivariate*, as oposed to *univariate* cases where only a single variable is considered in the analysis. Clustering tackles this kind of questions by reducing their dimensionality -the number of relevant variables the analyst needs to look at- and converting it into a more intuitive set of classes that even non-technical audiences can look at and make sense of. For this reason, it is widely use in applied contexts such as policymaking or marketing. In addition, since these methods do not require many preliminar assumptions about the structure of the data, it is a commonly used exploratory tool, as it can quickly give clues about the shape, form and content of a dataset.

The core idea of statistical clustering is to summarize the information contained in several variables by creating a relatively small number of categories. Each observation in the dataset is then assigned to one, and only one, category depending on its values for the variables originally considered in the classification. If done correctly, the exercise reduces the complexity of a multi-dimensional problem while retaining all the meaningful information contained in the original dataset. This is because, once classified, the analyst only needs to look at in which category every observation falls into, instead of considering the multiple values associated with each of the variables and trying to figure out how to put them together in a coherent sense. When the clustering is performed on observations that represent areas, the technique is often called geodemographic analysis.

The basic premise of the exercises we will be doing in this notebook is that, through the characteristics of the houses listed in AirBnb, we can learn about the geography of Austin. In particular, we will try to classify the city's zipcodes into a small number of groups that will allow us to extract some patterns about the main kinds of houses and areas in the city.

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
from sklearn import cluster
from sklearn.preprocessing import scale

sns.set(style="whitegrid")
```

Let us also set the paths to all the files we will need throughout the tutorial:


```python
# Adjust this to point to the right file in your computer
abb_link = '../data/listings.csv.gz'
zc_link = '../data/Zipcodes.geojson'
```

Before anything, let us load the main dataset:


```python
lst = pd.read_csv(abb_link)
```

Originally, this is provided at the individual level. Since we will be working in terms of neighborhoods and areas, we will need to aggregate them to that level. For this illustration, we will be using the following subset of variables:


```python
varis = ['bedrooms', 'bathrooms', 'beds']
```

This will allow us to capture the main elements that describe the "look and feel" of a property and, by aggregation, of an area or neighborhood. All of the variables above are numerical values, so a sensible way to aggregate them is by obtaining the average (of bedrooms, etc.) per zipcode.


```python
aves = lst.groupby('zipcode')[varis].mean()
aves.info()
```

    <class 'pandas.core.frame.DataFrame'>
    Float64Index: 47 entries, 33558.0 to 78759.0
    Data columns (total 3 columns):
    bedrooms     47 non-null float64
    bathrooms    47 non-null float64
    beds         47 non-null float64
    dtypes: float64(3)
    memory usage: 1.5 KB


In addition to these variables, it would be good to include also a sense of what proportions of different types of houses each zipcode has. For example, one can imagine that neighborhoods with a higher proportion of condos than single-family homes will probably look and feel more urban. To do this, we need to do some data munging:


```python
types = pd.get_dummies(lst['property_type'])
prop_types = types.join(lst['zipcode'])\
                  .groupby('zipcode')\
                  .sum()
prop_types_pct = (prop_types * 100.).div(prop_types.sum(axis=1), axis=0)
prop_types_pct.info()
```

    <class 'pandas.core.frame.DataFrame'>
    Float64Index: 47 entries, 33558.0 to 78759.0
    Data columns (total 18 columns):
    Apartment          47 non-null float64
    Bed & Breakfast    47 non-null float64
    Boat               47 non-null float64
    Bungalow           47 non-null float64
    Cabin              47 non-null float64
    Camper/RV          47 non-null float64
    Chalet             47 non-null float64
    Condominium        47 non-null float64
    Earth House        47 non-null float64
    House              47 non-null float64
    Hut                47 non-null float64
    Loft               47 non-null float64
    Other              47 non-null float64
    Tent               47 non-null float64
    Tipi               47 non-null float64
    Townhouse          47 non-null float64
    Treehouse          47 non-null float64
    Villa              47 non-null float64
    dtypes: float64(18)
    memory usage: 7.0 KB


Now we bring both sets of variables together:


```python
aves_props = aves.join(prop_types_pct)
```

And since we will be feeding this into the clustering algorithm, we will first standardize the columns:


```python
db = pd.DataFrame(\
                 scale(aves_props), \
                 index=aves_props.index, \
                 columns=aves_props.columns)\
       .rename(lambda x: str(int(x)))
```

Now let us bring geography in:


```python
zc = gpd.read_file(zc_link)
zc.plot(color='red');
```


![png](07_spatial_clustering_files/07_spatial_clustering_18_0.png)


And combine the two:


```python
zdb = zc[['geometry', 'zipcode', 'name']].join(db, on='zipcode')\
                                         .dropna()
```

To get a sense of which areas we have lost:


```python
f, ax = plt.subplots(1, figsize=(9, 9))

zc.plot(color='grey', linewidth=0, ax=ax)
zdb.plot(color='red', linewidth=0.1, ax=ax)

ax.set_axis_off()

plt.show()
```


![png](07_spatial_clustering_files/07_spatial_clustering_22_0.png)


## Geodemographic analysis

The main intuition behind geodemographic analysis is to group disparate areas of a city or region into a small set of classes that capture several characteristics shared by those in the same group. By doing this, we can get a new perspective not only on the types of areas in a city, but on how they are distributed over space. In the context of our AirBnb data analysis, the idea is that we can group different zipcodes of Austin based on the type of houses listed on the website. This will give us a hint into the geography of AirBnb in the Texan tech capital.

Although there exist many techniques to statistically group observations in a dataset, all of them are based on the premise of using a set of attributes to define classes or categories of observations that are similar *within* each of them, but differ *between* groups. How similarity within groups and dissimilarity between them is defined and how the classification algorithm is operationalized is what makes techniques differ and also what makes each of them particularly well suited for specific problems or types of data. As an illustration, we will only dip our toes into one of these methods, K-means, which is probably the most commonly used technique for statistical clustering.

Technically speaking, we describe the method and the parameters on the following line of code, where we specifically ask for five groups:


```python
cluster.KMeans?
```


```python
km5 = cluster.KMeans(n_clusters=5)
```

Following the `sklearn` pipeline approach, all the heavy-lifting of the clustering happens when we `fit` the model to the data:


```python
zdb
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>geometry</th>
      <th>zipcode</th>
      <th>name</th>
      <th>bedrooms</th>
      <th>bathrooms</th>
      <th>beds</th>
      <th>Apartment</th>
      <th>Bed &amp; Breakfast</th>
      <th>Boat</th>
      <th>Bungalow</th>
      <th>...</th>
      <th>Earth House</th>
      <th>House</th>
      <th>Hut</th>
      <th>Loft</th>
      <th>Other</th>
      <th>Tent</th>
      <th>Tipi</th>
      <th>Townhouse</th>
      <th>Treehouse</th>
      <th>Villa</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>(POLYGON ((-97.63657664958002 30.4026577780347...</td>
      <td>78754</td>
      <td>AUSTIN</td>
      <td>-0.558936</td>
      <td>-0.526237</td>
      <td>-0.883390</td>
      <td>-0.703645</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>1.009009</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(POLYGON ((-97.89001573769271 30.2094119733396...</td>
      <td>78739</td>
      <td>AUSTIN</td>
      <td>-0.852262</td>
      <td>-1.027555</td>
      <td>-1.016971</td>
      <td>-1.108614</td>
      <td>0.228919</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.786277</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(POLYGON ((-97.87302802996035 30.4380637200422...</td>
      <td>78732</td>
      <td>AUSTIN</td>
      <td>2.411830</td>
      <td>2.288255</td>
      <td>2.559337</td>
      <td>-0.774075</td>
      <td>-0.013034</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.602281</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>2.723296</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>5</th>
      <td>(POLYGON ((-98.01875589320069 30.2416650359924...</td>
      <td>78737</td>
      <td>AUSTIN</td>
      <td>0.491860</td>
      <td>0.343121</td>
      <td>0.302802</td>
      <td>-0.916254</td>
      <td>0.026558</td>
      <td>-0.147442</td>
      <td>6.082491</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.483998</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>2.701786</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>6</th>
      <td>(POLYGON ((-97.72792246181841 30.3290554493485...</td>
      <td>78756</td>
      <td>AUSTIN</td>
      <td>0.172221</td>
      <td>-0.179595</td>
      <td>0.493154</td>
      <td>-0.146814</td>
      <td>-0.201098</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.257288</td>
      <td>-0.147442</td>
      <td>1.093925</td>
      <td>0.262365</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>0.438393</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>7</th>
      <td>(POLYGON ((-97.66539631711731 30.2856390650983...</td>
      <td>78723</td>
      <td>AUSTIN</td>
      <td>0.809783</td>
      <td>0.576805</td>
      <td>0.511747</td>
      <td>-0.616530</td>
      <td>-0.241688</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.715979</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>1.340248</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>0.374069</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>12</th>
      <td>(POLYGON ((-97.84294910551613 30.3230986344075...</td>
      <td>78733</td>
      <td>AUSTIN</td>
      <td>0.646410</td>
      <td>0.701923</td>
      <td>0.449444</td>
      <td>-0.696414</td>
      <td>0.590277</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.354449</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>1.772483</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>14</th>
      <td>(POLYGON ((-97.77663063721972 30.3230061422016...</td>
      <td>78746</td>
      <td>AUSTIN</td>
      <td>0.709989</td>
      <td>1.036906</td>
      <td>0.699761</td>
      <td>0.503341</td>
      <td>-0.243068</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.554560</td>
      <td>-0.147442</td>
      <td>0.547089</td>
      <td>-0.187361</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>1.164644</td>
      <td>-0.242924</td>
      <td>0.350606</td>
    </tr>
    <tr>
      <th>15</th>
      <td>(POLYGON ((-97.79105326806381 30.4504847141011...</td>
      <td>78750</td>
      <td>AUSTIN</td>
      <td>0.339864</td>
      <td>1.021067</td>
      <td>0.275115</td>
      <td>-0.409123</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.731317</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>17</th>
      <td>(POLYGON ((-97.86241464122685 30.2970038099151...</td>
      <td>78735</td>
      <td>AUSTIN</td>
      <td>1.165182</td>
      <td>1.527942</td>
      <td>1.286775</td>
      <td>0.223109</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.283327</td>
      <td>-0.147442</td>
      <td>1.987258</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>24</th>
      <td>(POLYGON ((-97.736172946862 30.15986516866584,...</td>
      <td>78747</td>
      <td>AUSTIN</td>
      <td>-0.765989</td>
      <td>0.380018</td>
      <td>-0.763168</td>
      <td>-0.501161</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.818096</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>26</th>
      <td>(POLYGON ((-97.70676595120581 30.3221053986124...</td>
      <td>78751</td>
      <td>AUSTIN</td>
      <td>-0.243801</td>
      <td>-0.441587</td>
      <td>-0.180553</td>
      <td>0.245600</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>1.750125</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.045596</td>
      <td>-0.147442</td>
      <td>-0.034226</td>
      <td>-0.030366</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>28</th>
      <td>(POLYGON ((-98.00621936585073 30.3607912172675...</td>
      <td>78738</td>
      <td>AUSTIN</td>
      <td>0.786911</td>
      <td>0.412816</td>
      <td>1.521054</td>
      <td>0.430265</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.060105</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>30</th>
      <td>(POLYGON ((-97.6233816077967 30.26459422030998...</td>
      <td>78725</td>
      <td>AUSTIN</td>
      <td>0.786911</td>
      <td>0.233599</td>
      <td>-0.219306</td>
      <td>-1.108614</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>1.131739</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>4.095741</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>31</th>
      <td>(POLYGON ((-97.67105719588658 30.4713206458632...</td>
      <td>78728</td>
      <td>AUSTIN</td>
      <td>-1.180096</td>
      <td>-1.259873</td>
      <td>-1.220013</td>
      <td>0.814985</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.422841</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>32</th>
      <td>(POLYGON ((-97.70652535557282 30.2502416627252...</td>
      <td>78741</td>
      <td>AUSTIN</td>
      <td>-0.196593</td>
      <td>-0.231037</td>
      <td>-0.207449</td>
      <td>1.265189</td>
      <td>-0.262631</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-1.078851</td>
      <td>-0.147442</td>
      <td>-0.094470</td>
      <td>-0.089419</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>0.213892</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>33</th>
      <td>(POLYGON ((-97.68335342189505 30.2143231792978...</td>
      <td>78744</td>
      <td>AUSTIN</td>
      <td>0.280258</td>
      <td>0.069700</td>
      <td>0.232518</td>
      <td>-0.467414</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.566437</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>1.420474</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>36</th>
      <td>(POLYGON ((-97.76605641344037 30.3129541271378...</td>
      <td>78703</td>
      <td>AUSTIN</td>
      <td>0.520842</td>
      <td>0.435146</td>
      <td>0.602941</td>
      <td>0.424690</td>
      <td>-0.262319</td>
      <td>-0.147442</td>
      <td>0.634716</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.326462</td>
      <td>-0.147442</td>
      <td>-0.244533</td>
      <td>0.077739</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>0.050895</td>
      <td>3.600969</td>
      <td>0.044915</td>
    </tr>
    <tr>
      <th>37</th>
      <td>(POLYGON ((-97.82331016792597 30.2348601368125...</td>
      <td>78749</td>
      <td>AUSTIN</td>
      <td>0.281109</td>
      <td>0.412816</td>
      <td>0.498593</td>
      <td>-0.284214</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>1.531686</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.406269</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>0.570104</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>39</th>
      <td>(POLYGON ((-97.9221254299873 30.2930035379774,...</td>
      <td>78736</td>
      <td>AUSTIN</td>
      <td>0.505910</td>
      <td>0.333164</td>
      <td>0.324557</td>
      <td>-0.284214</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.095353</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>6.697635</td>
    </tr>
    <tr>
      <th>41</th>
      <td>(POLYGON ((-97.70394537118878 30.2825715190553...</td>
      <td>78722</td>
      <td>AUSTIN</td>
      <td>-0.497665</td>
      <td>-0.867837</td>
      <td>-0.319014</td>
      <td>-0.323471</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.613546</td>
      <td>-0.147442</td>
      <td>0.112041</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>42</th>
      <td>(POLYGON ((-97.66539631711731 30.2856390650983...</td>
      <td>78721</td>
      <td>AUSTIN</td>
      <td>0.529327</td>
      <td>-0.031907</td>
      <td>0.252042</td>
      <td>-1.017014</td>
      <td>-0.204711</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>1.174922</td>
      <td>-0.147442</td>
      <td>0.224901</td>
      <td>0.223644</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>43</th>
      <td>(POLYGON ((-97.69186077161216 30.2484769354393...</td>
      <td>78702</td>
      <td>AUSTIN</td>
      <td>0.555498</td>
      <td>0.221691</td>
      <td>0.738159</td>
      <td>-0.745581</td>
      <td>-0.262104</td>
      <td>6.782330</td>
      <td>0.179830</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.804058</td>
      <td>6.782330</td>
      <td>1.305373</td>
      <td>0.007262</td>
      <td>0.287274</td>
      <td>-0.147442</td>
      <td>0.058755</td>
      <td>-0.242924</td>
      <td>-0.069795</td>
    </tr>
    <tr>
      <th>44</th>
      <td>(POLYGON ((-97.84397384513375 30.3935729185546...</td>
      <td>78730</td>
      <td>AUSTIN</td>
      <td>2.004582</td>
      <td>2.712763</td>
      <td>1.673336</td>
      <td>0.906585</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.509206</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>45</th>
      <td>(POLYGON ((-97.73177659202942 30.5876874089334...</td>
      <td>78681</td>
      <td>ROUND ROCK</td>
      <td>-1.180096</td>
      <td>-1.259873</td>
      <td>-1.524576</td>
      <td>2.738584</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-2.236517</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>46</th>
      <td>(POLYGON ((-97.74597901667516 30.3613774432803...</td>
      <td>78731</td>
      <td>AUSTIN</td>
      <td>1.207048</td>
      <td>1.135483</td>
      <td>1.284500</td>
      <td>-0.137476</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>0.948476</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.193457</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>0.712355</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>0.747972</td>
    </tr>
    <tr>
      <th>47</th>
      <td>(POLYGON ((-97.90409880079483 30.1645969721025...</td>
      <td>78652</td>
      <td>MANCHACA</td>
      <td>-1.180096</td>
      <td>-1.259873</td>
      <td>-1.524576</td>
      <td>-1.108614</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>1.390836</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>49</th>
      <td>(POLYGON ((-97.79207307087505 30.2318294401264...</td>
      <td>78745</td>
      <td>AUSTIN</td>
      <td>0.311501</td>
      <td>-0.157419</td>
      <td>0.324885</td>
      <td>-0.539089</td>
      <td>-0.240301</td>
      <td>-0.147442</td>
      <td>0.096327</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.557969</td>
      <td>-0.147442</td>
      <td>-0.164143</td>
      <td>0.038813</td>
      <td>4.542171</td>
      <td>-0.147442</td>
      <td>-0.037916</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>50</th>
      <td>(POLYGON ((-97.83150003630331 30.1899955351445...</td>
      <td>78748</td>
      <td>AUSTIN</td>
      <td>-0.305871</td>
      <td>-0.472990</td>
      <td>-0.461022</td>
      <td>-0.803280</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.987797</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>3.341732</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>51</th>
      <td>(POLYGON ((-97.73600098711186 30.3785689883760...</td>
      <td>78757</td>
      <td>AUSTIN</td>
      <td>0.313372</td>
      <td>0.095315</td>
      <td>0.252042</td>
      <td>-0.396170</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.517584</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>0.199362</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>53</th>
      <td>(POLYGON ((-97.70739686222652 30.4748248576790...</td>
      <td>78717</td>
      <td>AUSTIN</td>
      <td>-1.180096</td>
      <td>-0.795237</td>
      <td>-1.016971</td>
      <td>0.173786</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.181718</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>54</th>
      <td>(POLYGON ((-97.72137830361672 30.4735808118949...</td>
      <td>78729</td>
      <td>AUSTIN</td>
      <td>-0.618094</td>
      <td>-0.662484</td>
      <td>-0.763168</td>
      <td>0.127986</td>
      <td>-0.060168</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.163744</td>
      <td>-0.147442</td>
      <td>1.804945</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>2.150639</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>55</th>
      <td>(POLYGON ((-98.12139104830618 30.3647789869612...</td>
      <td>78620</td>
      <td>DRIPPING SPRINGS</td>
      <td>-1.180096</td>
      <td>-1.259873</td>
      <td>-0.001761</td>
      <td>-1.108614</td>
      <td>5.793836</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-2.236517</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>56</th>
      <td>(POLYGON ((-97.7544731627255 30.26506651013847...</td>
      <td>78704</td>
      <td>AUSTIN</td>
      <td>0.353945</td>
      <td>0.045476</td>
      <td>0.408821</td>
      <td>0.317084</td>
      <td>-0.269318</td>
      <td>-0.147442</td>
      <td>0.033138</td>
      <td>...</td>
      <td>6.782330</td>
      <td>-0.225901</td>
      <td>-0.147442</td>
      <td>0.440362</td>
      <td>-0.181166</td>
      <td>-0.270496</td>
      <td>6.782330</td>
      <td>0.727093</td>
      <td>1.766384</td>
      <td>-0.066215</td>
    </tr>
    <tr>
      <th>57</th>
      <td>(POLYGON ((-97.68634026954943 30.3325933205724...</td>
      <td>78752</td>
      <td>AUSTIN</td>
      <td>-0.161881</td>
      <td>-0.705669</td>
      <td>-0.368704</td>
      <td>-0.203391</td>
      <td>0.365810</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.067919</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>59</th>
      <td>(POLYGON ((-97.56072444145862 30.2490283208835...</td>
      <td>78724</td>
      <td>AUSTIN</td>
      <td>0.786911</td>
      <td>1.152659</td>
      <td>0.642507</td>
      <td>-1.108614</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>1.111809</td>
      <td>-0.147442</td>
      <td>1.987258</td>
      <td>1.951195</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>61</th>
      <td>(POLYGON ((-97.92086446378035 30.4349563110724...</td>
      <td>78734</td>
      <td>AUSTIN</td>
      <td>2.332417</td>
      <td>2.921850</td>
      <td>2.880710</td>
      <td>-0.971214</td>
      <td>-0.060168</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.872643</td>
      <td>-0.147442</td>
      <td>1.804945</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>62</th>
      <td>(POLYGON ((-97.85677348291654 30.1304340182730...</td>
      <td>78610</td>
      <td>BUDA</td>
      <td>-1.180096</td>
      <td>-1.259873</td>
      <td>-1.524576</td>
      <td>2.738584</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-2.236517</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>66</th>
      <td>(POLYGON ((-97.67150729716587 30.4243750876293...</td>
      <td>78753</td>
      <td>AUSTIN</td>
      <td>-0.280893</td>
      <td>-0.152946</td>
      <td>-0.480360</td>
      <td>-0.009414</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.147172</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>3.731173</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>69</th>
      <td>(POLYGON ((-97.8258020623902 30.45545039884336...</td>
      <td>78726</td>
      <td>AUSTIN</td>
      <td>-0.056092</td>
      <td>-0.662484</td>
      <td>-0.436851</td>
      <td>-0.009414</td>
      <td>3.192057</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-1.718324</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>70</th>
      <td>(POLYGON ((-97.57652979651098 30.5008564155205...</td>
      <td>78660</td>
      <td>PFLUGERVILLE</td>
      <td>-1.180096</td>
      <td>-1.259873</td>
      <td>-1.524576</td>
      <td>2.738584</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-2.236517</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>74</th>
      <td>(POLYGON ((-97.72977818013679 30.2987072033635...</td>
      <td>78705</td>
      <td>AUSTIN</td>
      <td>-0.561441</td>
      <td>-0.574160</td>
      <td>-0.505272</td>
      <td>1.507481</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-1.278896</td>
      <td>-0.147442</td>
      <td>0.496669</td>
      <td>-0.290571</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.188552</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>75</th>
      <td>(POLYGON ((-97.747440320186 30.42161819776979,...</td>
      <td>78759</td>
      <td>AUSTIN</td>
      <td>-0.726172</td>
      <td>-0.599601</td>
      <td>-0.938878</td>
      <td>0.864308</td>
      <td>-0.121321</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.934390</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>-0.550776</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>3.298890</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>76</th>
      <td>(POLYGON ((-97.69729138340391 30.4400371609576...</td>
      <td>78727</td>
      <td>TRAVIS</td>
      <td>-0.501818</td>
      <td>-0.538886</td>
      <td>-0.946956</td>
      <td>-0.445304</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>0.640349</td>
      <td>-0.147442</td>
      <td>-0.565121</td>
      <td>1.692370</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>77</th>
      <td>(POLYGON ((-97.71223026174552 30.3480047024702...</td>
      <td>78758</td>
      <td>AUSTIN</td>
      <td>-0.406192</td>
      <td>-0.414388</td>
      <td>-0.126582</td>
      <td>0.531175</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-0.333643</td>
      <td>-0.147442</td>
      <td>1.610678</td>
      <td>-0.550776</td>
      <td>3.460166</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>-0.242924</td>
      <td>-0.187930</td>
    </tr>
    <tr>
      <th>78</th>
      <td>(POLYGON ((-97.73598800490392 30.2510129132375...</td>
      <td>78701</td>
      <td>AUSTIN</td>
      <td>-0.162204</td>
      <td>-0.197384</td>
      <td>0.264466</td>
      <td>1.501024</td>
      <td>-0.276983</td>
      <td>-0.147442</td>
      <td>-0.288636</td>
      <td>...</td>
      <td>-0.147442</td>
      <td>-1.729195</td>
      <td>-0.147442</td>
      <td>4.075569</td>
      <td>-0.095872</td>
      <td>-0.270496</td>
      <td>-0.147442</td>
      <td>-0.483586</td>
      <td>5.321313</td>
      <td>-0.187930</td>
    </tr>
  </tbody>
</table>
<p>46 rows × 24 columns</p>
</div>




```python
km5cls = km5.fit(zdb.drop(['geometry', 'name'], axis=1).values)
```

Now we can extract the classes and put them on a map:


```python
f, ax = plt.subplots(1, figsize=(9, 9))

zdb.assign(cl=km5cls.labels_)\
   .plot(column='cl', categorical=True, legend=True, \
         linewidth=0.1, edgecolor='white', ax=ax)

ax.set_axis_off()

plt.show()
```


![png](07_spatial_clustering_files/07_spatial_clustering_30_0.png)


The map above shows a clear pattern: there is a class at the core of the city (number 0, in red), then two other ones in a sort of "urban ring" (number 1 and 3, in green and brown, respectively), and two peripheral sets of areas (number 2 and 4, yellow and green).

This gives us a good insight into the geographical structure, but does not tell us much about what are the defining elements of these groups. To do that, we can have a peak into the characteristics of the classes. For example, let us look at how the proportion of different types of properties are distributed across clusters:


```python
cl_pcts = prop_types_pct.rename(lambda x: str(int(x)))\
                          .reindex(zdb['zipcode'])\
                          .assign(cl=km5cls.labels_)\
                          .groupby('cl')\
                          .mean()
```


```python
f, ax = plt.subplots(1, figsize=(18, 9))
cl_pcts.plot(kind='barh', stacked=True, ax=ax, \
             cmap='Set2', linewidth=0)
ax.legend(ncol=1, loc="right");
```


![png](07_spatial_clustering_files/07_spatial_clustering_33_0.png)


A few interesting, albeit maybe not completely unsurprising, characteristics stand out. First, most of the locations we have in the dataset are either apartments or houses. However, how they are distributed is interesting. The urban core -cluster 0- distinctively has the highest proportion of condos and lofts. The suburban ring -clusters 1 and 3- is very consistent, with a large share of houses and less apartments, particularly so in the case of cluster 3. Class 4 has only two types of properties, houses and apartments, suggesting there are not that many places listed at AirBnb. Finally, class 3 arises as a more rural and leisure one: beyond apartments, it has a large share of bed & breakfasts.

**Mini Exercise**

> *What are the average number of beds, bedrooms and bathrooms for every class?*

## Regionalization analysis: building (meaningful) regions

In the case of analysing spatial data, there is a subset of methods that are of particular interest for many common cases in Geographic Data Science. These are the so-called regionalization techniques. Regionalization methods can take also many forms and faces but, at their core, they all involve statistical clustering of observations with the additional constraint that observations need to be geographical neighbors to be in the same category. Because of this, rather than category, we will use the term area for each observation and region for each class or cluster -hence regionalization, the construction of regions from smaller areas.

As in the non-spatial case, there are many different algorithms to perform regionalization, and they all differ on details relating to the way they measure (dis)similarity, the process to regionalize, etc. However, same as above too, they all share a few common aspects. In particular, they all take a set of input attributes *and* a representation of space in the form of a binary spatial weights matrix. Depending on the algorithm, they also require the desired number of output regions into which the areas are aggregated.

In this example, we are going to create aggregations of zipcodes into groups that have areas where the AirBnb listed location have similar ratings. In other words, we will create delineations for the "quality" or "satisfaction" of AirBnb users. In other words, we will explore what are the boundaries that separate areas where AirBnb users tend to be satisfied about their experience versus those where the ratings are not as high. To do this, we will focus on the `review_scores_X` set of variables in the original dataset:


```python
ratings = [i for i in lst if 'review_scores_' in i]
ratings
```




    ['review_scores_rating',
     'review_scores_accuracy',
     'review_scores_cleanliness',
     'review_scores_checkin',
     'review_scores_communication',
     'review_scores_location',
     'review_scores_value']



Similarly to the case above, we now bring this at the zipcode level. Note that, since they are all scores that range from 0 to 100, we can use averages and we do not need to standardize.


```python
rt_av = lst.groupby('zipcode')[ratings]\
           .mean()\
           .rename(lambda x: str(int(x)))
```

And we link these to the geometries of zipcodes:


```python
zrt = zc[['geometry', 'zipcode']].join(rt_av, on='zipcode')\
                                 .dropna()
zrt.info()
```

    <class 'geopandas.geodataframe.GeoDataFrame'>
    Int64Index: 43 entries, 0 to 78
    Data columns (total 9 columns):
    geometry                       43 non-null object
    zipcode                        43 non-null object
    review_scores_rating           43 non-null float64
    review_scores_accuracy         43 non-null float64
    review_scores_cleanliness      43 non-null float64
    review_scores_checkin          43 non-null float64
    review_scores_communication    43 non-null float64
    review_scores_location         43 non-null float64
    review_scores_value            43 non-null float64
    dtypes: float64(7), object(2)
    memory usage: 3.4+ KB


In contrast to the standard clustering techniques, regionalization requires a formal representation of topology. This is so the algorithm can impose spatial constraints during the process of clustering the observations. We will use exactly the same approach as in the previous sections of this tutorial for this and build spatial weights objects `W` with `PySAL`. For the sake of this illustration, we will consider queen contiguity, but any other rule should work fine as long as there is a rational behind it. Weights constructors currently only work from shapefiles on disk, so we will write our `GeoDataFrame` first, then create the `W` object, and remove the files.


```python
zrt.to_file('tmp')
w = ps.queen_from_shapefile('tmp/tmp.shp', idVariable='zipcode')
# NOTE: this might not work on Windows
! rm -r tmp
w
```




    <pysal.weights.weights.W at 0x11bd5ff98>



Now we are ready to run the regionalization algorithm. In this case we will use the `max-p` ([Duque, Anselin & Rey, 2012)](http://onlinelibrary.wiley.com/doi/10.1111/j.1467-9787.2011.00743.x/abstract), which does not require a predefined number of output regions but instead it takes a target variable that you want to make sure a minimum threshold is met. In our case, since it is based on ratings, we will impose that every resulting region has at least 10% of the total number of reviews. Let us work through what that would mean:


```python
n_rev = lst.groupby('zipcode')\
           .sum()\
           ['number_of_reviews']\
           .rename(lambda x: str(int(x)))\
           .reindex(zrt['zipcode'])
thr = np.round(0.1 * n_rev.sum())
thr
```




    6271.0



This means we want every resulting region to be based on at least 6,271 reviews. Now we have all the pieces, let us glue them together through the algorithm:


```python
# Set the seed for reproducibility
np.random.seed(1234)

z = zrt.drop(['geometry', 'zipcode'], axis=1).values
maxp = ps.region.Maxp(w, z, thr, n_rev.values[:, None], initial=1000)
```

We can check whether the solution is better (lower within sum of squares) than we would have gotten from a purely random regionalization process using the [`cinference`](http://pysal.readthedocs.io/en/latest/library/region/maxp.html#pysal.region.maxp.Maxp.cinference) method:


```python
%%time
np.random.seed(1234)
maxp.cinference(nperm=999)
```

    CPU times: user 26.2 s, sys: 185 ms, total: 26.4 s
    Wall time: 32.1 s


Which allows us to obtain an empirical p-value:


```python
maxp.cpvalue
```




    0.022



Which gives us reasonably good confidence that the solution we obtain is more meaningful than pure chance. 

With that out of the way, let us see what the result looks like on a map! First we extract the labels:


```python
lbls = pd.Series(maxp.area2region).reindex(zrt['zipcode'])
```


```python
f, ax = plt.subplots(1, figsize=(9, 9))

zrt.assign(cl=lbls.values)\
   .plot(column='cl', categorical=True, legend=True, \
         linewidth=0.1, edgecolor='white', ax=ax)

ax.set_axis_off()

plt.show()
```


![png](07_spatial_clustering_files/07_spatial_clustering_53_0.png)


The map shows a clear geographical pattern with a western area, another in the North and a smaller one in the East. Let us unpack what each of them is made of:


```python
zrt[ratings].groupby(lbls.values).mean().T
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>review_scores_rating</th>
      <td>96.911817</td>
      <td>95.326614</td>
      <td>92.502135</td>
      <td>96.174762</td>
      <td>94.418213</td>
    </tr>
    <tr>
      <th>review_scores_accuracy</th>
      <td>9.767500</td>
      <td>9.605032</td>
      <td>9.548751</td>
      <td>9.607459</td>
      <td>9.566245</td>
    </tr>
    <tr>
      <th>review_scores_cleanliness</th>
      <td>9.678277</td>
      <td>9.558179</td>
      <td>8.985408</td>
      <td>9.599824</td>
      <td>9.520539</td>
    </tr>
    <tr>
      <th>review_scores_checkin</th>
      <td>9.922450</td>
      <td>9.797086</td>
      <td>9.765563</td>
      <td>9.889927</td>
      <td>9.754648</td>
    </tr>
    <tr>
      <th>review_scores_communication</th>
      <td>9.932211</td>
      <td>9.827390</td>
      <td>9.794794</td>
      <td>9.898785</td>
      <td>9.772752</td>
    </tr>
    <tr>
      <th>review_scores_location</th>
      <td>9.644754</td>
      <td>9.548761</td>
      <td>8.904775</td>
      <td>9.596744</td>
      <td>9.412052</td>
    </tr>
    <tr>
      <th>review_scores_value</th>
      <td>9.678822</td>
      <td>9.341224</td>
      <td>9.491638</td>
      <td>9.614187</td>
      <td>9.462490</td>
    </tr>
  </tbody>
</table>
</div>



Although very similar, there are some patterns to be extracted. For example, the East area seems to have lower overall scores.

## Exercise

> *Obtain a geodemographic classification with eight classes instead of five and replicate the analysis above*

> *Re-run the regionalization exercise imposing a minimum of 5% reviews per area*
