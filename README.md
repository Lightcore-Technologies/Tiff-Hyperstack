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
