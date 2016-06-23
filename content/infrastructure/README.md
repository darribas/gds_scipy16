# Install howto

The materials for the workshop and all software packages have been tested on
the following three platforms:

- Linux (Ubuntu-Mate x64)
- Windows 10 (x64)
- Mac OS X (10.11.5 x64).

To create the identical environments to the ones tested above use the
following steps:

1. Install Anaconda
2. OS Specific Package Installations
   
   - Linux: `conda create --name gds-scipy16 --file gds-scipy16-linux-spec-file.txt`
   - Mac: `conda create --name gds-scipy16   --file gds-scipy16-mac-spec-file.txt`
   - Windows: `conda create --name gds-scipy16 --file gds-scipy16-windows-spec-file.txt`

3. Activate your environment
  
   - Linux/Mac: `source activate gds-scipy16`
   - Windows: `activate gds-scipy16` 

4. Navigate to the folder `content` via `cd ..`
5. From a terminal/cmd window `jupyter notebook`

At this point you can start to open the tutorial notebooks



## Rebuilding the Environments

Here we record how the spec files above were created. This is not needed for
the tutorials, but may be useful if new packages were to be added or updated
for future workshops.

The spec files used above were created as follows.

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

On Linux/OS X:  `source activate gds`

On Windows: `activate gds`


From there you can fire up jupyter and open the notebooks for the tutorial.


### Notes

This approach grabs the latest versions of the packages listed in the
[environment.yml](environment.yml) file while resolving any conflicts.

Because some packages may be updated by the time the tutorial occurs,
this could cause some differences between the versions used to prepare the
materials, and possiblity some conflicts.

An alternative that avoides these two possibilities is to use a pinned environment.

## Pinned Environment

To avoid potential problems induced by package clashes we can use an explicit
pinning. To do so we first create the spec file. On linux this was done with:

```
source activate gds
conda list --explicit > gds-scipy16-linux-spec-file.txt
```

This creates the file
[gds-scipy16-linux-spec-file.txt](gds-scipy16-linux-spec-file.txt) that can be used on
a different machine but same platform to create an identical environment using
the command:

```
conda create --name gds-scipy16 --file gds-scipy16-linux-spec-file.txt
```

Once this is built you can activate it:

```
source activate gds-scipy16
```

On Windows the process is

```
activate scipy16
conda list --explicit > gds-scipy16-windows-spec-file.txt
```

This creates the file
[gds-scipy16-windows-spec-file.txt](gds-scipy16-windows-spec-file.txt) that can be used on
a different machine but same platform to create an identical environment using
the command:

```
conda create --name gds-scipy16 --file gds-scipy16-windows-spec-file.txt
```

Once this is built you can activate it:

```
activate gds-scipy16
```

On Mac OS X this was done with:

```
source activate scipy16
conda list --explicit > gds-scipy16-mac-spec-file.txt
```

This creates the file
[gds-scipy16-mac-spec-file.txt](gds-scipy16-mac-spec-file.txt) that can be used on
a different machine but same platform to create an identical environment using
the command:

```
conda create --name gds-scipy16 --file gds-scipy16-mac-spec-file.txt
```

Once this is built you can activate it:

```
source activate gds-scipy16
```
