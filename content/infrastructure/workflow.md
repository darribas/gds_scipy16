# Development workflow

## Dependencies

In addition to the packages required to run the tutorial (see the [install
guide](README.md) for more detail), you will need the following libraries:

* [`npm` and `node.js`](https://nodejs.org)
* [`gitbook`](https://github.com/GitbookIO/gitbook)
* [`make`](https://www.gnu.org/software/make/)
* `cp`, `rm`, and `zip` Unix utilities.

## Workflow

The overall structure of the workflow is as follows:

1. Develop material on Jupyter notebooks and place them under the `content/`
   folder.
1. When you want to build the website with the new content run on, the root
   folder:

   `> make notebooks`
1. When you want to obtain a new version of the pdf or ebook formats, run on
   the root folder:

   `> make book`
1. When you want to push a new version to the website to Github Pages, make
   sure to commit all your changes first on the `master` branch (assuming your
   remote is named as `origin`):

   ```
   > git add .
   > git commit -m "commit message"
   > git push origin master
   ```

   Then you can run:

   `> make website`

   This will compile a new version of the website, pdf, eupb and mobi files,
   check them in, switch to the `gh-pages` branch, check the new version of the
   website and push it to Github.

