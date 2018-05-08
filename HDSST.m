clear;clc;tic
% read HADISST
ncid = netcdf.open('/Users/shu/data/HaDISST/HadISST_sst.nc','nowrite');
varid = netcdf.inqVarID(ncid,'sst');
data = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'longitude');
lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'latitude');
lat = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'time');
time = netcdf.getVar(ncid,varid);
HDyr_b = 1870;
yr = 1870:2014;

% lat from North to South
% lon -179 179
% choose the region
if 0 % nino12
lat_b = 0;
lat_e = -10;
lon_b = -90;
lon_e = -80;
end

if 0 % nino34
lat_b = 5;
lat_e = -5;
lon_b = -170;
lon_e = -120;
end

if 1 % peru costal
lat_b = -10;
lat_e = -30;
lon_b = -80;
lon_e = -60;
end

if lon_e>lon(end)
   lon_e = lon_e-360;
end

[c lat_b] = min(abs(lat-lat_b));
[c lat_e] = min(abs(lat-lat_e));
[c lon_b] = min(abs(lon-lon_b));
[c lon_e] = min(abs(lon-lon_e));

if lon_b > lon_e
   lon_idx = [lon_b:length(lon) 1:lon_e];
else
   lon_idx = lon_b:lon_e;
end
NT = size(data,3);   
N_LON = length(lon_idx);
N_LAT = lat_e-lat_b+1;
NT = size(data,3);
PI = 3.1415926;
wgt = cos(lat(lat_b:lat_e)*PI/180);
TP_IDX = squeeze(data(lon_idx,lat_b:lat_e,:));
for t = 1:NT
    TP_IDX(:,:,t) = squeeze(TP_IDX(:,:,t)).*repmat(wgt',N_LON,1);
end
TP_IDX = reshape(TP_IDX,N_LON*N_LAT,NT);
TP_IDX(abs(TP_IDX)>100) = NaN;
TP_IDX = nanmean(TP_IDX);
NT = floor(NT/12)*12;
TP_IDX = TP_IDX(1:NT);

PRCST = TP_IDX;

save PRCST_HDSST PRCST yr

%save SST_IDX NTP_IDX STP_IDX NTA_IDX STA_IDX yr

toc