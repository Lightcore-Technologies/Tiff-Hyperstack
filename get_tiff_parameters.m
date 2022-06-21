function tagstruct = get_tiff_parameters(dims, nbits)
    % Create a random 5D matrix for polarization microscopy
    %
    % Inputs:
    %   * dims: 5D vector of integers, defining the dimensions of the
    %   matrix [nrows, ncols, nchans, nzplanes, npolar]
    %   * nbits: number of bytes of the uint 5D matrix

    arguments
        dims (1,5) double = [300, 400, 4, 10, 20]
        nbits (1,1) double = 16
    end

    fiji_descr = create_fiji_descriptor(dims, nbits);

    tagstruct.ImageLength = dims(1);
    tagstruct.ImageWidth = dims(2);
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.BitsPerSample = nbits;
    tagstruct.SamplesPerPixel = 1;
    tagstruct.Compression = Tiff.Compression.None;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
    tagstruct.ImageDescription = fiji_descr;
end

