# eReefs Tutorials

*WORK IN PROGRESS*


# User Overview

This repository holds the source files for the AIMS Knowledge Systems eReefs tutorials hosted at https://bfordaims.github.io/ereefs-tutorials/. 

Currently, a few basic tutorials are available for the languages `R` and `python`. In time we hope to add a wider range of tutorials, including for more advanced concepts. If you wish to see a tutorial on a specific topic you can add a request using the Github Issues feature, though please note that the development of subsequent tutorials is dependent on the time availability of the small number of contributing AIMS staff.


# Developer Overview

This is a static [Quarto website](https://quarto.org/docs/websites) hosted by Github Pages. 

Webpages can be edited and added via the Github repository. To do this we must clone the repository, make changes to the relevant Quarto (`.qmd`) documents, or add new Quarto documents to add new webpages, render the amended website on a local machine (using Quarto), and then push the changes to the repository.

> This process can be changed by using Github Actions to render the Quarto website, though at present local rendering is sufficient. 

## Rendering the website

### Local machine requirements

To successfully render the website you will need the following:

#### Required:

* [Quarto](https://quarto.org/docs/get-started)
* [R](https://www.r-project.org/)
* [Python](https://wiki.python.org/moin/BeginnersGuide/Download)
* A [Github account](https://github.com/join) with permissions to push to the ereefs-tutorials repository
* The R packages and Python modules used within the scripts you are trying to render

  * R packages are installed from an R console with the command <br>`install.packages("<package_name>")` for packages hosted on CRAN; or <br>`remotes::install_github("<Github username>/<repo name>")` to install packages hosted in a Github repository.
  * Python modules are installed from a python console with the command <br> `pip/conda/mamba install <module name>` (depending on the python package manager installed on your machine)

#### Recommended:

* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* An IDE such as [R Studio](https://posit.co/downloads/) or [Visual Studio Code](https://code.visualstudio.com/download) (with the R, Python, and Quarto extensions)


### Rendering process

#### 1. Clone the git repository to your machine

From the command line: 

```
git clone <repo url>
```

#### 2. Make changes:

**Edit existing tutorials** by editing the corresponding `tutorials/<language>/<tutorial-name>/<tutorial_name>.qmd` file. 
  
**Create a new tutorial** by creating a new folder in the corresponding `tutorials/<language>` folder; name it with the tutorial name; and create a `<tutorial_name>.qmd` file within the folder

#### 3. Render:

##### 3.1. Entire website
Edits to the YAML or CSS files require you to render the entire website to implement the changes. You can do this with from the command line with

```
quarto preview <path to "ereefs-tutorials" folder> --render all --no-browser --no-watch-inputs
```

or by using the respective IDE controls (`ctrl+shft+p > Quarto: Render Project` in VS Code).

##### 3.2. Single page
Edits to a single `.qmd` file can be rendered from the command line with 

```
quarto preview <path to file> --no-browser --no-watch-inputs
``` 

or by using the respective IDE controls (`ctrl+shft+p > Quarto: Render` in VS Code).


## File structure

All website files are contained in the git repository `ereefs-tutorials`. This includes:

* :file_folder: `tutorials` contains the tutorial source files

  * :file_folder: `r` and `python` sort the source files by language.

    * :file_folder: `<tutorial-name>` contain the files associated with a specific tutorial, including the main tutorial file :page_facing_up: `<tutorial_name>.qmd` as well as other associated data, images, etc.

* :file_folder: `images` contains images for general use (e.g. the eReefs logo)

* :file_folder: `docs` contains the rendered website files - do not edit these file directly, they are updated automatically by Quarto upon rendering the website source files.

* :file_folder: `_extensions` contains Quarto extensions which extend Quarto's functionality (e.g. we use the fontawesome extension to include icons in virtually any of the website's text); do not edit.

* :file_folder: `_freeze` corresponds to the freeze execution option. This controls which code chunks are rendered. With freeze set to auto, the code output is reproduced only when the source code changes. This folder holds the cache-like items needed for this option.  

* :file_folder: `.quarto` contains files used by Quarto behind the scenes - knowledge of these files is not needed; do not edit.

* :page_facing_up: `index.qmd` the website homepage source file. All other webpages must be linked to, either directly or derivatively, from the home page (or else will not be reachable).

* :page_facing_up: `_quarto.yml` is used to set global YAML settings (including theming and navigation).

* :page_facing_up: `style.css` is a global CSS style sheet applied to all webpages (sourced from the YAML file).

* :page_facing_up: `theme_changes_<light/dark>.scss` alter the light and dark website themes (e.g. the link color was changed from the default green to blue)

* :page_facing_up: `README.md` the documentation file for the website (displayed on the repository home page on Github).

## Potential problems/errors/issues

`ImportError: DLL load failed: The specified module could not be found.` when rendering a python tutorial. Try the solutions [here](https://stackoverflow.com/questions/20201868/importerror-dll-load-failed-the-specified-module-could-not-be-found) (downloading [Microsoft Visual C++](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170) worked for me).


# Contributing to this project

##### *When contributing to this project please ensure you do the following:*

1. Tutorials should be self-contained in :file_folder:`tutorials/<tutorial language>/<tutorial-name>` with a single :page_facing_up:`<tutorial_name>.qmd` file and all other files required to run the tutorial (e.g. images, data). This allows people to download the individual folders to run specific tutorials on their own machine.


2. Any file which does not pertain to a specific tutorial should be placed in either:
  
    * :file_folder:`~` style or theme files (e.g. YAML, CSS, SCSS) belong in the home folder
    * :file_folder:`~/images` for images
    * :file_folder:`~/resources` not yet created; would house any file which is not an image or style/theme file and which does not pertain to a specific tutorial

3. Pay attention to the folder structure and file naming conventions used already. It would be nice to keep these consistent. 

4. Push changes to the repository only after the *entire* website has rendered successfully (rather than just the specific tutorial) and you have tested it in a browser window (including a check that links work as desired). This will ensure the website will not break the next time it is rendered as a whole. 

5. Check file links are correct. 

6. Update this `README.md` documentation file as you go, including the resolution of any errors/issues you have encountered. 


---