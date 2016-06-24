# Install howto

1. Install Anaconda
2. conda update conda
3. conda config --add channels conda-forge
4. conda create --name gds-scipy16 python=3 pandas numpy matplotlib bokeh seaborn scikit-learn jupyter
5. conda install --name gds-scipy16 geopandas==0.2 mplleaflet==0.0.5 datashader==0.2.0 geojson cartopy==0.14.2 folium==0.2.1
6. source activate gds-scipy16

Note the script (install.sh)[install.sh] runs steps 2-5 on Linux/Mac OS X 

The materials for the workshop and all software packages have been tested on
the following three platforms:

- Linux (Ubuntu-Mate x64)
- Windows 10 (x64)
- Mac OS X (10.11.5 x64).

