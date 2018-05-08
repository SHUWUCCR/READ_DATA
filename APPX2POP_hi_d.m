clear;clc;close all;

yr=1982;
mn=1;
fid = fopen(['SP/mean_' num2str(yr) num2str(mn,'%2.2i') '99_1400.params'],'rb');
a = fread(fid,31,'int16');
N_LON = a(end-1);
N_LAT = a(end);
fclose(fid);
hi_d = zeros(23,N_LON,N_LAT);
k=1;
%/Users/shu/data/APPX/new/South/1400/1982/
for yr = [1982:1994 1995:2005]
    yr
    for mn = 3:3 
        fid = fopen(['/Users/shu/data/APPX/new/South/1400/' num2str(yr) '/mean_' num2str(yr) num2str(mn,'%2.2i') '99_1400.params'],'rb');
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
        c = fread(fid,N_LON*N_LAT,'int16');
        c = reshape(c,N_LON,N_LAT);
        hi_d(k,:,:) = c;
        fclose(fid);
    end
    k=k+1;
end
hi_d(hi_d>9000) = 0;
CLM = squeeze(nanmean(hi_d));
SP = CLM/100;
SP = reshape(SP,1,N_LON*N_LAT);
%-------
yr=1982;
mn=1;
fid = fopen(['NP/mean_' num2str(yr) num2str(mn,'%2.2i') '99_1400.params'],'rb');
a = fread(fid,31,'int16');
N_LON = a(end-1);
N_LAT = a(end);
fclose(fid);
hi_d = zeros(23,N_LON,N_LAT);
k=1;
for yr = [1982:1994 1995:2005]
    yr
    for mn = 3:3
        fid = fopen(['/Users/shu/data/APPX/new/North/1400/' num2str(yr) '/mean_' num2str(yr) num2str(mn,'%2.2i') '99_1400.params'],'rb');
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
        c = fread(fid,N_LON*N_LAT,'int16');
        c = reshape(c,N_LON,N_LAT);
        hi_d(k,:,:) = c;
        fclose(fid);
    end
    k=k+1;
end
hi_d(hi_d>9000) = 0;
CLM = squeeze(nanmean(hi_d));
NP = CLM/100;
NP = reshape(NP,1,N_LON*N_LAT);
APPX = cat(2,NP,SP);


% read lat lon from APPX
ncid = netcdf.open('Polar-APP-X_v01r01_Shem_1400_d19881231_c20151221.nc','nowrite');
varid = netcdf.inqVarID(ncid,'longitude')
sappx_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'latitude')
sappx_lat = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
ncid = netcdf.open('Polar-APP-X_v01r01_Nhem_1400_d19881231_c20151221.nc','nowrite');
varid = netcdf.inqVarID(ncid,'longitude')
nappx_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'latitude')
nappx_lat = netcdf.getVar(ncid,varid);
netcdf.close(ncid);

LAT = [nappx_lat(:);sappx_lat(:)];
LON = [nappx_lon(:);sappx_lon(:)];

% read lat lon from POP2
ncid = netcdf.open('fldo1.nc','nowrite');
varid = netcdf.inqVarID(ncid,'tpop_lon')
pop_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'tpop_lat')
pop_lat = netcdf.getVar(ncid,varid);
netcdf.close(ncid);

%read in mask
ncid = netcdf.open('b.e11.B20TRC5CNBDRD.f09_g16.007.cice.h1.1990-06-27.nc','nowrite');
varid = netcdf.inqVarID(ncid,'tmask');
tmask = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
land1 = abs(tmask-1)>0.5;
land2 = abs(pop_lat)<50;
land = (land1 | land2);
water = find(land<1);
pop_lon_w = pop_lon(water);
pop_lat_w = pop_lat(water);
M = length(pop_lat_w);
APPX2POP_w = zeros(12,M);

for m = 1:M
    M - m 
    d_lon = pop_lon_w(m) - LON;
    d_lat = pop_lat_w(m) - LAT;
    d_lon(abs(d_lon)>180) = 360-abs(d_lon(abs(d_lon)>180)); 
    DD = sqrt(d_lat.^2+d_lon.^2);
    [c d] = sort(DD(:));
    wgt = c(1:4);
    wgt = 1./wgt;
    wgt = wgt/sum(wgt); 
    APPX2POP_w(:,m) = APPX(:,d(1:4))*wgt(:);
end
 

%hi_d(isnan(hi_d)) = 9999;
%save SP.mat hi_d

N_LON = 320;
N_LAT = 384;
stop
APPX2POP = ones(12,N_LON*N_LAT)*(-999);
APPX2POP(:,water) = APPX2POP_w;

APPX2POP = reshape(APPX2POP,12,N_LON,N_LAT);

DATAOUT = 'THK_MARCLM_1982_2005_APPX2POP.nc'
system(['rm -f ' DATAOUT])

nccreate(DATAOUT, 'month', 'Dimensions',{'month', 12}, 'Format', 'Classic');
ncwrite(DATAOUT, 'month', [1:12]);

nccreate(DATAOUT, 'lon', 'Dimensions',{'lon', N_LON}, 'Format', 'Classic');
ncwrite(DATAOUT, 'lon', [1:N_LON]);
nccreate(DATAOUT, 'lat', 'Dimensions',{'lat', N_LAT}, 'Format', 'Classic');
ncwrite(DATAOUT, 'lat', [1:N_LAT]);

nccreate(DATAOUT, 'APPX2POP', 'Dimensions',{'month', 12, 'lon', N_LON,'lat',N_LAT}, 'Format', 'Classic');
ncwrite(DATAOUT, 'APPX2POP', APPX2POP);


