
# Spatial Data Processing with PySAL & Pandas

> [`IPYNB`](../content/part1/01_data_processing.ipynb)


```python
#by convention, we use these shorter two-letter names
import pysal as ps
import pandas as pd
import numpy as np
```

PySAL has two simple ways to read in data. But, first, you need to get the path from where your notebook is running on your computer to the place the data is. For example, to find where the notebook is running:


```python
!pwd # on windows !cd
```

    /home/serge/Dropbox/p/pysal/workshops/scipy16/gds_scipy16/content/part1


PySAL has a command that it uses to get the paths of its example datasets. Let's work with a commonly-used dataset first. 


```python
ps.examples.available()
```




    ['arcgis',
     'street_net_pts',
     'Point',
     'taz',
     'Line',
     'calemp',
     'baltim',
     'south',
     'burkitt',
     'mexico',
     'sids2',
     'geodanet',
     'newHaven',
     'networks',
     'snow_maps',
     'us_income',
     '10740',
     'chicago',
     'juvenile',
     'stl',
     'desmith',
     'virginia',
     'book',
     'nat',
     'Polygon',
     'columbus',
     'wmat',
     'sacramento2']




```python
ps.examples.explain('us_income')
```




    {'description': 'Per-capita income for the lower 47 US states 1929-2010',
     'explanation': [' * us48.shp: shapefile ',
      ' * us48.dbf: dbf for shapefile',
      ' * us48.shx: index for shapefile',
      ' * usjoin.csv: attribute data (comma delimited file)'],
     'name': 'us_income'}




```python
csv_path = ps.examples.get_path('usjoin.csv')
```


```python
f = ps.open(csv_path)
f.header[0:10]
```




    ['Name',
     'STATE_FIPS',
     '1929',
     '1930',
     '1931',
     '1932',
     '1933',
     '1934',
     '1935',
     '1936']




```python
y2009 = f.by_col('2009')
```


```python
y2009[0:10]
```




    [32274, 32077, 31493, 40902, 40093, 52736, 40135, 36565, 33086, 30987]



### Working with shapefiles

We can also work with local files outside the built-in examples.

To read in a shapefile, we will need the path to the file.


```python
shp_path = '../data/texas.shp'
print(shp_path)
```

    ../data/texas.shp


Then, we open the file using the `ps.open` command:


```python
f = ps.open(shp_path)
```

`f` is what we call a "file handle." That means that it only *points* to the data and provides ways to work with it. By itself, it does not read the whole dataset into memory. To see basic information about the file, we can use a few different methods. 

For instance, the header of the file, which contains most of the metadata about the file:


```python
f.header
```




    {'BBOX Mmax': 0.0,
     'BBOX Mmin': 0.0,
     'BBOX Xmax': -93.50721740722656,
     'BBOX Xmin': -106.6495132446289,
     'BBOX Ymax': 36.49387741088867,
     'BBOX Ymin': 25.845197677612305,
     'BBOX Zmax': 0.0,
     'BBOX Zmin': 0.0,
     'File Code': 9994,
     'File Length': 49902,
     'Shape Type': 5,
     'Unused0': 0,
     'Unused1': 0,
     'Unused2': 0,
     'Unused3': 0,
     'Unused4': 0,
     'Version': 1000}



To actually read in the shapes from memory, you can use the following commands:


```python
f.by_row(14) #gets the 14th shape from the file
```




    <pysal.cg.shapes.Polygon at 0x7f08c93c00b8>




```python
all_polygons = f.read() #reads in all polygons from memory
```


```python
len(all_polygons)
```




    254



So, all 254 polygons have been read in from file. These are stored in PySAL shape objects, which can be used by PySAL and can be converted to other Python shape objects.

They typically have a few methods. So, since we've read in polygonal data, we can get some properties about the polygons. Let's just have a look at the first polygon:


```python
all_polygons[0:5]
```




    [<pysal.cg.shapes.Polygon at 0x7f08c93c0a90>,
     <pysal.cg.shapes.Polygon at 0x7f08c93c0048>,
     <pysal.cg.shapes.Polygon at 0x7f08c93c08d0>,
     <pysal.cg.shapes.Polygon at 0x7f08c93c0080>,
     <pysal.cg.shapes.Polygon at 0x7f08c93cc3c8>]




```python
all_polygons[0].centroid #the centroid of the first polygon
```




    (-100.27156110567945, 36.27508640938005)




```python
all_polygons[0].area
```




    0.23682222998468205




```python
all_polygons[0].perimeter
```




    1.9582821721538344



While in the Jupyter Notebook, you can examine what properties an object has by using the tab key.


```python
polygon = all_polygons[0]
```


```python
polygon. #press tab when the cursor is right after the dot
```


      File "<ipython-input-82-aa03438a2fa8>", line 1
        polygon. #press tab when the cursor is right after the dot
                                                                  ^
    SyntaxError: invalid syntax



### Working with Data Tables


```python
dbf_path = "../data/texas.dbf"
print(dbf_path)
```

    ../data/texas.dbf


When you're working with tables of data, like a `csv` or `dbf`, you can extract your data in the following way. Let's open the dbf file we got the path for above.


```python
f = ps.open(dbf_path)
```

Just like with the shapefile, we can examine the header of the dbf file.


```python
f.header
```




    ['NAME',
     'STATE_NAME',
     'STATE_FIPS',
     'CNTY_FIPS',
     'FIPS',
     'STFIPS',
     'COFIPS',
     'FIPSNO',
     'SOUTH',
     'HR60',
     'HR70',
     'HR80',
     'HR90',
     'HC60',
     'HC70',
     'HC80',
     'HC90',
     'PO60',
     'PO70',
     'PO80',
     'PO90',
     'RD60',
     'RD70',
     'RD80',
     'RD90',
     'PS60',
     'PS70',
     'PS80',
     'PS90',
     'UE60',
     'UE70',
     'UE80',
     'UE90',
     'DV60',
     'DV70',
     'DV80',
     'DV90',
     'MA60',
     'MA70',
     'MA80',
     'MA90',
     'POL60',
     'POL70',
     'POL80',
     'POL90',
     'DNL60',
     'DNL70',
     'DNL80',
     'DNL90',
     'MFIL59',
     'MFIL69',
     'MFIL79',
     'MFIL89',
     'FP59',
     'FP69',
     'FP79',
     'FP89',
     'BLK60',
     'BLK70',
     'BLK80',
     'BLK90',
     'GI59',
     'GI69',
     'GI79',
     'GI89',
     'FH60',
     'FH70',
     'FH80',
     'FH90']



So, the header is a list containing the names of all of the fields we can read.
If we just wanted to grab the data of interest, `HR90`, we can use either `by_col` or `by_col_array`, depending on the format we want the resulting data in:


```python
HR90 = f.by_col('HR90')
print(type(HR90).__name__, HR90[0:5])
HR90 = f.by_col_array('HR90')
print(type(HR90).__name__, HR90[0:5])
```

    list [0.0, 0.0, 18.31166453, 0.0, 3.6517674554]
    ndarray [[  0.        ]
     [  0.        ]
     [ 18.31166453]
     [  0.        ]
     [  3.65176746]]


As you can see, the `by_col` function returns a list of data, with no shape. It can only return one column at a time:


```python
HRs = f.by_col('HR90', 'HR80')
```


    ---------------------------------------------------------------------------

    TypeError                                 Traceback (most recent call last)

    <ipython-input-25-1fef6a3c3a50> in <module>()
    ----> 1 HRs = f.by_col('HR90', 'HR80')
    

    TypeError: __call__() takes 2 positional arguments but 3 were given


This error message is called a "traceback," as you see in the top right, and it usually provides feedback on why the previous command did not execute correctly. Here, you see that one-too-many arguments was provided to `__call__`, which tells us we cannot pass as many arguments as we did to `by_col`.

If you want to read in many columns at once and store them to an array, use `by_col_array`:


```python
HRs = f.by_col_array('HR90', 'HR80')
```


```python
HRs[0:10]
```




    array([[  0.        ,   0.        ],
           [  0.        ,  10.50199538],
           [ 18.31166453,   5.10386362],
           [  0.        ,   0.        ],
           [  3.65176746,  10.4297038 ],
           [  0.        ,   0.        ],
           [  0.        ,  18.85369532],
           [  2.59514448,   6.33617194],
           [  0.        ,   0.        ],
           [  5.59753708,   6.0331825 ]])



