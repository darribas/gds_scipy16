
# Spatial Weights

> [`IPYNB`](../content/part1/03_spatial_weights.ipynb)


Spatial weights are mathematical structures used to represent spatial relationships. Many spatial analytics, such as spatial autocorrelation statistics and regionalization algorithms rely on spatial weights. Generally speaking, a spatial weight $w_{i,j}$ expresses the notion of a geographical relationship between locations $i$ and $j$. These relationships can be based on a number of criteria including contiguity, geospatial distance and general distances.

PySAL offers functionality for the construction, manipulation, analysis, and conversion of a wide array of spatial weights.

We begin with construction of weights from common spatial data formats.



```python
import pysal as ps
import numpy as np
```

There are functions to construct weights directly from a file path. 


```python
shp_path = "../data/texas.shp"
```

## Weight Types

### Contiguity: 
#### Queen Weights

A commonly-used type of weight is a queen contigutiy weight, which reflects adjacency relationships as a binary indicator variable denoting whether or not a polygon shares an edge or a vertex with another polygon. These weights are symmetric, in that when polygon $A$ neighbors polygon $B$, both $w_{AB} = 1$ and $w_{BA} = 1$.

To construct queen weights from a shapefile, use the `queen_from_shapefile` function:


```python
qW = ps.queen_from_shapefile(shp_path)
dataframe = ps.pdio.read_files(shp_path)
```


```python
qW
```




    <pysal.weights.weights.W at 0x104142860>



All weights objects have a few traits that you can use to work with the weights object, as well as to get information about the weights object. 

To get the neighbors & weights around an observation, use the observation's index on the weights object, like a dictionary:


```python
qW[4] #neighbors & weights of the 5th observation (0-index remember)
```




    {0: 1.0, 3: 1.0, 5: 1.0, 6: 1.0, 7: 1.0}



By default, the weights and the pandas dataframe will use the same index. So, we can view the observation and its neighbors in the dataframe by putting the observation's index and its neighbors' indexes together in one list:


```python
self_and_neighbors = [4]
self_and_neighbors.extend(qW.neighbors[4])
print(self_and_neighbors)
```

    [4, 0, 3, 5, 6, 7]


and grabbing those elements from the dataframe:


