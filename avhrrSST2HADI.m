%readin ORA grid
clear;clc
tic;

% read in avhrr lat lon
ncid = netcdf.open('2017/avhrr-only-v2.20170820.nc','nowrite');
varid = netcdf.inqVarID(ncid,'lon');
oi_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lat');
oi_lat = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'sst');
sst = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
oi_lon_N = length(oi_lon);
oi_lat_N = length(oi_lat);
data = zeros(oi_lon_N,oi_lat_N,3);

for year = 2017:2017
    year
    kk=1;
    for m = [8 11 12]
%        m
        k=0;
        for dy=1:31
%        dy
            date = [num2str(year) num2str(m,'%2.2i') num2str(dy,'%2.2i')];
            if exist([num2str(year) '/avhrr-only-v2.' num2str(year) num2str(m,'%2.2i') num2str(dy,'%2.2i') '.nc'])
            ncid = netcdf.open([num2str(year) '/avhrr-only-v2.' num2str(year) num2str(m,'%2.2i') num2str(dy,'%2.2i') '.nc'],'nowrite');
            elseif exist([num2str(year) '/avhrr-only-v2.' num2str(year) num2str(m,'%2.2i') num2str(dy,'%2.2i') '_preliminary.nc'])
            ncid = netcdf.open([num2str(year) '/avhrr-only-v2.' num2str(year) num2str(m,'%2.2i') num2str(dy,'%2.2i') '_preliminary.nc'],'nowrite');
            else 
                continue
            end
            varid = netcdf.inqVarID(ncid,'sst');
            temp = netcdf.getVar(ncid,varid);
            temp = double(temp);
            netcdf.close(ncid);
            data(:,:,kk) = data(:,:,kk) + temp;
            k=k+1;
        end
        
        data(:,:,kk) = data(:,:,kk)/k;
        kk = kk + 1;
    end
end

if 1 % HADISST
ncid = netcdf.open('../HADISST/HadISST_sst.nc','nowrite');
varid = netcdf.inqVarID(ncid,'longitude');
lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'latitude');
lat = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
end
lon(lon<0) = lon(lon<0) + 360;
data(abs(data)<1e-6) = NaN;
data(data<0) = NaN;
[X0 Y0] = meshgrid(oi_lat,oi_lon);
[X1 Y1] = meshgrid(lat,lon);
data_new = zeros(360,180,2);
for k = 1:3
data_new(:,:,k) = interp2(X0,Y0,squeeze(data(:,:,k)),X1,Y1);
end
sst = double(data_new)/100;
save sst_2017_08_11_12 sst

toc;
