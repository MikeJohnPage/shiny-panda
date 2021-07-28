# Shiny Panda

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<p align="center">
  <img height="200" src="www/logo.png">
</p>

## Overview
Shiny Panda allows you to generate [Pandas Profiling](https://github.com/pandas-profiling/pandas-profiling) reports on the web using R Shiny. Upload a file. Get back a Pandas Profiling report.

## FAQ
*What file formats can I upload to Shiny Panda?*

You can upload `.csv`, `.tsv`, `.xls`, and `.xlsx`. This list may expand in the future.

*Is there a max file size?*

Yes, the max file size is currently capped at 5 MB, but this limit may be increased in the future.

*Is it normal for it to take a long time to generate a report?*

Yes, unfortunately, sometimes pandas can be slow.

*Is the data I upload stored in the cloud?*

Yes, but only while the report is being generated. Once you exit your session, any data you uploaded is automatically deleted. The app is provided [without warranty](LICENSE) and should be used at your own risk.