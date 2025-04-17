# eReefs Tutorials

This repository holds the source files for the AIMS Knowledge Systems eReefs tutorials hosted at
https://open-aims.github.io/ereefs-tutorials/. 

Currently, a few basic tutorials are available for the languages `R` and `python`. In time we hope to add a
wider range of tutorials, including for more advanced concepts. If you wish to see a tutorial on a specific
topic you can add a request using the GitHub Issues feature, though please note that the development of
subsequent tutorials is dependent on the time availability of the small number of contributing AIMS staff.


## Developer Overview

This is a static [Quarto website](https://quarto.org/docs/websites) hosted on GitHub Pages. 

Webpages can be edited and added via the GitHub repository. To do this, we must clone the repository,
make changes to the relevant Quarto (`.qmd`) documents, or add new Quarto documents to add new webpages,
render the amended website on a local machine (using Quarto), and then push the changes to the repository.

> This process can be changed by using GitHub Actions to render the Quarto website, though at present local
> rendering is sufficient. 

## Rendering the website with Docker

It's highly recommended to render the website using the Docker image available on eReefs AWS ECR,
to ensure consistent output.

The following instructions will tell you how to pull the Docker image from AWS ECR,
then clone the repository and run the Docker image.

If you are not able to pull the Docker image, you can create a fresh one using the `Dockerfile`,
but the fresh Docker image will have different version of the dependencies which could produce
a different output.

### 1. Setup AWS CLI

You will need to install AWS CLI to pull the Docker image from AWS ECR.

#### 1.1 Install AWS CLI

Download and install AWS CLI by following the instructions found on the AmazonAWS website:

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

#### 1.2 Setup dev user on AWS

You will need an AWS API Key with access rights to ECR in order to pull the Docker image.

Log to the eReefs AWS account website and create a dev user, if you don't already have one.
Add the `AmazonEC2ContainerRegistryFullAccess` policy to your dev user. That will allow you to
pull the Docker image and push a new one later if needed.

#### 1.3 Create API key

Create an API key to use with your dev user.

- Navigate to *IAM > Users > Your dev user*
- Click on *Security credentials* tab
- Scroll down to *Access keys* and click the *Create access key* button
- Select *Use case: Command Line Interface (CLI)*
- Click the *Create access key* button

The following webpage shows your new *Access key* and its (hidden) *Secret access key*.
The *Secret access key* has a clipboard icon that can be used to copy the secret key.

Keep that browser window open, we will need it to copy the *Access key* and the *Secret access key*
in the next step.

#### 1.4 Configure a AWS profile for AWS CLI

Run the following AWS CLI command on your system to configure a new AWS profile.

Change `<AWS PROFILE>` to an appropriate profile name. For example: `ereefs-prod`

```shell
aws configure --profile <AWS PROFILE>
```

- *AWS Access Key ID [None]*: Copy the *Access key* from the AWS browser window from the previous step.
- *AWS Secret Access Key [None]*: Copy the *Secret access key* from the AWS browser window.
- *Default region name [None]*: ap-southeast-2
- *Default output format [None]*: json

Note: AWS will save your profile information in the `.aws` folder in your home directory.

### 2. Pull the Docker image from ECR

Run the following command to pull (download) the Docker image from AWS ECR.
The command is using the AWS API key that is defined in your AWS profile.

```shell
aws ecr get-login-password --region ap-southeast-2 --profile <AWS PROFILE> | docker login --username AWS --password-stdin <AWS ACCOUNT ID>.dkr.ecr.ap-southeast-2.amazonaws.com
docker pull <AWS ACCOUNT ID>.dkr.ecr.ap-southeast-2.amazonaws.com/ereefs-tutorials-quarto:<TAG>
```

Change:  
- `<AWS ACCOUNT ID>` to the ID of the AWS account.
- `<AWS PROFILE>` to your profile name.
- `<TAG>` to the latest version available on AWS ECR.

### 3. Clone the git repository to your machine

From the command line: 

```shell
git clone https://github.com/open-AIMS/ereefs-tutorials.git
```

### 4. Render the website with the Docker image

Generate a local copy of the website by running this Docker command:

```shell
docker run --rm --user $(id -u):$(id -g) -v $PWD:/usr/local/src/ereefs-tutorials ereefs-tutorials-quarto:<TAG>
```

Change:  
- `<TAG>` to the version of the image that was pulled from ECR earlier.

This will mount the working directory to the Docker image and run the
command `quarto render /usr/local/src/ereefs-tutorials`
in the container.

The generated website can be found in the `docs` folder.

We recommend previewing the generated website using a web server such as `Apache` or `nginx`.

## Making changes to the tutorials

**Edit existing tutorials** by editing the corresponding
`tutorials/<language>/<tutorial-category>/<tutorial-name>/<tutorial_name>.qmd` file. 
  
**Create a new tutorial** by creating a new folder in the corresponding
`tutorials/<language>/<tutorial-category>` folder.
Name it with the tutorial name and create a `<tutorial_name>.qmd` file within the folder.

Refresh the local copy of the website using the Docker command:

```shell
docker run --rm --user $(id -u):$(id -g) -v $PWD:/usr/local/src/ereefs-tutorials ereefs-tutorials-quarto:<TAG>
```


## Create a fresh Docker image

If you can't pull the image from AWS ECR, or the image needs to be updated with the latest version of the
dependencies, you will need to create a fresh Docker image.

### Create the Docker image

The Docker image is created using the `Dockerfile`. To generate a new Docker image with the latest
version of the dependencies, run the following code:

```shell
docker build -t ereefs-tutorials-quarto:<TAG> .
```

Change:  
- `<TAG>` to a version number higher than the latest version available on ECR.

### Upload the Docker image to AWS ECR

If you can, upload the new Docker image to AWS ECR so other developers can use the same version of the
dependencies. This is important to ensure consistent output.

```shell
docker tag ereefs-tutorials-quarto:1.0 <AWS ACCOUNT ID>.dkr.ecr.ap-southeast-2.amazonaws.com/ereefs-tutorials-quarto:<TAG>
aws ecr get-login-password --region ap-southeast-2 --profile <AWS PROFILE> | docker login --username AWS --password-stdin <AWS ACCOUNT ID>.dkr.ecr.ap-southeast-2.amazonaws.com
docker push <AWS ACCOUNT ID>.dkr.ecr.ap-southeast-2.amazonaws.com/ereefs-tutorials-quarto:<TAG>
```

Change:  
- `<AWS ACCOUNT ID>` to the ID of the AWS account.
- `<AWS PROFILE>` to your profile name.
- `<TAG>` to the same version number as in the previous step.

## Rendering the website without Docker

Rendering the website using Docker image from AWS ECR is the recommended approach, as it ensures consistent
output across different environments. However, if you can not use docker, you can render the website locally.
Be aware that using different versions of the required libraries may lead to variations in the rendered output.

If it is not possible to use Docker, install the necessary dependencies on your system and use Quarto to render
the website manually.

### Local machine requirements

To successfully render the website you will need the following:

* [Quarto](https://quarto.org/docs/get-started)
* [R](https://www.r-project.org/)
* [Python](https://wiki.python.org/moin/BeginnersGuide/Download)
* A [GitHub account](https://github.com/join) with permissions to push to the *ereefs-tutorials* repository
* The R packages and Python modules used within the scripts you are trying to render

  * R packages are installed from an R console with the command<br>
    `install.packages("<package_name>")` for packages hosted on CRAN; or<br>
    `remotes::install_github("<GitHub username>/<repo name>")` to install packages hosted in a GitHub
    repository.

  * Python modules are installed from a python console with the command<br>
    `pip/conda/mamba install <module name>`
    (depending on the python package manager installed on your machine)

The following are not required but recommended:

* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* An IDE such as [RStudio](https://posit.co/downloads/) or
  [Visual Studio Code](https://code.visualstudio.com/download)
  (with the R, Python, and Quarto extensions)

### Rendering process

It appears that a default GitHub action is set up to render a jekyll site. We added
a .nojekyll file to stop this, but it doesn't seem to be working. The jekyll action seems to work for the
markdown files, but local rendering is required to update content generated by code.

This section details the manual rendering process.

#### 1. Clone the git repository to your machine

From the command line: 

```shell
git clone https://github.com/open-AIMS/ereefs-tutorials.git
```

### 3. Render

Render a local copy of the website.

#### 3.1. Entire website

Edits to the YAML or CSS files require you to render the entire website to implement the changes. You can do
this with from the command line with

```shell
quarto preview <path to "ereefs-tutorials" folder> --render all --no-browser --no-watch-inputs
```

or by using the respective IDE controls (`Ctrl+Shift+P > Quarto: Render Project` in VS Code).

#### 3.2. Single page

Edits to a single `.qmd` file can be rendered from the command line with 

```shell
quarto preview <path to file> --no-browser --no-watch-inputs
``` 

or by using the respective IDE controls (`Ctrl+Shift+P > Quarto: Render` in VS Code).


## File structure

All website files are contained in the git repository `ereefs-tutorials`. This includes:

* :file_folder: `tutorials` contains the tutorial source files

  * :file_folder: `r` and `python` sort the source files by language.

    * :file_folder: `<tutorial-category>` to group the tutorials into categories.

      * :file_folder: `<tutorial-name>` contain the files associated with a specific tutorial, including the
        main tutorial file :page_facing_up: `<tutorial_name>.qmd` as well as other associated data, images, etc.

* :file_folder: `images` contains images for general use (e.g. the eReefs logo)

* :file_folder: `docs` contains the rendered website files - do not edit these file directly, they are
  updated automatically by Quarto upon rendering the website source files.

* :file_folder: `_extensions` contains Quarto extensions which extend Quarto's functionality (e.g. we use the
  fontawesome extension to include icons in virtually any of the website's text); do not edit.

* :file_folder: `_freeze` corresponds to the freeze execution option. This controls which code chunks are
  rendered. With freeze set to auto, the code output is reproduced only when the source code changes. This
  folder holds the cache-like items needed for this option.  

* :file_folder: `.quarto` contains files used by Quarto behind the scenes - knowledge of these files is not
  needed; do not edit.

* :page_facing_up: `index.qmd` the website homepage source file. All other webpages must be linked to, either
  directly or derivatively, from the home page (or else will not be reachable).

* :page_facing_up: `_quarto.yml` is used to set global YAML settings (including theming and navigation).

* :page_facing_up: `style.css` is a global CSS style sheet applied to all webpages (sourced from the YAML
  file).

* :page_facing_up: `theme_changes_<light/dark>.scss` alter the light and dark website themes (e.g. the link
  color was changed from the default green to blue)

* :page_facing_up: `README.md` the documentation file for the website (displayed on the repository home page
  on GitHub).

## Potential problems/errors/issues

`ImportError: DLL load failed: The specified module could not be found.` when rendering a python tutorial.
You can try these [Stackoverflow solutions](https://stackoverflow.com/questions/20201868/importerror-dll-load-failed-the-specified-module-could-not-be-found)
(downloading [Microsoft Visual C++](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170)
worked for us).


## Contributing to this project

**When contributing to this project please ensure you do the following:**

1. Tutorials should be self-contained in :file_folder:`tutorials/<tutorial language>/<tutorial-category>/<tutorial-name>`
  with a single :page_facing_up:`<tutorial_name>.qmd` file and all other files required to run the tutorial
  (e.g. images, data). This allows people to download the individual folders to run specific tutorials on
  their own machine.

2. Any file which does not pertain to a specific tutorial should be placed in either:

  * :file_folder:`~` style or theme files (e.g. YAML, CSS, SCSS) belong in the home folder
  * :file_folder:`~/images` for images
  * :file_folder:`~/resources` not yet created; would house any file which is not an image or style/theme
    file and which does not pertain to a specific tutorial

3. Pay attention to the folder structure and file naming conventions used already. It would be nice to keep
  these consistent. 

4. Push changes to the repository only after the *entire* website has rendered successfully (rather than just
  the specific tutorial) and you have tested it in a browser window (including a check that links work as
  desired). This will ensure the website will not break the next time it is rendered as a whole. 

5. Check file links are correct. 

6. Update this `README.md` documentation file as you go, including the resolution of any errors/issues you
  have encountered. 


---
