function M = create_5d_matrix(dims, nbits)
    % Create a random 5D matrix for polarization microscopy
    %
    % Inputs:
    %   * dims: 5D vector of integers, defining the dimensions of the
    %   matrix [nrows, ncols, nchans, nzplanes, npolar]
    %   * nbits: number of bytes of the uint 5D matrix
    % 
    % Outputs:
    %   * M: 5D random matrix

    arguments
        dims (1,5) double = [300, 400, 4, 10, 20]
        nbits (1,1) double = 16
    end


    %% Restrict binary range if too high
    if nbits > 64
        disp('Number of bits is too high, restricting to 64 bits.');
        nbits = 64;
    end


    %% Call the appropriate uint function depending on the number of bits
    avail_bits = [8, 16, 32, 64];
    idx = find(nbits == avail_bits);
    
    if ~isempty(idx)
        func_bits = avail_bits(idx);
    else
        if nbits <= 8
            func_bits = 8;
        else
            diff_bits = avail_bits - nbits;
            pos_diff_bits = diff_bits(diff_bits>0);
            idx = numel(avail_bits) - numel(pos_diff_bits) + 1;
            func_bits = avail_bits(idx);
        end
    end


    %% Return integer values between 0 and 2^nbits-1 and define data type accordingly    
    M = randi(2^nbits, dims, ['uint' num2str(func_bits)]);
end
