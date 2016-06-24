# Install howto


The materials for the workshop and all software packages have been tested on
the following three platforms:

- Linux (Ubuntu-Mate x64)
- Windows 10 (x64)
- Mac OS X (10.11.5 x64).


## Linux/Mac OS X

1. Install Anaconda
2. conda update conda
3. conda config --add channels conda-forge
4. conda create --name gds-scipy16 python=3 pandas numpy matplotlib bokeh seaborn scikit-learn jupyter
5. conda install --name gds-scipy16 geopandas==0.2 mplleaflet==0.0.5 datashader==0.2.0 geojson cartopy==0.14.2 folium==0.2.1
6. source activate gds-scipy16
7. jupyter notebook


## Windows

1. Install
   [Anaconda3-4.0.0-Windows-x86-64](http://repo.continuum.io/archive/Anaconda3-4.0.0-Windows-x86_64.exe)
2. open a cmd window
3. conda update conda
4. conda config --add channels conda-forge
4. conda create --name gds-scipy16 pandas numpy matplotlib bokeh seaborn scikit-learn jupyter geopandas==0.2 mplleaflet==0.0.5 datashader==0.2.0 geojson cartopy==0.14.2 folium==0.2.1
5. activate gds-scipy16
6. jupyter notebook

