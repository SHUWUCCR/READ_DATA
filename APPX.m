clear;clc;close all;

yr=1982;
mn=1;
fid = fopen(['SP/mean_' num2str(yr) num2str(mn,'%2.2i') '99_1400.params'],'rb');
a = fread(fid,31,'int16');
N_LON = a(end-1);
N_LAT = a(end);
fclose(fid);
hi_d = zeros(7,12,N_LON,N_LAT);
k=1;
for yr = 1982:1988
    yr
    for mn = 1:12
        fid = fopen(['SP/mean_' num2str(yr) num2str(mn,'%2.2i') '99_1400.params'],'rb');
        a = fread(fid,31,'int16');
        N_LON = a(end-1);
        N_LAT = a(end);
        b = fread(fid,N_LON*N_LAT*4,'int16');
        c = fread(fid,N_LON*N_LAT,'int8');
        c = fread(fid,N_LON*N_LAT*2,'int16');
        c = fread(fid,N_LON*N_LAT,'int16');
        c = fread(fid,N_LON*N_LAT,'int8');
        c = fread(fid,N_LON*N_LAT*8,'int16');
        c = fread(fid,N_LON*N_LAT,'int16');
        c = fread(fid,N_LON*N_LAT,'int8');
        c = fread(fid,N_LON*N_LAT,'int16');
   %     c = fread(fid,N_LON*N_LAT,'int16');
        c = reshape(c,N_LON,N_LAT);
        hi_d(k,mn,:,:) = c;
        fclose(fid);
    end
    k=k+1;
end
hi_d(hi_d>9000) = 0;
CLM = squeeze(nanmean(hi_d));
hi_d = CLM/1000;
%hi_d(isnan(hi_d)) = 9999;
%save SP.mat hi_d

DATAOUT = 'SP_FRA_CLM_1982_1988_v2.nc'
system(['rm -f ' DATAOUT])

nccreate(DATAOUT, 'month', 'Dimensions',{'month', 12}, 'Format', 'Classic');
ncwrite(DATAOUT, 'month', [1:12]);

nccreate(DATAOUT, 'lon', 'Dimensions',{'lon', N_LON}, 'Format', 'Classic');
ncwrite(DATAOUT, 'lon', [1:N_LON]);
nccreate(DATAOUT, 'lat', 'Dimensions',{'lat', N_LAT}, 'Format', 'Classic');
ncwrite(DATAOUT, 'lat', [1:N_LAT]);

nccreate(DATAOUT, 'hi_d', 'Dimensions',{'month', 12, 'lon', N_LON,'lat',N_LAT}, 'Format', 'Classic');
ncwrite(DATAOUT, 'hi_d', hi_d);


