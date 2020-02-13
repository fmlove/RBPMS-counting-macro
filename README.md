# RBPMS-counting-macro
An ImageJ macro for counting RBPMS-stained retinal ganglion cells from whole mount images

# Installation instructions
This macro depends on Thomas Boudier's 3D ImageJ Suite, particularly the 3D Edge and Symmetry Filter plugin.  Installation instructions for the 3D ImageJ Suite are available on the [documentation wiki](https://imagejdocu.tudor.lu/plugin/stacks/3d_ij_suite/start). 

To use this macro, clone or download the repository.  The `Counter.ijm` file can then be dragged and dropped directly into Fiji and run from the macro editor.

# Getting started
* Drag and drop the `Counter.ijm` file into Fiji and click 'Run', or navigate to Plugins > Macros > Run... and select the `Counter.ijm` file.
* Select the folder containing images to be counted.
* Select the file extension of the images to be counted.
* Adjust any parameters as necessary (the default values have been optimised on a selection of RBPMS images with manual counts).
* Click 'OK'.  The macro will save a file called `results.csv`, containing the counted cell numbers for each file, in the folder with your images.