It is best to use `by_col_array` on data of a single type. That is, if you read in a lot of columns, some of them numbers and some of them strings, all columns will get converted to the same datatype:


```python
allcolumns = f.by_col_array(['NAME', 'STATE_NAME', 'HR90', 'HR80'])
```


```python
allcolumns
```




    array([['Lipscomb', 'Texas', '0.0', '0.0'],
           ['Sherman', 'Texas', '0.0', '10.501995379'],
           ['Dallam', 'Texas', '18.31166453', '5.1038636248'],
           ..., 
           ['Hidalgo', 'Texas', '7.3003167816', '8.2383277607'],
           ['Willacy', 'Texas', '5.6481219994', '7.6212251119'],
           ['Cameron', 'Texas', '12.302014455', '11.761321464']], 
          dtype='<U13')



Note that the numerical columns, `HR90` & `HR80` are now considered strings, since they show up with the single tickmarks around them, like `'0.0'`.

These methods work similarly for `.csv` files as well.

### Using Pandas with PySAL

A new functionality added to PySAL recently allows you to work with shapefile/dbf pairs using Pandas. This *optional* extension is only turned on if you have Pandas installed. The extension is the `ps.pdio` module:


```python
ps.pdio
```




    <module 'pysal.contrib.pdutilities' from '/home/serge/anaconda2/envs/gds-scipy16/lib/python3.5/site-packages/pysal/contrib/pdutilities/__init__.py'>



To use it, you can read in shapefile/dbf pairs using the `ps.pdio.read_files` command. 


```python
shp_path = ps.examples.get_path('NAT.shp')
data_table = ps.pdio.read_files(shp_path)
```

This reads in *the entire database table* and adds a column to the end, called `geometry`, that stores the geometries read in from the shapefile. 

Now, you can work with it like a standard pandas dataframe.


```python
data_table.head()
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
      <td>Lake of the Woods</td>
      <td>Minnesota</td>
      <td>27</td>
      <td>077</td>
      <td>27077</td>
      <td>27</td>
      <td>77</td>
      <td>27077</td>
      <td>0</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.024534</td>
      <td>0.285235</td>
      <td>0.372336</td>
      <td>0.342104</td>
      <td>0.336455</td>
      <td>11.279621</td>
      <td>5.4</td>
      <td>5.663881</td>
      <td>9.515860</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f09004c6...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Ferry</td>
      <td>Washington</td>
      <td>53</td>
      <td>019</td>
      <td>53019</td>
      <td>53</td>
      <td>19</td>
      <td>53019</td>
      <td>0</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.317712</td>
      <td>0.256158</td>
      <td>0.360665</td>
      <td>0.361928</td>
      <td>0.360640</td>
      <td>10.053476</td>
      <td>2.6</td>
      <td>10.079576</td>
      <td>11.397059</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d5445...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Stevens</td>
      <td>Washington</td>
      <td>53</td>
      <td>065</td>
      <td>53065</td>
      <td>53</td>
      <td>65</td>
      <td>53065</td>
      <td>0</td>
      <td>1.863863</td>
      <td>...</td>
      <td>0.210030</td>
      <td>0.283999</td>
      <td>0.394083</td>
      <td>0.357566</td>
      <td>0.369942</td>
      <td>9.258437</td>
      <td>5.6</td>
      <td>6.812127</td>
      <td>10.352015</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d96ae...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Okanogan</td>
      <td>Washington</td>
      <td>53</td>
      <td>047</td>
      <td>53047</td>
      <td>53</td>
      <td>47</td>
      <td>53047</td>
      <td>0</td>
      <td>2.612330</td>
      <td>...</td>
      <td>0.155922</td>
      <td>0.258540</td>
      <td>0.371218</td>
      <td>0.381240</td>
      <td>0.394519</td>
      <td>9.039900</td>
      <td>8.1</td>
      <td>10.084926</td>
      <td>12.840340</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d47b4...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Pend Oreille</td>
      <td>Washington</td>
      <td>53</td>
      <td>051</td>
      <td>53051</td>
      <td>53</td>
      <td>51</td>
      <td>53051</td>
      <td>0</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.134605</td>
      <td>0.243263</td>
      <td>0.365614</td>
      <td>0.358706</td>
      <td>0.387848</td>
      <td>8.243930</td>
      <td>4.1</td>
      <td>7.557643</td>
      <td>10.313002</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d47b4...</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 70 columns</p>
</div>



The `read_files` function only works on shapefile/dbf pairs. If you need to read in data using CSVs, use pandas directly:


```python
usjoin = pd.read_csv(csv_path)
#usjoin = ps.pdio.read_files(csv_path) #will not work, not a shp/dbf pair
```


```python
usjoin.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Name</th>
      <th>STATE_FIPS</th>
      <th>1929</th>
      <th>1930</th>
      <th>1931</th>
      <th>1932</th>
      <th>1933</th>
      <th>1934</th>
      <th>1935</th>
      <th>1936</th>
      <th>...</th>
      <th>2000</th>
      <th>2001</th>
      <th>2002</th>
      <th>2003</th>
      <th>2004</th>
      <th>2005</th>
      <th>2006</th>
      <th>2007</th>
      <th>2008</th>
      <th>2009</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Alabama</td>
      <td>1</td>
      <td>323</td>
      <td>267</td>
      <td>224</td>
      <td>162</td>
      <td>166</td>
      <td>211</td>
      <td>217</td>
      <td>251</td>
      <td>...</td>
      <td>23471</td>
      <td>24467</td>
      <td>25161</td>
      <td>26065</td>
      <td>27665</td>
      <td>29097</td>
      <td>30634</td>
      <td>31988</td>
      <td>32819</td>
      <td>32274</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Arizona</td>
      <td>4</td>
      <td>600</td>
      <td>520</td>
      <td>429</td>
      <td>321</td>
      <td>308</td>
      <td>362</td>
      <td>416</td>
      <td>462</td>
      <td>...</td>
      <td>25578</td>
      <td>26232</td>
      <td>26469</td>
      <td>27106</td>
      <td>28753</td>
      <td>30671</td>
      <td>32552</td>
      <td>33470</td>
      <td>33445</td>
      <td>32077</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Arkansas</td>
      <td>5</td>
      <td>310</td>
      <td>228</td>
      <td>215</td>
      <td>157</td>
      <td>157</td>
      <td>187</td>
      <td>207</td>
      <td>247</td>
      <td>...</td>
      <td>22257</td>
      <td>23532</td>
      <td>23929</td>
      <td>25074</td>
      <td>26465</td>
      <td>27512</td>
      <td>29041</td>
      <td>31070</td>
      <td>31800</td>
      <td>31493</td>
    </tr>
    <tr>
      <th>3</th>
      <td>California</td>
      <td>6</td>
      <td>991</td>
      <td>887</td>
      <td>749</td>
      <td>580</td>
      <td>546</td>
      <td>603</td>
      <td>660</td>
      <td>771</td>
      <td>...</td>
      <td>32275</td>
      <td>32750</td>
      <td>32900</td>
      <td>33801</td>
      <td>35663</td>
      <td>37463</td>
      <td>40169</td>
      <td>41943</td>
      <td>42377</td>
      <td>40902</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Colorado</td>
      <td>8</td>
      <td>634</td>
      <td>578</td>
      <td>471</td>
      <td>354</td>
      <td>353</td>
      <td>368</td>
      <td>444</td>
      <td>542</td>
      <td>...</td>
      <td>32949</td>
      <td>34228</td>
      <td>33963</td>
      <td>34092</td>
      <td>35543</td>
      <td>37388</td>
      <td>39662</td>
      <td>41165</td>
      <td>41719</td>
      <td>40093</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 83 columns</p>
</div>



The nice thing about working with pandas dataframes is that they have very powerful baked-in support for relational-style queries. By this, I mean that it is very easy to find things like:

The number of counties in each state:


```python
data_table.groupby("STATE_NAME").size()
```




    STATE_NAME
    Alabama                  67
    Arizona                  14
    Arkansas                 75
    California               58
    Colorado                 63
    Connecticut               8
    Delaware                  3
    District of Columbia      1
    Florida                  67
    Georgia                 159
    Idaho                    44
    Illinois                102
    Indiana                  92
    Iowa                     99
    Kansas                  105
    Kentucky                120
    Louisiana                64
    Maine                    16
    Maryland                 24
    Massachusetts            12
    Michigan                 83
    Minnesota                87
    Mississippi              82
    Missouri                115
    Montana                  55
    Nebraska                 93
    Nevada                   17
    New Hampshire            10
    New Jersey               21
    New Mexico               32
    New York                 58
    North Carolina          100
    North Dakota             53
    Ohio                     88
    Oklahoma                 77
    Oregon                   36
    Pennsylvania             67
    Rhode Island              5
    South Carolina           46
    South Dakota             66
    Tennessee                95
    Texas                   254
    Utah                     29
    Vermont                  14
    Virginia                123
    Washington               38
    West Virginia            55
    Wisconsin                70
    Wyoming                  23
    dtype: int64



