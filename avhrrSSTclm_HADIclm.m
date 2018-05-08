%readin ORA grid
clear;clc;close all;tic;

% read OISST
ncid = netcdf.open('sst.mnmean.nc','nowrite');
varid = netcdf.inqVarID(ncid,'lon');
oi_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lat');
oi_lat = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'sst');
sst = netcdf.getVar(ncid,varid);
sst(:,:,1) = []; % remove 1981.12
%sst(:,:,end) = []; % remove 2017.1
netcdf.close(ncid);
lon_b = find(abs(oi_lon-180.5)<1e-6);
sst = cat(1,sst(lon_b:end,:,:),sst(1:lon_b-1,:,:));
sst = double(sst)/100;
yr_b = 1982;
yr_e = 2016;
N_yr = yr_e - yr_b + 1;
N_LON = length(oi_lon);
N_LAT = length(oi_lat);
sst = reshape(sst,N_LON,N_LAT,12,N_yr);

% read HADISST
ncid = netcdf.open('/Users/shu/data/HadISST_sst.nc.gz','nowrite');
varid = netcdf.inqVarID(ncid,'sst');
data = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'longitude');
lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'latitude');
lat = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
data = double(data);
HDyr_b = 1870;
yr_b2 = 1965;
yr_e2 = 2016;
N_yr2 = yr_e2 - yr_b2 + 1;
data2 = data(:,:,(yr_b2-HDyr_b)*12+1:(yr_e2-HDyr_b+1)*12);
data = data(:,:,(yr_b-HDyr_b)*12+1:(yr_e-HDyr_b+1)*12);
data2(abs(data2)>1e2) = NaN;
data(abs(data)>1e2) = NaN;

data = reshape(data,N_LON,N_LAT,12,N_yr);
data2 = reshape(data2,N_LON,N_LAT,12,N_yr2);

oi_clm_1982_2016 = squeeze(mean(sst,4));
hd_clm_1982_2016 = squeeze(mean(data,4));
hd_clm_1965_2016 = squeeze(mean(data2,4));

if 0
contourf(squeeze(oi_clm_1982_2016(:,:,12)-hd_clm_1982_2016(:,:,12)))
colorbar
stop
end

save /Users/shu/work/peru/RT/Package/sst_clm oi_clm_1982_2016 hd_clm_1982_2016 hd_clm_1965_2016 lat lon


toc;
