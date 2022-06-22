function [hyperstack, dims, info] = read_tiff_xyczp_hyperstack(file, opts)
    % Saves a tiff 5D XYCZP hyperstack from the input 5D matrix
    %
    % Inputs:
    %   * matrix5D: 5D matrix to be saved into tiff hyperstack
    %   * tagstruct: Tiff tag structure

    arguments
        file char
        opts.path char = []
        opts.ext char = '.tif'
    end


    %% Check for empty file argument
    if isempty(file)
        warning('Empty file, returning.')
        return
    end


    %% Path and file checking
    % Get path, name, and extension of file
    [filepath, name, ext] = fileparts(file);

    % If file has no extension, add it '.tif' by default
    if isempty(ext)
        filename = [name opts.ext];
    else
        filename = [name ext];
    end

    % Combine optional path with detected file path
    fullpath = fullfile(opts.path, filepath);
    
    % Check whether file exists as '.tif' or '.tiff'
    tif_fullfile = fullfile(fullpath, filename);
    tiff_fullfile = fullfile(fullpath, [name '.tiff']);

    is_tif = exist(tif_fullfile, 'file');
    is_tiff = exist(tiff_fullfile, 'file');

    % Assign file to load based on file existence results
    if not(is_tif) && not(is_tiff)
        warning('File not found, returning.')
        return
    end

    if is_tif
        file2load = tif_fullfile;
    elseif is_tiff
        file2load = tiff_fullfile;
    else
        warning('Invalid file, returning.')
        return
    end


    %% Data loading and shaping as a 5D XYCZP hyperstack
    % Get information about the tiff file
    info = imfinfo(file2load);

    % Extract the 5D XYCZP dimensions based on info structure
    dims = nan(1,5);
    
    % X and Y are easy: directly stored in appropriate info structure
    dims(1) = info(1).Height;
    dims(2) = info(1).Width;

    % Extract C, Z and P, from the ImageDescription field
    CZP = extract_CZP_from_descr(info(1).ImageDescription);
    if isempty(CZP)
        warning('Invalid dimensionality, returning.')
        return
    else
        dims(3:5) = CZP;
    end


    % Read the complete tiff volume and reshape with appropriate dimensions
    hyperstack = tiffreadVolume(file2load);
    hyperstack = reshape(hyperstack, dims);
end



function CZP = extract_CZP_from_descr(descr)
    ntot = get_value_from_string_and_expr(descr, 'images=[0-9]*', '=');
    nchan = get_value_from_string_and_expr(descr, 'channels=[0-9]*', '=');
    nz = get_value_from_string_and_expr(descr, 'slices=[0-9]*', '=');
    npol = get_value_from_string_and_expr(descr, 'frames=[0-9]*', '=');
    
    CZP = [];
    if are_extracted_dims_ok([nchan, nz, npol], ntot)
        CZP = [nchan, nz, npol];
    else
        warning('Inconsistent dimension extraction, returning empty array.')
    end
end



function value = get_value_from_string_and_expr(string, expr, delimiter)
    arguments
        string char
        expr char
        delimiter char = '='
    end

    [startIndex, stopIndex] = regexp(string, expr);
    substr = string(startIndex:stopIndex);
    value = get_value_from_string(substr, delimiter);
end



function number = get_value_from_string(string, delimiter)
    arguments
        string char
        delimiter char = '='
    end

    idx = strfind(string, delimiter);
    number = str2double(string(idx+1:end));
end



function bool = are_extracted_dims_ok(dims, tot)
    if prod(dims) == tot
        bool = true();
    else
        bool = false();
    end
end
