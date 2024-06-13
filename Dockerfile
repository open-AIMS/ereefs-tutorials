FROM rocker/geospatial:4.3.1

# Install quarto
RUN apt-get update && apt-get install -y \
    curl gdebi-core

RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

# Install R dependencies
RUN apt-get install --fix-missing -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev libfontconfig1-dev \
    libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

RUN install2.r knitr
RUN install2.r rmarkdown
RUN install2.r quarto
RUN install2.r tidyverse
RUN install2.r kableExtra
RUN install2.r DT
RUN install2.r ggplot2
RUN install2.r here
RUN install2.r janitor
RUN install2.r plotly
    
## Install Python and its dependencies (including R reticulate package needed for the 'python' engine in knitr)
RUN apt-get install -y \
    build-essential wget

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_23.5.2-0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

RUN install2.r reticulate
RUN R
RUN conda install jupyter 
RUN conda install -c conda-forge netcdf4=1.5.8 pandas=1.4.2 pyjanitor=0.27.0 folium=0.16.0 cartopy=0.20.2 pip=24.0
RUN python -m pip install --force-reinstall matplotlib=3.7.5

RUN echo "RETICULATE_PYTHON = '/opt/conda/bin/python3'" >> /usr/local/lib/R/etc/Renviron

# define default commmand to render website
# CMD quarto render /usr/local/src/ereefs-tutorials --output-dir docs
