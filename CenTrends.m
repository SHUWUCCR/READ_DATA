% read chirps data
clear;clc;close all
FILE = '/Users/shu/data/CenTrends/CenTrends_v1_monthly.nc';
lon = ncread(FILE,'longitude');
lat = ncread(FILE,'latitude');
TIME = ncread(FILE,'time');


yr_b2 = 1900;
yr_b = 1981;
yr_e = 2014; % end of year is 2014
%Shukla Ethiopia
if 1
    lat_b = 6;
    lat_e = 14;
    lon_b = 34;
    lon_e = 40;
end
% N Blue Nile region
if 0
    lat_b = 9.6;
    lat_e = 11.6;
    lon_b = 36.6;
    lon_e = 38.6;
end
% Koga
if 0
    lat_b = 11.05;
    lat_e = 11.35;
    lon_b = 37.05;
    lon_e = 37.35;
end


[c LAT_B] = min(abs(lat_b-lat));
[c LAT_E] = min(abs(lat_e-lat));
[c LON_B] = min(abs(lon_b-lon));
[c LON_E] = min(abs(lon_e-lon));
lat_flip = 0;
if LAT_E<LAT_B
   tmp = LAT_E;
   LAT_E = LAT_B;
   LAT_B = tmp;
   lat_flip = 1;
end

N_LAT = LAT_E-LAT_B+1;
N_LON = LON_E-LON_B+1;

lon = lon(LON_B:LON_E);
lon = double(lon);
lat = double(lat);

START = [LON_B LAT_B 1];
COUNT = [N_LON N_LAT length(TIME)];
STRIDE = [1 1 1];

PR = ncread(FILE,'precip',START,COUNT,STRIDE);
N_yr = floor(length(TIME)/12);

PR = PR(:,:,1:N_yr*12);
PR = reshape(PR,N_LON,N_LAT,12,N_yr);
PR = PR(:,:,:,yr_b-yr_b2+1:yr_e-yr_b2+1);
N_yr = size(PR,4);
if lat_flip
   tmp = PR;
   lat = flipud(lat(:));
   lon = lon(:);
   for im = 1:N_LAT
       PR(:,im,:,:) = squeeze(tmp(:,end-im+1,:,:));
   end
end
save CenTrends_PR_SETH PR N_LAT N_LON lat lon yr_b yr_e N_yr