```python
dataframe.loc[self_and_neighbors]
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
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91efd0&gt;</td>
    </tr>
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
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee10&gt;</td>
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
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ef60&gt;</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Roberts</td>
      <td>Texas</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.000000</td>
      <td>0.320275</td>
      <td>0.318656</td>
      <td>0.398681</td>
      <td>0.339626</td>
      <td>5.762712</td>
      <td>5.3</td>
      <td>6.231454</td>
      <td>4.885993</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b080&gt;</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Hemphill</td>
      <td>Texas</td>
      <td>48</td>
      <td>211</td>
      <td>48211</td>
      <td>48</td>
      <td>211</td>
      <td>48211</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.188172</td>
      <td>0.286707</td>
      <td>0.385605</td>
      <td>0.352996</td>
      <td>0.346318</td>
      <td>6.300115</td>
      <td>6.9</td>
      <td>6.451613</td>
      <td>6.330366</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b0f0&gt;</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Hutchinson</td>
      <td>Texas</td>
      <td>48</td>
      <td>233</td>
      <td>48233</td>
      <td>48</td>
      <td>233</td>
      <td>48233</td>
      <td>1</td>
      <td>1.936915</td>
      <td>...</td>
      <td>2.635369</td>
      <td>0.199287</td>
      <td>0.322579</td>
      <td>0.323864</td>
      <td>0.370207</td>
      <td>5.387316</td>
      <td>5.1</td>
      <td>6.222679</td>
      <td>8.484271</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b160&gt;</td>
    </tr>
  </tbody>
</table>
<p>6 rows × 70 columns</p>
</div>



A full, dense matrix describing all of the pairwise relationships is constructed using the `.full` method, or when `pysal.full` is called on a weights object:


```python
Wmatrix, ids = qW.full()
#Wmatrix, ids = ps.full(qW)
```


```python
Wmatrix
```




    array([[ 0.,  0.,  0., ...,  0.,  0.,  0.],
           [ 0.,  0.,  1., ...,  0.,  0.,  0.],
           [ 0.,  1.,  0., ...,  0.,  0.,  0.],
           ..., 
           [ 0.,  0.,  0., ...,  0.,  1.,  1.],
           [ 0.,  0.,  0., ...,  1.,  0.,  1.],
           [ 0.,  0.,  0., ...,  1.,  1.,  0.]])




```python
n_neighbors = Wmatrix.sum(axis=1) # how many neighbors each region has
```


```python
n_neighbors[4]
```




    5.0




```python
qW.cardinalities[4]
```




    5



Note that this matrix is binary, in that its elements are either zero or one, since an observation is either a neighbor or it is not a neighbor. 

However, many common use cases of spatial weights require that the matrix is row-standardized. This is done simply in PySAL using the `.transform` attribute


```python
qW.transform = 'r'
```

Now, if we build a new full matrix, its rows should sum to one:


```python
Wmatrix, ids = qW.full()
```


```python
Wmatrix.sum(axis=1) #numpy axes are 0:column, 1:row, 2:facet, into higher dimensions
```




    array([ 1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,  1.,
            1.,  1.,  1.,  1.,  1.,  1.,  1.])



Since weight matrices are typically very sparse, there is also a sparse weights matrix constructor:


```python
qW.sparse
```




    <254x254 sparse matrix of type '<class 'numpy.float64'>'
    	with 1460 stored elements in Compressed Sparse Row format>




```python
qW.pct_nonzero #Percentage of nonzero neighbor counts
```




    2.263004526009052



By default, PySAL assigns each observation an index according to the order in which the observation was read in. This means that, by default, all of the observations in the weights object are indexed by table order. If you have an alternative ID variable, you can pass that into the weights constructor. 

For example, the `texas.shp` dataset has a possible alternative ID Variable, a `FIPS` code.


```python
dataframe.head()
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee10&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee80&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91eef0&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ef60&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91efd0&gt;</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 70 columns</p>
</div>



The observation we were discussing above is in the fifth row: Ochiltree county, Texas. Note that its FIPS code is 48357.

Then, instead of indexing the weights and the dataframe just based on read-order, use the `FIPS` code as an index:


```python
qW = ps.queen_from_shapefile(shp_path, idVariable='FIPS')
```


