%{
    Create 5D XYCZP Tiff hyperstack
    
    The hyperstack five dimensions are:
    1. X: transverse spatial dimension
    2. Y: transverse spatial dimension
    3. C: channel dimension (can be RBG or several PMT channels)
    4. Z: longitudinal spatial dimension
    5. P: polarization dimension    
%}

clear all


%% Setup image parameters
dims = [nrow, ncol, nchan, nz, npolar]; % [nrow, ncol, nchan, nz, npol]
nbits = 16;

%% Create 5D matrix, get Fiji descriptor and get the tiff structure parameters
M = create_5d_matrix(dims, nbits);
fiji_descr = create_fiji_descriptor(dims, nbits);
tagstruct = get_tiff_parameters(dims, nbits);

%% Create 5D hyperstack tiff file
save_tiff_xyczp_hyperstack(M, tagstruct)