Or, to get the rows of the table that are in Arizona, we can use the `query` function of the dataframe:


```python
data_table.query('STATE_NAME == "Arizona"')
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
      <th>1707</th>
      <td>Navajo</td>
      <td>Arizona</td>
      <td>04</td>
      <td>017</td>
      <td>04017</td>
      <td>4</td>
      <td>17</td>
      <td>4017</td>
      <td>0</td>
      <td>5.263989</td>
      <td>...</td>
      <td>0.905251</td>
      <td>0.366863</td>
      <td>0.414135</td>
      <td>0.401999</td>
      <td>0.445299</td>
      <td>13.146998</td>
      <td>12.1</td>
      <td>13.762783</td>
      <td>18.033782</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d417d...</td>
    </tr>
    <tr>
      <th>1708</th>
      <td>Coconino</td>
      <td>Arizona</td>
      <td>04</td>
      <td>005</td>
      <td>04005</td>
      <td>4</td>
      <td>5</td>
      <td>4005</td>
      <td>0</td>
      <td>3.185449</td>
      <td>...</td>
      <td>1.469081</td>
      <td>0.301222</td>
      <td>0.377785</td>
      <td>0.381655</td>
      <td>0.403188</td>
      <td>9.475171</td>
      <td>8.5</td>
      <td>11.181563</td>
      <td>15.267643</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d417d...</td>
    </tr>
    <tr>
      <th>1722</th>
      <td>Mohave</td>
      <td>Arizona</td>
      <td>04</td>
      <td>015</td>
      <td>04015</td>
      <td>4</td>
      <td>15</td>
      <td>4015</td>
      <td>0</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.324075</td>
      <td>0.279339</td>
      <td>0.347150</td>
      <td>0.375790</td>
      <td>0.374383</td>
      <td>11.508554</td>
      <td>4.8</td>
      <td>7.018268</td>
      <td>9.214294</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d411f...</td>
    </tr>
    <tr>
      <th>1726</th>
      <td>Apache</td>
      <td>Arizona</td>
      <td>04</td>
      <td>001</td>
      <td>04001</td>
      <td>4</td>
      <td>1</td>
      <td>4001</td>
      <td>0</td>
      <td>10.951223</td>
      <td>...</td>
      <td>0.162361</td>
      <td>0.395913</td>
      <td>0.450552</td>
      <td>0.431013</td>
      <td>0.489132</td>
      <td>15.014738</td>
      <td>14.6</td>
      <td>18.727548</td>
      <td>22.933635</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d411f...</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>Yavapai</td>
      <td>Arizona</td>
      <td>04</td>
      <td>025</td>
      <td>04025</td>
      <td>4</td>
      <td>25</td>
      <td>4025</td>
      <td>0</td>
      <td>3.458771</td>
      <td>...</td>
      <td>0.298011</td>
      <td>0.289509</td>
      <td>0.378195</td>
      <td>0.376313</td>
      <td>0.384089</td>
      <td>9.930032</td>
      <td>8.6</td>
      <td>7.516372</td>
      <td>9.483521</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d402e...</td>
    </tr>
    <tr>
      <th>2182</th>
      <td>Gila</td>
      <td>Arizona</td>
      <td>04</td>
      <td>007</td>
      <td>04007</td>
      <td>4</td>
      <td>7</td>
      <td>4007</td>
      <td>0</td>
      <td>6.473749</td>
      <td>...</td>
      <td>0.246171</td>
      <td>0.265294</td>
      <td>0.337519</td>
      <td>0.353848</td>
      <td>0.386976</td>
      <td>10.470261</td>
      <td>8.1</td>
      <td>9.934237</td>
      <td>11.706102</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3fc1...</td>
    </tr>
    <tr>
      <th>2262</th>
      <td>Maricopa</td>
      <td>Arizona</td>
      <td>04</td>
      <td>013</td>
      <td>04013</td>
      <td>4</td>
      <td>13</td>
      <td>4013</td>
      <td>0</td>
      <td>6.179259</td>
      <td>...</td>
      <td>3.499221</td>
      <td>0.277828</td>
      <td>0.352374</td>
      <td>0.366015</td>
      <td>0.372756</td>
      <td>10.642382</td>
      <td>9.8</td>
      <td>11.857260</td>
      <td>14.404902</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3f33...</td>
    </tr>
    <tr>
      <th>2311</th>
      <td>Greenlee</td>
      <td>Arizona</td>
      <td>04</td>
      <td>011</td>
      <td>04011</td>
      <td>4</td>
      <td>11</td>
      <td>4011</td>
      <td>0</td>
      <td>2.896284</td>
      <td>...</td>
      <td>0.349650</td>
      <td>0.177691</td>
      <td>0.257158</td>
      <td>0.283518</td>
      <td>0.337256</td>
      <td>9.806115</td>
      <td>6.7</td>
      <td>5.295110</td>
      <td>10.453284</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3ee0...</td>
    </tr>
    <tr>
      <th>2326</th>
      <td>Graham</td>
      <td>Arizona</td>
      <td>04</td>
      <td>009</td>
      <td>04009</td>
      <td>4</td>
      <td>9</td>
      <td>4009</td>
      <td>0</td>
      <td>4.746648</td>
      <td>...</td>
      <td>1.890487</td>
      <td>0.310256</td>
      <td>0.362926</td>
      <td>0.383554</td>
      <td>0.408379</td>
      <td>11.979335</td>
      <td>10.1</td>
      <td>11.961367</td>
      <td>16.129032</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3ee0...</td>
    </tr>
    <tr>
      <th>2353</th>
      <td>Pinal</td>
      <td>Arizona</td>
      <td>04</td>
      <td>021</td>
      <td>04021</td>
      <td>4</td>
      <td>21</td>
      <td>4021</td>
      <td>0</td>
      <td>13.828390</td>
      <td>...</td>
      <td>3.134586</td>
      <td>0.304294</td>
      <td>0.369974</td>
      <td>0.361193</td>
      <td>0.400130</td>
      <td>10.822965</td>
      <td>8.8</td>
      <td>10.341699</td>
      <td>15.304144</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e86...</td>
    </tr>
    <tr>
      <th>2499</th>
      <td>Pima</td>
      <td>Arizona</td>
      <td>04</td>
      <td>019</td>
      <td>04019</td>
      <td>4</td>
      <td>19</td>
      <td>4019</td>
      <td>0</td>
      <td>5.520841</td>
      <td>...</td>
      <td>3.118252</td>
      <td>0.268266</td>
      <td>0.367218</td>
      <td>0.375039</td>
      <td>0.392144</td>
      <td>11.381626</td>
      <td>10.2</td>
      <td>12.689768</td>
      <td>16.163178</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e0a...</td>
    </tr>
    <tr>
      <th>2514</th>
      <td>Cochise</td>
      <td>Arizona</td>
      <td>04</td>
      <td>003</td>
      <td>04003</td>
      <td>4</td>
      <td>3</td>
      <td>4003</td>
      <td>0</td>
      <td>4.845049</td>
      <td>...</td>
      <td>5.201590</td>
      <td>0.261208</td>
      <td>0.359500</td>
      <td>0.359701</td>
      <td>0.399208</td>
      <td>10.197573</td>
      <td>8.7</td>
      <td>9.912732</td>
      <td>13.733872</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e2e...</td>
    </tr>
    <tr>
      <th>2615</th>
      <td>Santa Cruz</td>
      <td>Arizona</td>
      <td>04</td>
      <td>023</td>
      <td>04023</td>
      <td>4</td>
      <td>23</td>
      <td>4023</td>
      <td>0</td>
      <td>9.252406</td>
      <td>...</td>
      <td>0.326863</td>
      <td>0.327130</td>
      <td>0.396807</td>
      <td>0.393240</td>
      <td>0.413795</td>
      <td>19.007213</td>
      <td>14.7</td>
      <td>15.690913</td>
      <td>18.272244</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3da0...</td>
    </tr>
    <tr>
      <th>3080</th>
      <td>La Paz</td>
      <td>Arizona</td>
      <td>04</td>
      <td>012</td>
      <td>04012</td>
      <td>4</td>
      <td>12</td>
      <td>4012</td>
      <td>0</td>
      <td>5.046682</td>
      <td>...</td>
      <td>2.628811</td>
      <td>0.271556</td>
      <td>0.364110</td>
      <td>0.372662</td>
      <td>0.405743</td>
      <td>9.216414</td>
      <td>8.0</td>
      <td>9.296093</td>
      <td>12.379134</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3c30...</td>
    </tr>
  </tbody>
</table>
<p>14 rows × 70 columns</p>
</div>



Behind the scenes, this uses a fast vectorized library, `numexpr`, to essentially do the following. 

First, compare each row's `STATE_NAME` column to `'Arizona'` and return `True` if the row matches:


```python
data_table.STATE_NAME == 'Arizona'
```




    0       False
    1       False
    2       False
    3       False
    4       False
    5       False
    6       False
    7       False
    8       False
    9       False
    10      False
    11      False
    12      False
    13      False
    14      False
    15      False
    16      False
    17      False
    18      False
    19      False
    20      False
    21      False
    22      False
    23      False
    24      False
    25      False
    26      False
    27      False
    28      False
    29      False
            ...  
    3055    False
    3056    False
    3057    False
    3058    False
    3059    False
    3060    False
    3061    False
    3062    False
    3063    False
    3064    False
    3065    False
    3066    False
    3067    False
    3068    False
    3069    False
    3070    False
    3071    False
    3072    False
    3073    False
    3074    False
    3075    False
    3076    False
    3077    False
    3078    False
    3079    False
    3080     True
    3081    False
    3082    False
    3083    False
    3084    False
    Name: STATE_NAME, dtype: bool



Then, use that to filter out rows where the condition is true:


```python
data_table[data_table.STATE_NAME == 'Arizona']
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
      <th>1707</th>
      <td>Navajo</td>
      <td>Arizona</td>
      <td>04</td>
      <td>017</td>
      <td>04017</td>
      <td>4</td>
      <td>17</td>
      <td>4017</td>
      <td>0</td>
      <td>5.263989</td>
      <td>...</td>
      <td>0.905251</td>
      <td>0.366863</td>
      <td>0.414135</td>
      <td>0.401999</td>
      <td>0.445299</td>
      <td>13.146998</td>
      <td>12.1</td>
      <td>13.762783</td>
      <td>18.033782</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d417d...</td>
    </tr>
    <tr>
      <th>1708</th>
      <td>Coconino</td>
      <td>Arizona</td>
      <td>04</td>
      <td>005</td>
      <td>04005</td>
      <td>4</td>
      <td>5</td>
      <td>4005</td>
      <td>0</td>
      <td>3.185449</td>
      <td>...</td>
      <td>1.469081</td>
      <td>0.301222</td>
      <td>0.377785</td>
      <td>0.381655</td>
      <td>0.403188</td>
      <td>9.475171</td>
      <td>8.5</td>
      <td>11.181563</td>
      <td>15.267643</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d417d...</td>
    </tr>
    <tr>
      <th>1722</th>
      <td>Mohave</td>
      <td>Arizona</td>
      <td>04</td>
      <td>015</td>
      <td>04015</td>
      <td>4</td>
      <td>15</td>
      <td>4015</td>
      <td>0</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.324075</td>
      <td>0.279339</td>
      <td>0.347150</td>
      <td>0.375790</td>
      <td>0.374383</td>
      <td>11.508554</td>
      <td>4.8</td>
      <td>7.018268</td>
      <td>9.214294</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d411f...</td>
    </tr>
    <tr>
      <th>1726</th>
      <td>Apache</td>
      <td>Arizona</td>
      <td>04</td>
      <td>001</td>
      <td>04001</td>
      <td>4</td>
      <td>1</td>
      <td>4001</td>
      <td>0</td>
      <td>10.951223</td>
      <td>...</td>
      <td>0.162361</td>
      <td>0.395913</td>
      <td>0.450552</td>
      <td>0.431013</td>
      <td>0.489132</td>
      <td>15.014738</td>
      <td>14.6</td>
      <td>18.727548</td>
      <td>22.933635</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d411f...</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>Yavapai</td>
      <td>Arizona</td>
      <td>04</td>
      <td>025</td>
      <td>04025</td>
      <td>4</td>
      <td>25</td>
      <td>4025</td>
      <td>0</td>
      <td>3.458771</td>
      <td>...</td>
      <td>0.298011</td>
      <td>0.289509</td>
      <td>0.378195</td>
      <td>0.376313</td>
      <td>0.384089</td>
      <td>9.930032</td>
      <td>8.6</td>
      <td>7.516372</td>
      <td>9.483521</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d402e...</td>
    </tr>
    <tr>
      <th>2182</th>
      <td>Gila</td>
      <td>Arizona</td>
      <td>04</td>
      <td>007</td>
      <td>04007</td>
      <td>4</td>
      <td>7</td>
      <td>4007</td>
      <td>0</td>
      <td>6.473749</td>
      <td>...</td>
      <td>0.246171</td>
      <td>0.265294</td>
      <td>0.337519</td>
      <td>0.353848</td>
      <td>0.386976</td>
      <td>10.470261</td>
      <td>8.1</td>
      <td>9.934237</td>
      <td>11.706102</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3fc1...</td>
    </tr>
    <tr>
      <th>2262</th>
      <td>Maricopa</td>
      <td>Arizona</td>
      <td>04</td>
      <td>013</td>
      <td>04013</td>
      <td>4</td>
      <td>13</td>
      <td>4013</td>
      <td>0</td>
      <td>6.179259</td>
      <td>...</td>
      <td>3.499221</td>
      <td>0.277828</td>
      <td>0.352374</td>
      <td>0.366015</td>
      <td>0.372756</td>
      <td>10.642382</td>
      <td>9.8</td>
      <td>11.857260</td>
      <td>14.404902</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3f33...</td>
    </tr>
    <tr>
      <th>2311</th>
      <td>Greenlee</td>
      <td>Arizona</td>
      <td>04</td>
      <td>011</td>
      <td>04011</td>
      <td>4</td>
      <td>11</td>
      <td>4011</td>
      <td>0</td>
      <td>2.896284</td>
      <td>...</td>
      <td>0.349650</td>
      <td>0.177691</td>
      <td>0.257158</td>
      <td>0.283518</td>
      <td>0.337256</td>
      <td>9.806115</td>
      <td>6.7</td>
      <td>5.295110</td>
      <td>10.453284</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3ee0...</td>
    </tr>
    <tr>
      <th>2326</th>
      <td>Graham</td>
      <td>Arizona</td>
      <td>04</td>
      <td>009</td>
      <td>04009</td>
      <td>4</td>
      <td>9</td>
      <td>4009</td>
      <td>0</td>
      <td>4.746648</td>
      <td>...</td>
      <td>1.890487</td>
      <td>0.310256</td>
      <td>0.362926</td>
      <td>0.383554</td>
      <td>0.408379</td>
      <td>11.979335</td>
      <td>10.1</td>
      <td>11.961367</td>
      <td>16.129032</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3ee0...</td>
    </tr>
    <tr>
      <th>2353</th>
      <td>Pinal</td>
      <td>Arizona</td>
      <td>04</td>
      <td>021</td>
      <td>04021</td>
      <td>4</td>
      <td>21</td>
      <td>4021</td>
      <td>0</td>
      <td>13.828390</td>
      <td>...</td>
      <td>3.134586</td>
      <td>0.304294</td>
      <td>0.369974</td>
      <td>0.361193</td>
      <td>0.400130</td>
      <td>10.822965</td>
      <td>8.8</td>
      <td>10.341699</td>
      <td>15.304144</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e86...</td>
    </tr>
    <tr>
      <th>2499</th>
      <td>Pima</td>
      <td>Arizona</td>
      <td>04</td>
      <td>019</td>
      <td>04019</td>
      <td>4</td>
      <td>19</td>
      <td>4019</td>
      <td>0</td>
      <td>5.520841</td>
      <td>...</td>
      <td>3.118252</td>
      <td>0.268266</td>
      <td>0.367218</td>
      <td>0.375039</td>
      <td>0.392144</td>
      <td>11.381626</td>
      <td>10.2</td>
      <td>12.689768</td>
      <td>16.163178</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e0a...</td>
    </tr>
    <tr>
      <th>2514</th>
      <td>Cochise</td>
      <td>Arizona</td>
      <td>04</td>
      <td>003</td>
      <td>04003</td>
      <td>4</td>
      <td>3</td>
      <td>4003</td>
      <td>0</td>
      <td>4.845049</td>
      <td>...</td>
      <td>5.201590</td>
      <td>0.261208</td>
      <td>0.359500</td>
      <td>0.359701</td>
      <td>0.399208</td>
      <td>10.197573</td>
      <td>8.7</td>
      <td>9.912732</td>
      <td>13.733872</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e2e...</td>
    </tr>
    <tr>
      <th>2615</th>
      <td>Santa Cruz</td>
      <td>Arizona</td>
      <td>04</td>
      <td>023</td>
      <td>04023</td>
      <td>4</td>
      <td>23</td>
      <td>4023</td>
      <td>0</td>
      <td>9.252406</td>
      <td>...</td>
      <td>0.326863</td>
      <td>0.327130</td>
      <td>0.396807</td>
      <td>0.393240</td>
      <td>0.413795</td>
      <td>19.007213</td>
      <td>14.7</td>
      <td>15.690913</td>
      <td>18.272244</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3da0...</td>
    </tr>
    <tr>
      <th>3080</th>
      <td>La Paz</td>
      <td>Arizona</td>
      <td>04</td>
      <td>012</td>
      <td>04012</td>
      <td>4</td>
      <td>12</td>
      <td>4012</td>
      <td>0</td>
      <td>5.046682</td>
      <td>...</td>
      <td>2.628811</td>
      <td>0.271556</td>
      <td>0.364110</td>
      <td>0.372662</td>
      <td>0.405743</td>
      <td>9.216414</td>
      <td>8.0</td>
      <td>9.296093</td>
      <td>12.379134</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3c30...</td>
    </tr>
  </tbody>
