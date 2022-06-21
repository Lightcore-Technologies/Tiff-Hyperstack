%{
    https://fr.mathworks.com/help/matlab/import_export/exporting-to-images.html#br_c_iz-5

    doc Tiff

    https://fr.mathworks.com/matlabcentral/answers/389765-how-can-i-save-an-image-with-four-channels-or-more-into-an-imagej-compatible-tiff-format
%}

clear all


%% File location
file = '16-17_ch0_NLimage X=150 Y=150_0.15__Anlge0-170-10-Rat-6_L1_ROI-1_800nm_80mW_chn0';
ext = '.tiff';


%% Get info about the file and initialize volume
info = imfinfo([file ext]);


%% Read all data from the file
for i=1:numel(info)
    img = imread([file ext], 'tif', 'Index', i);

    % Initialize stack from first image
    if i==1
        stack = nan([size(img), numel(info)], class(img));
    end

    stack(:,:,i) = img;
end


%% Attempt reading as a volume directly
V = tiffreadVolume([file ext]);



%% Play around with LibTiff
t = Tiff([file ext],'r');
% offsets = getTag(t,'SubIFD');
% setDirectory(t,17)
close(t)


%% Subdirectory tiff file
imgdata = imread('ngc6543a.jpg');
%
% Reduce number of pixels by a half.
img_half = imgdata(1:2:end,1:2:end,:);
%
% Reduce number of pixels by a third.
img_third = imgdata(1:3:end,1:3:end,:);

t = Tiff('my_subimage_file.tif','w');

tagstruct.ImageLength = size(imgdata,1);
tagstruct.ImageWidth = size(imgdata,2);
tagstruct.Photometric = Tiff.Photometric.RGB;
tagstruct.BitsPerSample = 8;
tagstruct.SamplesPerPixel = 3;
tagstruct.RowsPerStrip = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';
tagstruct.SubIFD = 2 ;  % required to create subdirectories
% tagstruct  % display tagstruct
setTag(t,tagstruct)


write(t,imgdata);

writeDirectory(t);

tagstruct2.ImageLength = size(img_half,1);
tagstruct2.ImageWidth = size(img_half,2);
tagstruct2.Photometric = Tiff.Photometric.RGB;
tagstruct2.BitsPerSample = 8;
tagstruct2.SamplesPerPixel = 3;
tagstruct2.RowsPerStrip = 16;
tagstruct2.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct2.Software = 'MATLAB';
% tagstruct2  % display tagstruct2
setTag(t,tagstruct2)

write(t,img_half);
writeDirectory(t);

tagstruct3.ImageLength = size(img_third,1);
tagstruct3.ImageWidth = size(img_third,2);
tagstruct3.Photometric = Tiff.Photometric.RGB;
tagstruct3.BitsPerSample = 8;
tagstruct3.SamplesPerPixel = 3;
tagstruct3.RowsPerStrip = 16;
tagstruct3.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct3.Software = 'MATLAB';
% tagstruct3  % display tagstruct3
setTag(t,tagstruct3)


write(t,img_third);

close(t);




%% Test hyperspectral
MultiDimImg = zeros(300,400,4,5,6,'uint16');
fiji_descr = ['ImageJ=1.52p' newline ...
            'images=' num2str(size(MultiDimImg,3)*...
                              size(MultiDimImg,4)*...
                              size(MultiDimImg,5)) newline... 
            'channels=' num2str(size(MultiDimImg,3)) newline...
            'slices=' num2str(size(MultiDimImg,4)) newline...
            'frames=' num2str(size(MultiDimImg,5)) newline... 
            'hyperstack=true' newline...
            'mode=grayscale' newline...  
            'loop=false' newline...  
            'min=0.0' newline...      
            'max=65535.0'];  % change this to 256 if you use an 8bit image
            
