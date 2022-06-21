function save_tiff_xyczp_hyperstack(matrix5D, tagstruct, opts)
    % Create a random 5D matrix for polarization microscopy
    %
    % Inputs:
    %   * dims: 5D vector of integers, defining the dimensions of the
    %   matrix [nrows, ncols, nchans, nzplanes, npolar]
    %   * nbits: number of bytes of the uint 5D matrix

    arguments
        matrix5D (:,:,:,:,:)
        tagstruct

        opts.path char = pwd
        opts.name char = 'test.tif'
    end

    filepath = fullfile(opts.path, opts.name);
    t = Tiff(filepath,'w');

    for polar = 1:size(matrix5D,5)
        for z = 1:size(matrix5D,4)
            for chan = 1:size(matrix5D,3)
                t.setTag(tagstruct)
                t.write(im2uint16(matrix5D(:,:,chan,z,polar)));
                t.writeDirectory(); % saves a new page in the tiff file
            end
        end
    end
    
    t.close() 
end