</table>
<p>14 rows × 70 columns</p>
</div>



We might need this behind the scenes knowledge when we want to chain together conditions, or when we need to do spatial queries. 

This is because spatial queries are somewhat more complex. Let's say, for example, we want all of the counties in the US to the West of `-121` longitude. We need a way to express that question. Ideally, we want something like:

```
SELECT
        *
FROM
        data_table
WHERE
        x_centroid < -121
```

So, let's refer to an arbitrary polygon in the the dataframe's geometry column as `poly`. The centroid of a PySAL polygon is stored as an `(X,Y)` pair, so the longitude is the first element of the pair, `poly.centroid[0]`. 

Then, applying this condition to each geometry, we get the same kind of filter we used above to grab only counties in Arizona:


```python
data_table.geometry.apply(lambda x: x.centroid[0] < -121)
```




    0       False
    1       False
    2       False
    3       False
    4       False
    5       False
    6       False
    7       False
    8       False
    9       False
    10      False
    11      False
    12      False
    13      False
    14      False
    15      False
    16      False
    17      False
    18      False
    19      False
    20      False
    21      False
    22      False
    23      False
    24      False
    25      False
    26      False
    27       True
    28      False
    29      False
            ...  
    3055    False
    3056    False
    3057    False
    3058    False
    3059    False
    3060    False
    3061    False
    3062    False
    3063    False
    3064    False
    3065    False
    3066    False
    3067    False
    3068    False
    3069    False
    3070    False
    3071    False
    3072    False
    3073    False
    3074    False
    3075    False
    3076    False
    3077    False
    3078    False
    3079    False
    3080    False
    3081    False
    3082    False
    3083    False
    3084    False
    Name: geometry, dtype: bool



