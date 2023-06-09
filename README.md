21-07771-003: Shoreline Change Analysis
================
Regina Lionheart
2023-07-12

![dumbbell_plot](https://img.shields.io/badge/plot-dumbbell-%231D455C)
![boxplot](https://img.shields.io/badge/plot-boxplot-%231D455C)
![3D_regression](https://img.shields.io/badge/plot-3D%20regression-%231D455C)

![quartiles](https://img.shields.io/badge/stats-quartiles-%233ECDA3)
![HCA_clustering](https://img.shields.io/badge/stats-HCA%20clustering-%233ECDA3)
![linear_model](https://img.shields.io/badge/stats-linear%20model-%233ECDA3)

------------------------------------------------------------------------

![](images_output/Herrera_lockup_4c.png)

## Table of Contents

- [Project Description](#Project-Description)
- [Location in Herrera Database](#Location-in-Herrera-Database)  
- [Requirements and Dependencies](#Requirements-and-Dependencies)
- [Installation and Usage](#Installation-and-Usage)
  - [Layout of directory and data](#Layout-of-directory-and-data)
  - [Detailed description of data and
    analysis](#Detailed-description-of-data-and-analysis)
  - [Metadata](#Metadata)
  - [Data discrepancies](#Data-discrepancies)
- [Visualizations](#Visualization)
- [Pull Requests](#Pull-Requests)
- [Contributors and Contact
  Information](#Contributors-and-Contact-Information)

------------------------------------------------------------------------

# Project 21-07771 - Task 003

Seashore Conservation Area

**SharePoint Site:** [SharePoint
Site](https://herrerainc.sharepoint.com/teams/21-07771-002)

**Vantagepoint Site:** [Vantagepoint
Site](https://herrerainc.deltekfirst.com/HerreraInc/app/#!ProjectView/view/0/0/21-07771-002/presentation)

------------------------------------------------------------------------

## Project Description

This analysis aims to characterize approximately 25 years of shoreline
profile transect data, provided by NANOOS (Northwest Association of
Networked Ocean Observing Systems). Using this data combined with area
expertise, the relevant coastal areas have been characterized and
delineated into “reaches”.

## :droplet: Location in Herrera Database

The original, unmodified data used in this project is located in the
“data_raw” folder within this repository. That folder is backed up to
[SharePoint](https://herrerainc.sharepoint.com/teams/21-07771-002-InternalDocs/Shared%20Documents/Forms/AllItems.aspx?FolderCTID=0x0120008C8FFE1D422C224DA4CA697C7E7BF5DF&id=%2Fteams%2F21%2D07771%2D002%2DInternalDocs%2FShared%20Documents%2FInternal%20Docs%2FProject%2DFiles%2FTask%203%20Synthesis%20Shoreline%2FShorelineSynthesis%5Fdata%5Fraw&viewid=91d991bd%2De61d%2D4a39%2Dae3a%2Dac3ba8123673).

If you do not have access to the data, please contact the emails listed
at the bottom of the repository.

## 📦 Requirements and Dependencies

Below is a list of packages and external softwares that this project
utilizes. Please ensure you have the package(s) installed and have
access to the tools listed below.

| Name                                                                                                                                            | Description                                                                                                      |
|:------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------|
| [`R`](https://www.r-project.org/)                                                                                                               | Programming language used for this project.                                                                      |
| [`NANOOS Profile Data`](https://nvs.nanoos.org/BeachMapping)                                                                                    | The raw data for analysis. If you do not have access to this data, please contact the owners of this repository. |
| [`Washington Coastal Erosion and Hazard Assessment`](https://waecy.maps.arcgis.com/apps/View/index.html?appid=389d0a3ce642485db912d4a416a56e25) | A second database used to compare the accuracy of NANOOS data.                                                   |

## :computer: Installation and Usage

In order to run this script and recreate the analysis, you will need to
have R and Rstudio installed on your computer. All the data produced by
this analysis can be found in the data_secondary/ folder, while all
figures can be found in the figures/ directory.s

### :arrows_counterclockwise: Layout of directory and data

This repository is organized into a main Complete.Rmd markdown script,
which produces the results from scratch when run in its entirety. The
Complete.Rmd script references folders of raw data (data_raw/), and
produces results data that has been modified or created by the analysis
(data_secondary/). All analysis scripts are contained in the scripts/
directory, which also contains the src/ sub directory. The src/ sub
directory contains package loading scripts and scripts that produce or
modify data used throughout the analysis.

The data_raw/ folder is **READ ONLY** and should never be modified or
deleted.

### :heavy_check_mark: Detailed description of data and analysis

The raw data consists of approximately 4500 individual profiles across
54 coastal sites in Washington and Oregon, stretching from Moclips to
Cape Disappointment. The profiles are in x y z format (Easting Northing
elevation). The naming convention is prof_X_ssYY.out where prof is short
for profile, X is the profile number, ss is a season code (e.g. f =
fall) and YY is the year, in the format of the last two digits
(e.g. “98” is 1998”, “00” is 2000, “08” is 2008, etc).

Throughout the course of the analysis, the Control script loads and
tidies the raw profiles, creating a main csv of all profiles that
contain data (see below for data discrepancies). Profiles are visualized
and examined. Profiles are compared to an arbitrary “BasePoint” line set
a reasonable distance inland, and the Euclidean distance between this
BasePoint and each profile is calculated; over time, the increase and
decrease in this Euclidean distance is used as a proxy for shoreline
change (accretion or erosion). The rates of change are also calculated
for each profile.

These profiles are also compared to the [Washington Coastal Erosion and
Hazard
Assessment](https://waecy.maps.arcgis.com/apps/View/index.html?appid=389d0a3ce642485db912d4a416a56e25).

Finally, profiles are clustered into subreaches using a combination of
hierarchical agglomerative clustering and area knowledge. **Please be
aware that the final csv of subreach characterization CANNOT be produced
by this script, only the clustering that informed the final decision.**

The Complete.Rmd script contains comments and detailed description of
each step.

### :information_source: Metadata

The vertical datum is NAVD88. The horizontal is WA State Plane South.
All of the units are in meters.

### :exclamation: Data discrepancies

Quite a few profiles are null (empty) and have been removed and noted.
See the “Explore Profiles” section for more information.

A small portion of the profiles had non-conforming filenames: “BigE06”,
“beachface”, etc. These files do not represent a large percentage of the
files and have not been included in the analysis.

Profiles 42 - 47 are in Oregon and have been excluded from most of the
analysis.

*Geographically, profiles do not proceed sequentially.*

------------------------------------------------------------------------

## Visualization

<figure>
<img src="images_output/Fig1_ShorelineTransects1024_1.png"
alt="Geographic Location of all NANOOS Profiles" />
<figcaption aria-hidden="true">Geographic Location of all NANOOS
Profiles</figcaption>
</figure>

------------------------------------------------------------------------

## 🔧 Pull Requests

Pull requests are welcome. For major changes, please open an issue
first.

All functioning code is located on the main branch. Dev branches are to
be named <specific_issue_description>\_dev.

## 💬 Contributors + Contact Information

- [Regina Lionheart](https://github.com/R-Lionheart)
- [Andrea
  MacLennan](https://www.herrerainc.com/team-member/andrea-maclennan/)
- [Ian David
  Crickmore](https://www.herrerainc.com/team-member/ian-david-crickmore/)
