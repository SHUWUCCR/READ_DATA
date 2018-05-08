%readin ORA grid
clear;clc
tic;

ncid = netcdf.open('sst.mnmean.nc','nowrite');
varid = netcdf.inqVarID(ncid,'lon');
oi_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lat');
oi_lat = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'sst');
sst = netcdf.getVar(ncid,varid);
sst(:,:,1) = []; % remove 1981.12
yr_b = 1982;

netcdf.close(ncid);
oi_lon_N = length(oi_lon);
oi_lat_N = length(oi_lat);
yr_1 = 2005;
mn_1 = 8;
yr_2 = 2005;
mn_2 = 11;
data(:,:,1) = squeeze(sst(:,:,(yr_1-yr_b)*12+mn_1));
data(:,:,2) = squeeze(sst(:,:,(yr_2-yr_b)*12+mn_2));

lon_b = find(abs(oi_lon-180.5)<1e-6);
data = cat(1,data(lon_b:end,:,:),data(1:lon_b-1,:,:));
sst = double(data)/100;
save sst_2005_08_11 sst

toc;