If we use this as a filter on the table, we can get only the rows that match that condition, just like we did for the `STATE_NAME` query:


```python
data_table[data_table.geometry.apply(lambda x: x.centroid[0] < -119)].head()
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
      <th>3</th>
      <td>Okanogan</td>
      <td>Washington</td>
      <td>53</td>
      <td>047</td>
      <td>53047</td>
      <td>53</td>
      <td>47</td>
      <td>53047</td>
      <td>0</td>
      <td>2.612330</td>
      <td>...</td>
      <td>0.155922</td>
      <td>0.258540</td>
      <td>0.371218</td>
      <td>0.381240</td>
      <td>0.394519</td>
      <td>9.039900</td>
      <td>8.1</td>
      <td>10.084926</td>
      <td>12.840340</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d47b4...</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Whatcom</td>
      <td>Washington</td>
      <td>53</td>
      <td>073</td>
      <td>53073</td>
      <td>53</td>
      <td>73</td>
      <td>53073</td>
      <td>0</td>
      <td>1.422131</td>
      <td>...</td>
      <td>0.508687</td>
      <td>0.247630</td>
      <td>0.346935</td>
      <td>0.369436</td>
      <td>0.358418</td>
      <td>9.174415</td>
      <td>7.1</td>
      <td>9.718054</td>
      <td>11.135022</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d47b4...</td>
    </tr>
    <tr>
      <th>31</th>
      <td>Skagit</td>
      <td>Washington</td>
      <td>53</td>
      <td>057</td>
      <td>53057</td>
      <td>53</td>
      <td>57</td>
      <td>53057</td>
      <td>0</td>
      <td>2.596560</td>
      <td>...</td>
      <td>0.351958</td>
      <td>0.239346</td>
      <td>0.344830</td>
      <td>0.364623</td>
      <td>0.362265</td>
      <td>8.611518</td>
      <td>7.9</td>
      <td>10.480031</td>
      <td>11.382484</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4544...</td>
    </tr>
    <tr>
      <th>42</th>
      <td>Chelan</td>
      <td>Washington</td>
      <td>53</td>
      <td>007</td>
      <td>53007</td>
      <td>53</td>
      <td>7</td>
      <td>53007</td>
      <td>0</td>
      <td>4.908698</td>
      <td>...</td>
      <td>0.153110</td>
      <td>0.246292</td>
      <td>0.367681</td>
      <td>0.374505</td>
      <td>0.383486</td>
      <td>8.787907</td>
      <td>8.1</td>
      <td>9.968454</td>
      <td>12.236493</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4544...</td>
    </tr>
    <tr>
      <th>44</th>
      <td>Clallam</td>
      <td>Washington</td>
      <td>53</td>
      <td>009</td>
      <td>53009</td>
      <td>53</td>
      <td>9</td>
      <td>53009</td>
      <td>0</td>
      <td>3.330891</td>
      <td>...</td>
      <td>0.568504</td>
      <td>0.240573</td>
      <td>0.349320</td>
      <td>0.361619</td>
      <td>0.366854</td>
      <td>8.788882</td>
      <td>6.5</td>
      <td>9.660900</td>
      <td>12.281690</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4544...</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 70 columns</p>
</div>




```python
len(data_table[data_table.geometry.apply(lambda x: x.centroid[0] < -119)]) #how many west of -119?
```




    109



## Other types of spatial queries

Everybody knows the following statements are true:

1. If you head directly west from Reno, Nevada, you will shortly enter California.
2. San Diego is in California.

But what does this tell us about the location of San Diego relative to Reno?

Or for that matter, how many counties in California are to the east of Reno?






```python
geom = data_table.query('(NAME == "Washoe") & (STATE_NAME == "Nevada")').geometry
```


```python
lon,lat = geom.values[0].centroid
```


```python
lon
```




    -119.6555030699793




```python
cal_counties = data_table.query('(STATE_NAME=="California")')
```


```python
cal_counties[cal_counties.geometry.apply(lambda x: x.centroid[0] > lon)]
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
      <th>1312</th>
      <td>Mono</td>
      <td>California</td>
      <td>06</td>
      <td>051</td>
      <td>06051</td>
      <td>6</td>
      <td>51</td>
      <td>6051</td>
      <td>0</td>
      <td>15.062509</td>
      <td>...</td>
      <td>0.431900</td>
      <td>0.229888</td>
      <td>0.327520</td>
      <td>0.388414</td>
      <td>0.366316</td>
      <td>6.743421</td>
      <td>6.6</td>
      <td>8.187135</td>
      <td>10.083699</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4301...</td>
    </tr>
    <tr>
      <th>1591</th>
      <td>Fresno</td>
      <td>California</td>
      <td>06</td>
      <td>019</td>
      <td>06019</td>
      <td>6</td>
      <td>19</td>
      <td>6019</td>
      <td>0</td>
      <td>5.192037</td>
      <td>...</td>
      <td>5.007266</td>
      <td>0.286651</td>
      <td>0.379884</td>
      <td>0.394981</td>
      <td>0.412947</td>
      <td>11.788963</td>
      <td>11.8</td>
      <td>13.998747</td>
      <td>18.523541</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4190...</td>
    </tr>
    <tr>
      <th>1620</th>
      <td>Inyo</td>
      <td>California</td>
      <td>06</td>
      <td>027</td>
      <td>06027</td>
      <td>6</td>
      <td>27</td>
      <td>6027</td>
      <td>0</td>
      <td>8.558713</td>
      <td>...</td>
      <td>0.432143</td>
      <td>0.242293</td>
      <td>0.334361</td>
      <td>0.353784</td>
      <td>0.378516</td>
      <td>9.676365</td>
      <td>8.1</td>
      <td>8.480065</td>
      <td>12.067279</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d41b5...</td>
    </tr>
    <tr>
      <th>1765</th>
      <td>Tulare</td>
      <td>California</td>
      <td>06</td>
      <td>107</td>
      <td>06107</td>
      <td>6</td>
      <td>107</td>
      <td>6107</td>
      <td>0</td>
      <td>3.364944</td>
      <td>...</td>
      <td>1.480503</td>
      <td>0.303303</td>
      <td>0.380229</td>
      <td>0.395059</td>
      <td>0.410811</td>
      <td>10.398757</td>
      <td>9.5</td>
      <td>11.957928</td>
      <td>16.303423</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4140...</td>
    </tr>
    <tr>
      <th>1956</th>
      <td>Kern</td>
      <td>California</td>
      <td>06</td>
      <td>029</td>
      <td>06029</td>
      <td>6</td>
      <td>29</td>
      <td>6029</td>
      <td>0</td>
      <td>6.393044</td>
      <td>...</td>
      <td>5.544117</td>
      <td>0.273083</td>
      <td>0.364603</td>
      <td>0.380617</td>
      <td>0.395393</td>
      <td>10.225236</td>
      <td>10.4</td>
      <td>12.037755</td>
      <td>16.118827</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4061...</td>
    </tr>
    <tr>
      <th>1957</th>
      <td>San Bernardino</td>
      <td>California</td>
      <td>06</td>
      <td>071</td>
      <td>06071</td>
      <td>6</td>
      <td>71</td>
      <td>6071</td>
      <td>0</td>
      <td>3.243373</td>
      <td>...</td>
      <td>8.103188</td>
      <td>0.259038</td>
      <td>0.350927</td>
      <td>0.362389</td>
      <td>0.372659</td>
      <td>9.857519</td>
      <td>10.0</td>
      <td>12.999831</td>
      <td>15.403925</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d4061...</td>
    </tr>
    <tr>
      <th>2117</th>
      <td>Ventura</td>
      <td>California</td>
      <td>06</td>
      <td>111</td>
      <td>06111</td>
      <td>6</td>
      <td>111</td>
      <td>6111</td>
      <td>0</td>
      <td>3.180374</td>
      <td>...</td>
      <td>2.336118</td>
      <td>0.259643</td>
      <td>0.325908</td>
      <td>0.350430</td>
      <td>0.329175</td>
      <td>10.304761</td>
      <td>8.9</td>
      <td>11.047165</td>
      <td>12.044930</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3fa0...</td>
    </tr>
    <tr>
      <th>2255</th>
      <td>Riverside</td>
      <td>California</td>
      <td>06</td>
      <td>065</td>
      <td>06065</td>
      <td>6</td>
      <td>65</td>
      <td>6065</td>
      <td>0</td>
      <td>4.898903</td>
      <td>...</td>
      <td>5.433210</td>
      <td>0.284000</td>
      <td>0.376737</td>
      <td>0.383226</td>
      <td>0.368177</td>
      <td>9.769959</td>
      <td>9.2</td>
      <td>11.145612</td>
      <td>12.678340</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3f05...</td>
    </tr>
    <tr>
      <th>2279</th>
      <td>Orange</td>
      <td>California</td>
      <td>06</td>
      <td>059</td>
      <td>06059</td>
      <td>6</td>
      <td>59</td>
      <td>6059</td>
      <td>0</td>
      <td>2.083555</td>
      <td>...</td>
      <td>1.770587</td>
      <td>0.255864</td>
      <td>0.316731</td>
      <td>0.355117</td>
      <td>0.330447</td>
      <td>8.802545</td>
      <td>9.1</td>
      <td>12.405423</td>
      <td>12.974648</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3f33...</td>
    </tr>
    <tr>
      <th>2344</th>
      <td>San Diego</td>
      <td>California</td>
      <td>06</td>
      <td>073</td>
      <td>06073</td>
      <td>6</td>
      <td>73</td>
      <td>6073</td>
      <td>0</td>
      <td>2.387842</td>
      <td>...</td>
      <td>6.377301</td>
      <td>0.269147</td>
      <td>0.352428</td>
      <td>0.382815</td>
      <td>0.368301</td>
      <td>11.425041</td>
      <td>11.5</td>
      <td>14.384523</td>
      <td>15.489702</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e86...</td>
    </tr>
    <tr>
      <th>2351</th>
      <td>Los Angeles</td>
      <td>California</td>
      <td>06</td>
      <td>037</td>
      <td>06037</td>
      <td>6</td>
      <td>37</td>
      <td>6037</td>
      <td>0</td>
      <td>4.564947</td>
      <td>...</td>
      <td>11.203381</td>
      <td>0.267207</td>
      <td>0.353837</td>
      <td>0.402031</td>
      <td>0.392669</td>
      <td>13.071850</td>
      <td>13.4</td>
      <td>17.767317</td>
      <td>18.808224</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e86...</td>
    </tr>
    <tr>
      <th>2358</th>
      <td>Imperial</td>
      <td>California</td>
      <td>06</td>
      <td>025</td>
      <td>06025</td>
      <td>6</td>
      <td>25</td>
      <td>6025</td>
      <td>0</td>
      <td>4.160599</td>
      <td>...</td>
      <td>2.398836</td>
      <td>0.286568</td>
      <td>0.374913</td>
      <td>0.397430</td>
      <td>0.426348</td>
      <td>11.466417</td>
      <td>9.7</td>
      <td>12.590249</td>
      <td>17.243741</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3e86...</td>
    </tr>
  </tbody>
