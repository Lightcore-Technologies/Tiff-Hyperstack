# Tiff-Hyperstack

Saving and reading Tiff 5D hyperstacks.
It exploits the natural tiff hyperstack features allowing to save up to a 5D matrix with XYCZT dimensions.

In this example, the dimensions order is the following: XYCZP, where:
1. X is the first spatial transverse dimension (number of rows)
2. Y is the second spatial transverse dimension (number of columns)
3. C is the channels dimensions (can be RGB or something else)
4. Z is the spatial longitudinal dimension
5. P is the polarization dimension (replacing the defalt time)

Saved hyperstacks tiff files can be easily visualized using Fiji/ImageJ thanks to a dedicated cursor per dimension.


## Compatibility

It should be compatible with the polarimetry software of the Cell Morphogenesis lab that can be downloaded [here](https://sites.google.com/view/cell-morphogenesis-lab/polarimetry). This software requires Matlab R2022a Runtime.

The source codes are available here:
- [Polarimetry](https://github.com/cchandre/Polarimetry)
- [PolarimetryContour](https://github.com/cchandre/PolarimetryContour)

Typical example stacks can be found here (ask a Lightcore Technologies person to access it):
[https://lightcoretechnologies.sharepoint.com/:f:/s/www.lightcoreteams.com/EnMm0MwHigdDgazuSyZ3haQB1REjYQo4lzuL2YGK9sCQgg?e=4y6dqN](https://lightcoretechnologies.sharepoint.com/:f:/s/www.lightcoreteams.com/EnMm0MwHigdDgazuSyZ3haQB1REjYQo4lzuL2YGK9sCQgg?e=4y6dqN)

It should also be compatible for quick visualization using [Fiji/ImageJ](https://imagej.net/software/fiji/downloads).