```python
qW[4] #fails, since no FIPS is 4. 
```


    ---------------------------------------------------------------------------

    KeyError                                  Traceback (most recent call last)

    <ipython-input-21-1d8a3009bc1e> in <module>()
    ----> 1 qW[4] #fails, since no FIPS is 4.
    

    /Users/dani/anaconda/envs/gds-scipy16/lib/python3.5/site-packages/pysal/weights/weights.py in __getitem__(self, key)
        504         {1: 1.0, 4: 1.0, 101: 1.0, 85: 1.0, 5: 1.0}
        505         """
    --> 506         return dict(list(zip(self.neighbors[key], self.weights[key])))
        507 
        508     def __iter__(self):


    KeyError: 4


Note that a `KeyError` in Python usually means that some index, here `4`, was not found in the collection being searched, the IDs in the queen weights object. This makes sense, since we explicitly passed an `idVariable` argument, and nothing has a `FIPS` code of 4.

Instead, if we use the observation's `FIPS` code:


```python
qW['48357']
```




    {'48195': 1.0, '48211': 1.0, '48233': 1.0, '48295': 1.0, '48393': 1.0}



We get what we need.

In addition, we have to now query the dataframe using the `FIPS` code to find our neighbors. But, this is relatively easy to do, since pandas will parse the query by looking into python objects, if told to. 

First, let us store the neighbors of our target county:


```python
self_and_neighbors = ['48357']
self_and_neighbors.extend(qW.neighbors['48357'])
```

Then, we can use this list in `.query`: 


```python
dataframe.query('FIPS in @self_and_neighbors')
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
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee10&gt;</td>
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
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ef60&gt;</td>
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
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91efd0&gt;</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Roberts</td>
      <td>Texas</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.000000</td>
      <td>0.320275</td>
      <td>0.318656</td>
      <td>0.398681</td>
      <td>0.339626</td>
      <td>5.762712</td>
      <td>5.3</td>
      <td>6.231454</td>
      <td>4.885993</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b080&gt;</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Hemphill</td>
      <td>Texas</td>
      <td>48</td>
      <td>211</td>
      <td>48211</td>
      <td>48</td>
      <td>211</td>
      <td>48211</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.188172</td>
      <td>0.286707</td>
      <td>0.385605</td>
      <td>0.352996</td>
      <td>0.346318</td>
      <td>6.300115</td>
      <td>6.9</td>
      <td>6.451613</td>
      <td>6.330366</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b0f0&gt;</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Hutchinson</td>
      <td>Texas</td>
      <td>48</td>
      <td>233</td>
      <td>48233</td>
      <td>48</td>
      <td>233</td>
      <td>48233</td>
      <td>1</td>
      <td>1.936915</td>
      <td>...</td>
      <td>2.635369</td>
      <td>0.199287</td>
      <td>0.322579</td>
      <td>0.323864</td>
      <td>0.370207</td>
      <td>5.387316</td>
      <td>5.1</td>
      <td>6.222679</td>
      <td>8.484271</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b160&gt;</td>
    </tr>
  </tbody>
</table>
<p>6 rows × 70 columns</p>
</div>



Note that we have to use `@` before the name in order to show that we're referring to a python object and not a column in the dataframe. 


```python
#dataframe.query('FIPS in self_and_neighbors') will fail because there is no column called 'self_and_neighbors'
```

Of course, we could also reindex the dataframe to use the same index as our weights:


```python
fips_frame = dataframe.set_index(dataframe.FIPS)
fips_frame.head()
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
    <tr>
      <th>FIPS</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>48295</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee10&gt;</td>
    </tr>
    <tr>
      <th>48421</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee80&gt;</td>
    </tr>
    <tr>
      <th>48111</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91eef0&gt;</td>
    </tr>
    <tr>
      <th>48195</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ef60&gt;</td>
    </tr>
    <tr>
      <th>48357</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91efd0&gt;</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 70 columns</p>
</div>



Now that both are using the same weights, we can use the `.loc` indexer again:


```python
fips_frame.loc[self_and_neighbors]
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
    <tr>
      <th>FIPS</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>48357</th>
      <td>Ochiltree</td>
      <td>Texas</td>
      <td>48</td>
      <td>357</td>
      <td>48357</td>
      <td>48</td>
      <td>357</td>
      <td>48357</td>
      <td>1</td>
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91efd0&gt;</td>
    </tr>
    <tr>
      <th>48295</th>
      <td>Lipscomb</td>
      <td>Texas</td>
      <td>48</td>
      <td>295</td>
      <td>48295</td>
      <td>48</td>
      <td>295</td>
      <td>48295</td>
      <td>1</td>
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee10&gt;</td>
    </tr>
    <tr>
      <th>48195</th>
      <td>Hansford</td>
      <td>Texas</td>
      <td>48</td>
      <td>195</td>
      <td>48195</td>
      <td>48</td>
      <td>195</td>
      <td>48195</td>
      <td>1</td>
      <td>0.000000</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ef60&gt;</td>
    </tr>
    <tr>
      <th>48393</th>
      <td>Roberts</td>
      <td>Texas</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.000000</td>
      <td>0.320275</td>
      <td>0.318656</td>
      <td>0.398681</td>
      <td>0.339626</td>
      <td>5.762712</td>
      <td>5.3</td>
      <td>6.231454</td>
      <td>4.885993</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b080&gt;</td>
    </tr>
    <tr>
      <th>48211</th>
      <td>Hemphill</td>
      <td>Texas</td>
      <td>48</td>
      <td>211</td>
      <td>48211</td>
      <td>48</td>
      <td>211</td>
      <td>48211</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.188172</td>
      <td>0.286707</td>
      <td>0.385605</td>
      <td>0.352996</td>
      <td>0.346318</td>
      <td>6.300115</td>
      <td>6.9</td>
      <td>6.451613</td>
      <td>6.330366</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b0f0&gt;</td>
    </tr>
    <tr>
      <th>48233</th>
      <td>Hutchinson</td>
      <td>Texas</td>
      <td>48</td>
      <td>233</td>
      <td>48233</td>
      <td>48</td>
      <td>233</td>
      <td>48233</td>
      <td>1</td>
      <td>1.936915</td>
      <td>...</td>
      <td>2.635369</td>
      <td>0.199287</td>
      <td>0.322579</td>
      <td>0.323864</td>
      <td>0.370207</td>
      <td>5.387316</td>
      <td>5.1</td>
      <td>6.222679</td>
      <td>8.484271</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b160&gt;</td>
    </tr>
  </tbody>
</table>
<p>6 rows × 70 columns</p>
</div>



#### Rook Weights

Rook weights are another type of contiguity weight, but consider observations as neighboring only when they share an edge. The rook neighbors of an observation may be different than its queen neighbors, depending on how the observation and its nearby polygons are configured. 

We can construct this in the same way as the queen weights, using the special `rook_from_shapefile` function:


```python
rW = ps.rook_from_shapefile(shp_path, idVariable='FIPS')
```


```python
rW['48357']
```




    {'48195': 1.0, '48295': 1.0, '48393': 1.0}



These weights function exactly like the Queen weights, and are only distinguished by what they consider "neighbors."


```python
self_and_neighbors = ['48357']
self_and_neighbors.extend(rW.neighbors['48357'])
fips_frame.loc[self_and_neighbors]
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
    <tr>
      <th>FIPS</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>48357</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91efd0&gt;</td>
    </tr>
    <tr>
      <th>48295</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee10&gt;</td>
    </tr>
    <tr>
      <th>48195</th>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ef60&gt;</td>
    </tr>
    <tr>
      <th>48393</th>
      <td>Roberts</td>
      <td>Texas</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>1</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.000000</td>
      <td>0.320275</td>
      <td>0.318656</td>
      <td>0.398681</td>
      <td>0.339626</td>
      <td>5.762712</td>
      <td>5.3</td>
      <td>6.231454</td>
      <td>4.885993</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91b080&gt;</td>
    </tr>
  </tbody>
</table>
<p>4 rows × 70 columns</p>
</div>



#### Bishop Weights

In theory, a "Bishop" weighting scheme is one that arises when only polygons that share vertexes are considered to be neighboring. But, since Queen contiguigy requires either an edge or a vertex and Rook contiguity requires only shared edges, the following relationship is true:

$$ \mathcal{Q} = \mathcal{R} \cup \mathcal{B} $$

where $\mathcal{Q}$ is the set of neighbor pairs *via* queen contiguity, $\mathcal{R}$ is the set of neighbor pairs *via* Rook contiguity, and $\mathcal{B}$ *via* Bishop contiguity. Thus:

$$ \mathcal{Q} \setminus \mathcal{R} = \mathcal{B}$$

Bishop weights entail all Queen neighbor pairs that are not also Rook neighbors.

PySAL does not have a dedicated bishop weights constructor, but you can construct very easily using the `w_difference` function. This function is one of a family of tools to work with weights, all defined in `ps.weights`, that conduct these types of set operations between weight objects.


```python
bW = ps.w_difference(qW, rW, constrained=False, silent_island_warning=True) #silence because there will be a lot of warnings
```


```python
bW.histogram
```




    [(0, 161), (1, 48), (2, 33), (3, 8), (4, 4)]



Thus, the vast majority of counties have no bishop neighbors. But, a few do. A simple way to see these observations in the dataframe is to find all elements of the dataframe that are not "islands," the term for an observation with no neighbors:


```python
islands = bW.islands
```


```python
# Using `.head()` to limit the number of rows printed
dataframe.query('FIPS not in @islands').head()
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee10&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ee80&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91eef0&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91ef60&gt;</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x10d91efd0&gt;</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 70 columns</p>
</div>



## Distance

There are many other kinds of weighting functions in PySAL. Another separate type use a continuous measure of distance to define neighborhoods. 


```python
radius = ps.cg.sphere.RADIUS_EARTH_MILES
radius
```




    3958.755865744055




```python
#ps.min_threshold_dist_from_shapefile?
```


```python
threshold = ps.min_threshold_dist_from_shapefile('../data/texas.shp',radius) # now in miles, maximum nearest neighbor distance between the n observations
```


```python
threshold
```




    60.47758554135752



### knn defined weights


```python
knn4_bad = ps.knnW_from_shapefile('../data/texas.shp', k=4) # ignore curvature of the earth
```


```python
knn4_bad.histogram
```




    [(4, 254)]




```python
knn4 = ps.knnW_from_shapefile('../data/texas.shp', k=4, radius=radius)
```


```python
knn4.histogram
```




    [(4, 254)]




```python
knn4[0]
```




    {3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0}




```python
knn4_bad[0]
```




    {4: 1.0, 5: 1.0, 6: 1.0, 13: 1.0}



#### Kernel W

Kernel Weights are continuous distance-based weights that use kernel densities to define the neighbor relationship.
Typically, they estimate a `bandwidth`, which is a parameter governing how far out observations should be considered neighboring. Then, using this bandwidth, they evaluate a continuous kernel function to provide a weight between 0 and 1.

Many different choices of kernel functions are supported, and bandwidths can either be fixed (constant over all units) or adaptive in function of unit density.

For example, if we want to use adaptive bandwidths for the map and weight according to a gaussian kernel:


```python
kernelWa = ps.adaptive_kernelW_from_shapefile('../data/texas.shp', radius=radius)
kernelWa
```




    <pysal.weights.Distance.Kernel at 0x7f8fe4cfe080>




```python
dataframe.loc[kernelWa.neighbors[4] + [4]]
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f8fe4ee1...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Roberts</td>
      <td>Texas</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>48</td>
      <td>393</td>
      <td>48393</td>
      <td>1</td>
      <td>0.0</td>
      <td>...</td>
      <td>0.000000</td>
      <td>0.320275</td>
      <td>0.318656</td>
      <td>0.398681</td>
      <td>0.339626</td>
      <td>5.762712</td>
      <td>5.3</td>
      <td>6.231454</td>
      <td>4.885993</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f8fe4ee1...</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f8fe4ee1...</td>
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
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f8fe4ee1...</td>
    </tr>
  </tbody>
</table>
<p>4 rows × 70 columns</p>
</div>




```python
kernelWa.bandwidth[0:7]
```




    array([[ 30.30546757],
           [ 30.05684855],
           [ 39.14876899],
           [ 29.96302462],
           [ 29.96302462],
           [ 30.21084447],
           [ 30.23619029]])




```python
kernelWa[4]
```




    {3: 9.99999900663795e-08, 4: 1.0, 5: 0.002299013803371608}




```python
kernelWa[2]
```




    {1: 9.99999900663795e-08, 2: 1.0, 8: 0.23409571720488287}



## Distance Thresholds


```python
#ps.min_threshold_dist_from_shapefile?
```


```python
# find the largest nearest neighbor distance between centroids
threshold = ps.min_threshold_dist_from_shapefile('../data/texas.shp', radius=radius) # decimal degrees
Wmind0 = ps.threshold_binaryW_from_shapefile('../data/texas.shp', radius=radius, threshold=threshold*.9)
```

    WARNING: there are 2 disconnected observations
    Island ids:  [133, 181]



```python
Wmind0.histogram
```




    [(0, 2),
     (1, 3),
     (2, 5),
     (3, 4),
     (4, 10),
     (5, 26),
     (6, 16),
     (7, 31),
     (8, 70),
     (9, 32),
     (10, 29),
     (11, 12),
     (12, 5),
     (13, 2),
     (14, 5),
     (15, 2)]




```python
Wmind = ps.threshold_binaryW_from_shapefile('../data/texas.shp', radius=radius, threshold=threshold)
```


```python
Wmind.histogram
```




    [(1, 2),
     (2, 3),
     (3, 4),
     (4, 8),
     (5, 5),
     (6, 20),
     (7, 26),
     (8, 9),
     (9, 32),
     (10, 31),
     (11, 37),
     (12, 33),
     (13, 23),
     (14, 6),
     (15, 7),
     (16, 2),
     (17, 4),
     (18, 2)]




```python
centroids = np.array([list(poly.centroid) for poly in dataframe.geometry])
```


```python
centroids[0:10]
```




    array([[-100.27156111,   36.27508641],
           [-101.8930971 ,   36.27325425],
           [-102.59590795,   36.27354996],
           [-101.35351324,   36.27230422],
           [-100.81561379,   36.27317803],
           [-100.81482387,   35.8405153 ],
           [-100.2694824 ,   35.83996075],
           [-101.35420366,   35.8408377 ],
           [-102.59375964,   35.83958662],
           [-101.89248229,   35.84058246]])




```python
Wmind[0]
```




    {3: 1, 4: 1, 5: 1, 6: 1, 13: 1}




```python
knn4[0]
```




    {3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0}



## Visualization


```python
%matplotlib inline
import matplotlib.pyplot as plt
from pylab import figure, scatter, show
```


```python
wq = ps.queen_from_shapefile('../data/texas.shp')
```


```python
wq[0]
```




    {4: 1.0, 5: 1.0, 6: 1.0}




```python
fig = figure(figsize=(9,9))
plt.plot(centroids[:,0], centroids[:,1],'.')
plt.ylim([25,37])
show()
```


![png](03_spatial_weights_files/03_spatial_weights_95_0.png)



```python
wq.neighbors[0]
```




    [4, 5, 6]




```python
from pylab import figure, scatter, show
fig = figure(figsize=(9,9))

plt.plot(centroids[:,0], centroids[:,1],'.')
#plt.plot(s04[:,0], s04[:,1], '-')
plt.ylim([25,37])
for k,neighs in wq.neighbors.items():
    #print(k,neighs)
    origin = centroids[k]
    for neigh in neighs:
        segment = centroids[[k,neigh]]
        plt.plot(segment[:,0], segment[:,1], '-')
plt.title('Queen Neighbor Graph')
show()
```


![png](03_spatial_weights_files/03_spatial_weights_97_0.png)



```python
wr = ps.rook_from_shapefile('../data/texas.shp')
```


```python
fig = figure(figsize=(9,9))

plt.plot(centroids[:,0], centroids[:,1],'.')
#plt.plot(s04[:,0], s04[:,1], '-')
plt.ylim([25,37])
for k,neighs in wr.neighbors.items():
    #print(k,neighs)
    origin = centroids[k]
    for neigh in neighs:
        segment = centroids[[k,neigh]]
        plt.plot(segment[:,0], segment[:,1], '-')
plt.title('Rook Neighbor Graph')
show()
```


![png](03_spatial_weights_files/03_spatial_weights_99_0.png)



```python
fig = figure(figsize=(9,9))
plt.plot(centroids[:,0], centroids[:,1],'.')
#plt.plot(s04[:,0], s04[:,1], '-')
plt.ylim([25,37])
for k,neighs in Wmind.neighbors.items():
    origin = centroids[k]
    for neigh in neighs:
        segment = centroids[[k,neigh]]
        plt.plot(segment[:,0], segment[:,1], '-')
plt.title('Minimum Distance Threshold Neighbor Graph')
show()
```


![png](03_spatial_weights_files/03_spatial_weights_100_0.png)



```python
Wmind.pct_nonzero
```




    3.8378076756153514




```python
wr.pct_nonzero
```




    2.0243040486080974




```python
wq.pct_nonzero
```




    2.263004526009052



## Exercise

1. Answer this question before writing any code: What spatial weights structure would be more dense, Texas counties based on rook contiguity or Texas counties based on knn with k=4?
2. Why?
3. Write code to see if you are correct.