</table>
<p>12 rows × 70 columns</p>
</div>




```python
len(cal_counties)
```




    58



This works on any type of spatial query. 

For instance, if we wanted to find all of the counties that are within a threshold distance from an observation's centroid, we can do it in the following way. 

But first, we need to handle distance calculations on the earth's surface.


```python
from math import radians, sin, cos, sqrt, asin

def gcd(loc1, loc2, R=3961):
    """Great circle distance via Haversine formula
    
    Parameters
    ----------
    
    loc1: tuple (long, lat in decimal degrees)
    
    loc2: tuple (long, lat in decimal degrees)
    
    R: Radius of the earth (3961 miles, 6367 km)
    
    Returns
    -------
    great circle distance between loc1 and loc2 in units of R
    
    
    Notes
    ------
    Does not take into account non-spheroidal shape of the Earth
    
    
    
    >>> san_diego = -117.1611, 32.7157
    >>> austin = -97.7431, 30.2672
    >>> gcd(san_diego, austin)
    1155.474644164695
  
    
    """
    lon1, lat1 = loc1
    lon2, lat2 = loc2
    dLat = radians(lat2 - lat1)
    dLon = radians(lon2 - lon1)
    lat1 = radians(lat1)
    lat2 = radians(lat2)
 
    a = sin(dLat/2)**2 + cos(lat1)*cos(lat2)*sin(dLon/2)**2
    c = 2*asin(sqrt(a))

    return R * c
 
def gcdm(loc1, loc2):
    return gcd(loc1, loc2)

def gcdk(loc1, loc2):
    return gcd(loc1, loc2, 6367 )
```


```python
san_diego = -117.1611, 32.7157
austin = -97.7431, 30.2672
gcd(san_diego, austin)
```




    1155.474644164695




```python
gcdk(san_diego, austin)
```




    1857.3357887898544




```python
loc1 = (-117.1611, 0.0)
loc2 = (-118.1611, 0.0)
gcd(loc1, loc2)
```




    69.13249167149539




```python
loc1 = (-117.1611, 45.0)
loc2 = (-118.1611, 45.0)
gcd(loc1, loc2)
```




    48.88374342930467




