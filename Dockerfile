FROM r-base

RUN apt-get update && apt-get install -y \
    curl gdebi-core \
    libcurl4-openssl-dev libssl-dev libxml2-dev libfontconfig1-dev \
    libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
    
RUN install2.r knitr
RUN install2.r rmarkdown
RUN install2.r quarto
RUN install2.r tidyverse
RUN install2.r kableExtra
RUN install2.r DT

RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

CMD ["quarto", "render", "/usr/local/src/ereefs-tutorials"]
