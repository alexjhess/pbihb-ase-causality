# pbihb-ase-causality

This repo contains the analysis code for the 'Causality in the ASE Theory' project.
The individual steps of the analysis are outlined in detail in the corresponding analysis plan available under <https://doi.org/10.5281/zenodo.10559656>.
The data used for the analysis are available on Zenodo under <https://doi.org/10.5281/zenodo.10992529>.


## Contributors / Roles
|                               |                                             |
| ----------------------------- | ------------------------------------------- |
| Project lead / analysis       | Alex J. Hess                                |
| Code review                   | Dina von Werder                             |
| License                       | GNU General Public License v3.0             |


## Getting started

The analysis code is located in the `main.R` file. The folder `renv` contains all specifiations of the RStudio "project" used to create a reproducible computational environment. The code can be run in via [Binder](https://mybinder.org/) in an executable environment (does not require any installations) or on a local work station. Binder is the recommended running way of running the code for reproducibility and compatibility purposes. However, we provide instructions for running the code via Binder or locally.


### Run analysis on Google Colab

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/alexjhess/pbihb-ase-causality/blob/main/colab/main.ipynb)


### Run analysis on Binder

1. Click the following badge to launch the repo on Binder: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/alexjhess/pbihb-ase-causality/HEAD)  
:warning: Binder can take a long time to load, but this doesn’t necessarily mean that your Binder will fail to launch. You can always refresh the window if you see the “… is taking longer to load, hang tight!” message. If everything ran smoothly, you’ll see a JupyterLab interface.

2. In the JupyterLab, select RStudio from the Launcher panel. Upon startup of RStudio, renv 1.0.7 is bootstrapping automatically. 

3. Open and run the script `main.R` to reproduce the results reported in the publication.


### Run analysis locally

0. Requirements: The analysis pipeline was built using the following software:
  * Windows 11 Pro, Version 23H2, OS build 22631.3447
  * [R 4.2.1](https://cran.r-project.org/)
  * [RStudio IDE 2023.12.1](https://docs.posit.co/previous-versions/rstudio/)
  * [renv 1.0.7](https://rstudio.github.io/renv/)  

1. Install repository: Clone this repository using the command (ssh protocol used for communication with github.com):
```
git clone git@github.com:alexjhess/pbihb-ase-causality.git
```

2. Get data: The data set used in the analysis is freely available on Zenodo under <https://doi.org/10.5281/zenodo.10992529>.
Download and save the files within the `data` folder of the code repository.

3. Create R project environment: Open RStudio 2023.12.1 from directory of the `pbihb_ase_causality` repository. Upon startup of RStudio, renv 1.0.7 is bootstrapping automatically. Next, restore the R project necessary to run the analysis. In the console, type
```
renv::restore()
```

4. When asked "Do you want to proceed? [Y/n]:" type `y` and hit enter.  
:warning: Please note that environment was built using Windows 11, no guarantees can be made for compatibility with different operating systems). However, all relevant packages are specified in the `install.R` file and may be installed manually instead of using `renv`.

5. Run the analysis: Open and run the script `main.R` to reproduce the results reported in the publication.
(Make sure that your working directory in RStudio is set to the directory of the `pbihb_ase_causality` repository when running the analysis.)


## License information
This software is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You can find the details of the GNU General Public License v3.0 in the file `LICENSE` or under <https://www.gnu.org/licenses/>.


## Contact information

Suggestions and feedback are always welcome and should be directed to the project lead (AJH) via e-mail: <hess@biomed.ee.ethz.ch>


## Reference

TBD
