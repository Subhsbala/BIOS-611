FROM rocker/verse
RUN R -e "install.packages(\"tidyverse\")"
RUN R -e "install.packages(\"dplyr\")"
RUN R -e "install.packages(\"lubridate\")"
RUN R -e "install.packages(\"ggplot2\")"
RUN R -e "install.packages(\"scales\")"
RUN R -e "install.packages(\"corrplot\")"
RUN R -e "install.packages(\"maps\")"
RUN R -e "install.packages(\"ggmap\")"
RUN R -e "install.packages(\"mapdata\")"
RUN R -e "install.packages(\"stats\")"
RUN R -e "install.packages(\"pROC\")"
RUN R -e "install.packages(\"png\")"
