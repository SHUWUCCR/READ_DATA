filename ='v2p0chirps19810101.bil';
% From the .hdr file, I obtained the following arguments for the MUTLIBANDREAD function.
size =      [ 1600 1500 1];      % [ NROWS NCOLS NBANDS]
precision = 'int16';                  % from NBITS and PIXEL TYPE = int
offset = 0;                              % since the header is not included in this file
interleave = 'bil';                     % LAYOUT
byteorder = 'ieee-le';              % BYTEORDER = I (refers to Intel order or little endian format)
X_bil = multibandread(filename, size, precision, offset, interleave, byteorder);
figure, imagesc(X_bil)               % Display the image file using IMAGESC
demcmap(X_bil) 
