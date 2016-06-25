# Install guide

The materials for the workshop and all software packages have been tested on
Python 2 and 3 on the following three platforms:

- Linux (Ubuntu-Mate x64)
- Windows 10 (x64)
- Mac OS X (10.11.5 x64).

The workshop depends on the following libraries/versions:

* `numpy>=1.11`
* `pandas>=0.18.1`
* `matplotlib>=1.5.1`
* `jupyter>=1.0`
* `seaborn>=0.7.0`
* `pip>=8.1.2`
* `geopandas>=0.2`
* `pysal>=1.11.1`
* `cartopy>=0.14.2`
* `pyproj>=1.9.5`
* `shapely>=1.5.16`
* `geopy>=1.10.0`
* `scikit-learn>=0.17.1`
* `bokeh>0.11.1`
* `mplleaflet>=0.0.5`
* `datashader>=0.2.0`
* `geojson>=1.3.2`
* `folium>=0.2.1`
* `statsmodels>=0.6.1`
* `xlrd>=1.0.0`
* `xlsxwriter>=0.9.2`

## Linux/Mac OS X

1. Install Anaconda
2. Get the most up to date version:

`> conda update conda`

3. Add the `conda-forge` channel:

`> conda config --add channels conda-forge`

4. Create an environment named `gds-scipy16`:

`> conda create --name gds-scipy16 python=3 pandas numpy matplotlib bokeh seaborn scikit-learn jupyter statsmodels xlrd xlsxwriter`

5. Install additional dependencies:

`> conda install --name gds-scipy16 geojson geopandas==0.2 mplleaflet==0.0.5 datashader==0.2.0 cartopy==0.14.2 folium==0.2.1`

6. To activate and launch the notebook:

```
> source activate gds-scipy16

> jupyter notebook
```

## Windows

1. Install
   [Anaconda3-4.0.0-Windows-x86-64](http://repo.continuum.io/archive/Anaconda3-4.0.0-Windows-x86_64.exe)
2. open a cmd window
3. Get the most up to date version:

`> conda update conda`

4. Add the `conda-forge` channel:

`> conda config --add channels conda-forge`

5. Create an environment named `gds-scipy16`:

`> conda create --name gds-scipy16 pandas numpy matplotlib bokeh seaborn statsmodels scikit-learn jupyter xlrd xlsxwriter geopandas==0.2 mplleaflet==0.0.5 datashader==0.2.0 geojson cartopy==0.14.2 folium==0.2.1`

6. To activate and launch the notebook:

```
> activate gds-scipy16

> jupyter notebook
```

# Testing

Once installed, you can run the notebook `test.ipynb` placed under
`content/infrastructure/test.ipynb` to make sure everything is correctly
installed. Follow the instructions in the notebook and, if you do not get any
error, you are good to go.

# Support

If you have any questions or run into problems, you can open a GitHub issue on
the projec repository:

> [https://github.com/darribas/gds_scipy16](https://github.com/darribas/gds_scipy16)

Alternatively, you can contact [Serge Rey](mailto:sjsrey@gmail.com) or [Dani Arribas-Bel](mailto:D.Arribas-Bel@liv.ac.uk).

