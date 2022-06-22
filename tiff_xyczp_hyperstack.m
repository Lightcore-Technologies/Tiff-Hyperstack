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
dims = [300, 400, 4, 10, 20]; % [nrow, ncol, nchan, nz, npol]
nbits = 16;


%% Create 5D matrix, get Fiji descriptor and get the tiff structure parameters
stack = create_5d_matrix(dims, nbits);
fiji_descr = create_fiji_descriptor(dims, nbits);
tagstruct = get_tiff_parameters(dims, nbits);


%% Create 5D hyperstack tiff file
save_tiff_xyczp_hyperstack(stack, tagstruct, 'name','test.tif');


%% Read the created hyperstack
[read_stack, read_dims, read_info] = read_tiff_xyczp_hyperstack('test.tif');


%% Sanity check
bool_dims = isequal(dims, read_dims);
bool_stack = isequal(stack, read_stack);

fprintf('\nEquality tests (shows 1 if equal):\n')
fprintf('\t - Dimensions equality = %d\n', bool_dims)
fprintf('\t - Stack equality = %d\n', bool_stack)


