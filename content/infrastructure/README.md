# Install howto

Install description here to be exposed on the website/ebook/pdf.


## Using environment.yml

We followed the
[guidelines](http://conda.pydata.org/docs/using/envs.html#share-an-environment)
for sharing an environment to create the file
[environment.yml](environment.yml):

This environment can be created on your machine with:

```
conda env create -f environment.yml
```

Once this is complete (it may take 10-20 minutes depending on your connection
and processor) you can activate the environment.

On Linux/OS X:  `source activate scipy16`

On Windows: `activate scipy16`

We need two additional packages once the environment is activated:

```
conda install -c ioos folium=0.2.0
conda install -c ioos geojson=1.3.2
```

From there you can fire up jupyter and open the notebooks for the tutorial.

This approach has been tested on Linux, (not yet Mac OS X), and Windows 10.

### Notes

However, because some packages may be updated by the time the tutorial occurs,
there could be conflicts that arise.

An alternative is to use a pinned environment

## Pinned Environment

To avoid potential problems induced by package clashes we can use an explicit
pinning. To do so we first create the spec file. On linux this was done with:

```
source activate scipy16
conda list --explicit > scipy16-linux-spec-file.txt
```

This creates the file
[scipy16-linux-spec-file.txt](scipy16-linux-spec-file.txt) that can be used on
a different machine but same platform to create an identical environment using
the command:

```
conda create --name scipy16-pinned --file scipy16-linux-spec-file.txt
```

Once this is built you can activate it:

```
source activate scipy16-pinned
```

On Windows the process is

```
activate scipy16
conda list --explicit > scipy16-windows-spec-file.txt
```

This creates the file
[scipy16-windows-spec-file.txt](scipy16-windows-spec-file.txt) that can be used on
a different machine but same platform to create an identical environment using
the command:

```
conda create --name scipy16-pinned --file scipy16-windows-spec-file.txt
```

Once this is built you can activate it:

```
activate scipy16-pinned
```

Note that we don't need to uses the additional conda install calls when using a pinned approach
since the spec file here was created *after* geojson and folium were conda installed into the
env.