```python
loc1 = (-117.1611, 89.0)
loc2 = (-118.1611, 89.0)
gcd(loc1, loc2)
```




    1.2065130336642724




```python
lats = range(0, 91)
onedeglon = [ gcd((-117.1611,lat),(-118.1611,lat)) for lat in lats]
```


```python
import matplotlib.pyplot as plt
%matplotlib inline
plt.plot(lats, onedeglon)
plt.ylabel('miles')
plt.xlabel('degree of latitude')
plt.title('Length of a degree of longitude')
```




    <matplotlib.text.Text at 0x7f08c93f6ba8>




![png](01_data_processing_files/01_data_processing_87_1.png)



```python
san_diego = -117.1611, 32.7157
austin = -97.7431, 30.2672
gcd(san_diego, austin)
```




    1155.474644164695



Now we can use our distance function to pose distance-related queries on our data table.


```python
# Find all the counties with centroids within 50 miles of Austin
def near_target_point(polygon, target=austin, threshold=50):
    return gcd(polygon.centroid, target) < threshold 

data_table[data_table.geometry.apply(near_target_point)]
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
      <th>2698</th>
      <td>Burnet</td>
      <td>Texas</td>
      <td>48</td>
      <td>053</td>
      <td>48053</td>
      <td>48</td>
      <td>53</td>
      <td>48053</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>1.186224</td>
      <td>0.327508</td>
      <td>0.449285</td>
      <td>0.385079</td>
      <td>0.405890</td>
      <td>10.774142</td>
      <td>6.5</td>
      <td>7.115629</td>
      <td>10.568742</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3d6f...</td>
    </tr>
    <tr>
      <th>2716</th>
      <td>Williamson</td>
      <td>Texas</td>
      <td>48</td>
      <td>491</td>
      <td>48491</td>
      <td>48</td>
      <td>491</td>
      <td>48491</td>
      <td>1</td>
      <td>9.511852</td>
      <td>...</td>
      <td>4.916482</td>
      <td>0.363603</td>
      <td>0.379902</td>
      <td>0.341976</td>
      <td>0.345201</td>
      <td>13.532731</td>
      <td>9.0</td>
      <td>7.582572</td>
      <td>12.032589</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3d6f...</td>
    </tr>
    <tr>
      <th>2742</th>
      <td>Travis</td>
      <td>Texas</td>
      <td>48</td>
      <td>453</td>
      <td>48453</td>
      <td>48</td>
      <td>453</td>
      <td>48453</td>
      <td>1</td>
      <td>4.242561</td>
      <td>...</td>
      <td>10.959791</td>
      <td>0.299292</td>
      <td>0.372293</td>
      <td>0.378953</td>
      <td>0.388149</td>
      <td>12.976379</td>
      <td>10.9</td>
      <td>14.459691</td>
      <td>17.307113</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3d15...</td>
    </tr>
    <tr>
      <th>2751</th>
      <td>Lee</td>
      <td>Texas</td>
      <td>48</td>
      <td>287</td>
      <td>48287</td>
      <td>48</td>
      <td>287</td>
      <td>48287</td>
      <td>1</td>
      <td>7.449622</td>
      <td>...</td>
      <td>13.847829</td>
      <td>0.376002</td>
      <td>0.433132</td>
      <td>0.394000</td>
      <td>0.394959</td>
      <td>12.305699</td>
      <td>10.1</td>
      <td>8.875542</td>
      <td>10.530896</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3d15...</td>
    </tr>
    <tr>
      <th>2754</th>
      <td>Blanco</td>
      <td>Texas</td>
      <td>48</td>
      <td>031</td>
      <td>48031</td>
      <td>48</td>
      <td>31</td>
      <td>48031</td>
      <td>1</td>
      <td>0.000000</td>
      <td>...</td>
      <td>0.937709</td>
      <td>0.369814</td>
      <td>0.436449</td>
      <td>0.394609</td>
      <td>0.394414</td>
      <td>9.365854</td>
      <td>6.0</td>
      <td>8.074074</td>
      <td>9.080119</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3d3c...</td>
    </tr>
    <tr>
      <th>2762</th>
      <td>Bastrop</td>
      <td>Texas</td>
      <td>48</td>
      <td>021</td>
      <td>48021</td>
      <td>48</td>
      <td>21</td>
      <td>48021</td>
      <td>1</td>
      <td>3.938946</td>
      <td>...</td>
      <td>11.792071</td>
      <td>0.370264</td>
      <td>0.419933</td>
      <td>0.390927</td>
      <td>0.380907</td>
      <td>14.747191</td>
      <td>12.5</td>
      <td>10.559006</td>
      <td>12.281387</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3d3c...</td>
    </tr>
    <tr>
      <th>2769</th>
      <td>Hays</td>
      <td>Texas</td>
      <td>48</td>
      <td>209</td>
      <td>48209</td>
      <td>48</td>
      <td>209</td>
      <td>48209</td>
      <td>1</td>
      <td>5.016555</td>
      <td>...</td>
      <td>3.383424</td>
      <td>0.385061</td>
      <td>0.424973</td>
      <td>0.378992</td>
      <td>0.372266</td>
      <td>13.064187</td>
      <td>9.4</td>
      <td>10.003691</td>
      <td>10.337188</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3d3c...</td>
    </tr>
    <tr>
      <th>2795</th>
      <td>Caldwell</td>
      <td>Texas</td>
      <td>48</td>
      <td>055</td>
      <td>48055</td>
      <td>48</td>
      <td>55</td>
      <td>48055</td>
      <td>1</td>
      <td>9.677544</td>
      <td>...</td>
      <td>10.704001</td>
      <td>0.380080</td>
      <td>0.412614</td>
      <td>0.410802</td>
      <td>0.413940</td>
      <td>15.229616</td>
      <td>10.5</td>
      <td>12.894034</td>
      <td>17.191502</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3ce4...</td>
    </tr>
    <tr>
      <th>2798</th>
      <td>Comal</td>
      <td>Texas</td>
      <td>48</td>
      <td>091</td>
      <td>48091</td>
      <td>48</td>
      <td>91</td>
      <td>48091</td>
      <td>1</td>
      <td>3.359538</td>
      <td>...</td>
      <td>0.854684</td>
      <td>0.274182</td>
      <td>0.359174</td>
      <td>0.375810</td>
      <td>0.380032</td>
      <td>11.315107</td>
      <td>7.6</td>
      <td>8.693149</td>
      <td>9.104427</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3ce4...</td>
    </tr>
    <tr>
      <th>2808</th>
      <td>Guadalupe</td>
      <td>Texas</td>
      <td>48</td>
      <td>187</td>
      <td>48187</td>
      <td>48</td>
      <td>187</td>
      <td>48187</td>
      <td>1</td>
      <td>5.743759</td>
      <td>...</td>
      <td>5.649500</td>
      <td>0.340374</td>
      <td>0.388821</td>
      <td>0.354559</td>
      <td>0.378073</td>
      <td>11.758921</td>
      <td>9.6</td>
      <td>10.418149</td>
      <td>12.918448</td>
      <td>&lt;pysal.cg.shapes.Polygon object at 0x7f08d3ce4...</td>
    </tr>
  </tbody>
</table>
<p>10 rows × 70 columns</p>
</div>



### Moving in and out of the dataframe

Most things in PySAL will be explicit about what type their input should be. Most of the time, PySAL functions require either lists or arrays. This is why the file-handler methods are the default IO method in PySAL: the rest of the computational tools are built around their datatypes. 

However, it is very easy to get the correct datatype from Pandas using the `values` and `tolist` commands. 

`tolist()` will convert its entries to a list. But, it can only be called on individual columns (called `Series` in `pandas` documentation).

So, to turn the `NAME` column into a list:


```python
data_table.NAME.tolist()[0:10]
```




    ['Lake of the Woods',
     'Ferry',
     'Stevens',
     'Okanogan',
     'Pend Oreille',
     'Boundary',
     'Lincoln',
     'Flathead',
     'Glacier',
     'Toole']



To extract many columns, you must select the columns you want and call their `.values` attribute. 

If we were interested in grabbing all of the `HR` variables in the dataframe, we could first select those column names:


```python
HRs = [col for col in data_table.columns if col.startswith('HR')]
HRs
```




    ['HR60', 'HR70', 'HR80', 'HR90']



We can use this to focus only on the columns we want:


```python
data_table[HRs]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>HR60</th>
      <th>HR70</th>
      <th>HR80</th>
      <th>HR90</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>8.855827</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>17.208742</td>
      <td>15.885624</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.863863</td>
      <td>1.915158</td>
      <td>3.450775</td>
      <td>6.462453</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2.612330</td>
      <td>1.288643</td>
      <td>3.263814</td>
      <td>6.996502</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>7.770008</td>
      <td>7.478033</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>4.573101</td>
      <td>4.000640</td>
    </tr>
    <tr>
      <th>6</th>
      <td>7.976390</td>
      <td>5.536179</td>
      <td>5.633168</td>
      <td>5.720497</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1.011173</td>
      <td>1.689475</td>
      <td>4.490115</td>
      <td>2.814460</td>
    </tr>
    <tr>
      <th>8</th>
      <td>11.529039</td>
      <td>9.273857</td>
      <td>28.227324</td>
      <td>5.500096</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0.000000</td>
      <td>5.708740</td>
      <td>0.000000</td>
      <td>6.605892</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>11</th>
      <td>3.574045</td>
      <td>3.840688</td>
      <td>7.413585</td>
      <td>1.888146</td>
    </tr>
    <tr>
      <th>12</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>13</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>14</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>15</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>16</th>
      <td>2.945942</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>17</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>19.161808</td>
      <td>5.219752</td>
    </tr>
    <tr>
      <th>18</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>19</th>
      <td>0.000000</td>
      <td>8.117213</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>20</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>21</th>
      <td>0.000000</td>
      <td>4.864050</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>22</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2.218377</td>
    </tr>
    <tr>
      <th>23</th>
      <td>4.119804</td>
      <td>9.910312</td>
      <td>14.287755</td>
      <td>14.863258</td>
    </tr>
    <tr>
      <th>24</th>
      <td>5.530668</td>
      <td>0.000000</td>
      <td>12.421589</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25</th>
      <td>5.854801</td>
      <td>5.811757</td>
      <td>6.504065</td>
      <td>4.045798</td>
    </tr>
    <tr>
      <th>26</th>
      <td>0.000000</td>
      <td>10.811980</td>
      <td>0.000000</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>27</th>
      <td>1.422131</td>
      <td>2.439530</td>
      <td>4.061193</td>
      <td>2.086920</td>
    </tr>
    <tr>
      <th>28</th>
      <td>2.138534</td>
      <td>2.142245</td>
      <td>5.518079</td>
      <td>3.756292</td>
    </tr>
    <tr>
      <th>29</th>
      <td>0.708135</td>
      <td>1.138434</td>
      <td>0.570854</td>
      <td>1.150993</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>3055</th>
      <td>0.000000</td>
      <td>0.000000</td>
      <td>2.107526</td>
      <td>0.739919</td>
    </tr>
    <tr>
      <th>3056</th>
      <td>0.000000</td>
      <td>0.970572</td>
      <td>4.400324</td>
      <td>0.825491</td>
    </tr>
    <tr>
      <th>3057</th>
      <td>0.611430</td>
      <td>2.568301</td>
      <td>1.974919</td>
      <td>2.828994</td>
    </tr>
    <tr>
      <th>3058</th>
      <td>2.022286</td>
      <td>2.033140</td>
      <td>0.000000</td>
      <td>3.987956</td>
    </tr>
    <tr>
      <th>3059</th>
      <td>0.850723</td>
      <td>1.981012</td>
      <td>2.782690</td>
      <td>2.260130</td>
    </tr>
    <tr>
      <th>3060</th>
      <td>1.790825</td>
      <td>3.732470</td>
      <td>5.757329</td>
      <td>4.007173</td>
    </tr>
    <tr>
      <th>3061</th>
      <td>0.556604</td>
      <td>1.060271</td>
      <td>1.010560</td>
      <td>2.769193</td>
    </tr>
    <tr>
      <th>3062</th>
      <td>0.000000</td>
      <td>1.756836</td>
      <td>5.505395</td>
      <td>2.907653</td>
    </tr>
    <tr>
      <th>3063</th>
      <td>0.427592</td>
      <td>3.688132</td>
      <td>2.625587</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>3064</th>
      <td>0.896660</td>
      <td>2.704530</td>
      <td>4.229303</td>
      <td>2.938915</td>
    </tr>
    <tr>
      <th>3065</th>
      <td>1.051403</td>
      <td>5.379304</td>
      <td>7.057466</td>
      <td>3.424679</td>
    </tr>
    <tr>
      <th>3066</th>
      <td>2.095434</td>
      <td>6.671377</td>
      <td>9.243279</td>
      <td>7.285916</td>
    </tr>
    <tr>
      <th>3067</th>
      <td>1.872835</td>
      <td>3.951663</td>
      <td>5.339935</td>
      <td>3.201065</td>
    </tr>
    <tr>
      <th>3068</th>
      <td>1.917913</td>
      <td>6.382639</td>
      <td>1.304631</td>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>3069</th>
      <td>1.939789</td>
      <td>4.960564</td>
      <td>0.000000</td>
      <td>6.072530</td>
    </tr>
    <tr>
      <th>3070</th>
      <td>5.452765</td>
      <td>15.156192</td>
      <td>24.841012</td>
      <td>28.268787</td>
    </tr>
    <tr>
      <th>3071</th>
      <td>7.520089</td>
      <td>9.163383</td>
      <td>10.590286</td>
      <td>6.443839</td>
    </tr>
    <tr>
      <th>3072</th>
      <td>7.202448</td>
      <td>9.746302</td>
      <td>11.850014</td>
      <td>12.561604</td>
    </tr>
    <tr>
      <th>3073</th>
      <td>8.253379</td>
      <td>15.655752</td>
      <td>21.173432</td>
      <td>16.479507</td>
    </tr>
    <tr>
      <th>3074</th>
      <td>2.181802</td>
      <td>3.074760</td>
      <td>3.191133</td>
      <td>3.300700</td>
    </tr>
    <tr>
      <th>3075</th>
      <td>4.902862</td>
      <td>11.782264</td>
      <td>7.680787</td>
      <td>18.362582</td>
    </tr>
    <tr>
      <th>3076</th>
      <td>18.513376</td>
      <td>17.133324</td>
      <td>15.034136</td>
      <td>12.027015</td>
    </tr>
    <tr>
      <th>3077</th>
      <td>4.159907</td>
      <td>4.126434</td>
      <td>3.967782</td>
      <td>6.585273</td>
    </tr>
    <tr>
      <th>3078</th>
      <td>5.403098</td>
      <td>5.970974</td>
      <td>4.127839</td>
      <td>2.586787</td>
    </tr>
    <tr>
      <th>3079</th>
      <td>1.121183</td>
      <td>1.096311</td>
      <td>2.442074</td>
      <td>2.806112</td>
    </tr>
    <tr>
      <th>3080</th>
      <td>5.046682</td>
      <td>13.152054</td>
      <td>13.251761</td>
      <td>5.521552</td>
    </tr>
    <tr>
      <th>3081</th>
      <td>3.411368</td>
      <td>7.393533</td>
      <td>11.453817</td>
      <td>8.691999</td>
    </tr>
    <tr>
      <th>3082</th>
      <td>1.544425</td>
      <td>6.023552</td>
      <td>5.280349</td>
      <td>4.367330</td>
    </tr>
    <tr>
      <th>3083</th>
      <td>9.302820</td>
      <td>1.800148</td>
      <td>3.000030</td>
      <td>3.727712</td>
    </tr>
    <tr>
      <th>3084</th>
      <td>3.396162</td>
      <td>2.284879</td>
      <td>1.194743</td>
      <td>2.048855</td>
    </tr>
  </tbody>
</table>
<p>3085 rows × 4 columns</p>
</div>



With this, calling `.values` gives an array containing all of the entries in this subset of the table:


```python
data_table[['HR90', 'HR80']].values
```




    array([[  0.        ,   8.85582713],
           [ 15.88562351,  17.20874204],
           [  6.46245315,   3.4507747 ],
           ..., 
           [  4.36732988,   5.2803488 ],
           [  3.72771194,   3.00003   ],
           [  2.04885495,   1.19474313]])



Using the PySAL pdio tools means that if you're comfortable with working in Pandas, you can continue to do so. 

If you're more comfortable using Numpy or raw Python to do your data processing, PySAL's IO tools naturally support this. 

## Exercises

1. Find the county with the western most centroid that is within 1000 miles of Austin.
2. Find the distance between Austin and that centroid.