t = Tiff('test.tif','w');
tagstruct.ImageLength = size(MultiDimImg,1);
tagstruct.ImageWidth = size(MultiDimImg,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 16;
tagstruct.SamplesPerPixel = 1;
tagstruct.Compression = Tiff.Compression.LZW;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
tagstruct.ImageDescription = fiji_descr;
for frame = 1:size(MultiDimImg,5)
    for slice = 1:size(MultiDimImg,4)
        for channel = 1:size(MultiDimImg,3)
            t.setTag(tagstruct)
            t.write(im2uint16(MultiDimImg(:,:,channel,slice,frame)));
            t.writeDirectory(); % saves a new page in the tiff file
        end
    end
end
t.close() 



%% File creation attempt
nrow = 256;
ncol = 256;
nchan = 4;
nz = 10;
npolar = 5;

fname = 'hypertest.tif';
hyper = uint16((2^16-1)*rand([nrow, ncol, nchan, nz, npolar], 'single'));

for c=1:nchan
    for z=1:nz
        for p=1:npolar
            if c==1 && z==1 && p==1
                imwrite(hyper(:,:,c,z,p), fname, 'Compression','none');
            else
                imwrite(hyper(:,:,c,z,p), fname, 'WriteMode','append', 'Compression','none');
            end
        end
    end
end

%% second test
fname2 = 'hypertest2.tif';
for z=1:nz
    for p=1:npolar
        if z==1 && p==1
            imwrite(hyper(:,:,:,z,p), fname2, 'Compression','none');
        else
            imwrite(hyper(:,:,:,z,p), fname2, 'WriteMode','append', 'Compression','none');
        end
    end
end

%% third test
% Error using writetif
% 4-D data not supported for TIFF files.

% fname3 = 'hypertest3.tif';
% 
% for p=1:npolar
%     if p==1
%         imwrite(hyper(:,:,:,:,p), fname3, 'Compression','none');
%     else
%         imwrite(hyper(:,:,:,:,p), fname3, 'WriteMode','append', 'Compression','none');
%     end
% end



%% Test hyperspectral LCT
nrow = 300;
ncol = 400;
nchan = 4;
nz = 10;
npolar = 20;
nbits = 16;

MultiDimImg = randi(2^nbits, [nrow, ncol, nchan, nz, npolar], ['uint' num2str(nbits)]);

fiji_descr = ['ImageJ=1.52p' newline ...
            'images=' num2str(size(MultiDimImg,3)*...
                              size(MultiDimImg,4)*...
                              size(MultiDimImg,5)) newline... 
            'channels=' num2str(size(MultiDimImg,3)) newline...
            'slices=' num2str(size(MultiDimImg,4)) newline...
            'frames=' num2str(size(MultiDimImg,5)) newline... 
            'hyperstack=true' newline...
            'mode=grayscale' newline...  
            'loop=false' newline...  
            'min=0.0' newline...      
            'max=65535.0'];  % change this to 256 if you use an 8bit image
            
t = Tiff('test2.tif','w');
tagstruct.ImageLength = size(MultiDimImg,1);
tagstruct.ImageWidth = size(MultiDimImg,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 16;
tagstruct.SamplesPerPixel = 1;
tagstruct.Compression = Tiff.Compression.None;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
tagstruct.ImageDescription = fiji_descr;
for frame = 1:size(MultiDimImg,5)
    for slice = 1:size(MultiDimImg,4)
        for channel = 1:size(MultiDimImg,3)
            t.setTag(tagstruct)
            t.write(im2uint16(MultiDimImg(:,:,channel,slice,frame)));
            t.writeDirectory(); % saves a new page in the tiff file
        end
    end
end
t.close() 



%% Test temporal hyperspectral LCT
nrow = 300;
ncol = 400;
nchan = 4;
nz = 3;
npolar = 5;
nt = 2;
nbits = 16;

MultiDimImg = randi(2^nbits, [nrow, ncol, nchan, nz, npolar, nt], ['uint' num2str(nbits)]);

fiji_descr = ['ImageJ=1.52p' newline ...
            'images=' num2str(size(MultiDimImg,3)*...
                              size(MultiDimImg,4)*...
                              size(MultiDimImg,5)*...
                              size(MultiDimImg,6)) newline... 
            'channels=' num2str(size(MultiDimImg,3)) newline...
            'slices=' num2str(size(MultiDimImg,4)) newline...
            'frames=' num2str(size(MultiDimImg,5)) newline... 
            'hyperstack=true' newline...
            'mode=grayscale' newline...  
            'loop=false' newline...  
            'min=0.0' newline...      
            'max=65535.0'];  % change this to 256 if you use an 8bit image
            
t = Tiff('test3.tif','w');
tagstruct.ImageLength = size(MultiDimImg,1);
tagstruct.ImageWidth = size(MultiDimImg,2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 16;
tagstruct.SamplesPerPixel = 1;
tagstruct.Compression = Tiff.Compression.None;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
tagstruct.ImageDescription = fiji_descr;
for time = 1:size(MultiDimImg,6)
    for frame = 1:size(MultiDimImg,5)
        for slice = 1:size(MultiDimImg,4)
            for channel = 1:size(MultiDimImg,3)
                t.setTag(tagstruct)
                t.write(im2uint16(MultiDimImg(:,:,channel,slice,frame,time)));
                t.writeDirectory(); % saves a new page in the tiff file
            end
        end
    end
end
t.close() 