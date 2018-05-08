%readin ORA grid
clear;clc
tic;

ncid = netcdf.open('2016/avhrr-only-v2.20160520.nc','nowrite');
varid = netcdf.inqVarID(ncid,'lon');
ora_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lat');
ora_lat = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'sst');
sst = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
ora_lon_N = length(ora_lon);
ora_lat_N = length(ora_lat);
data = zeros(ora_lon_N,ora_lat_N,2);

for year = 2016:2016
    year
    kk=1;
    for m = 11:12
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

%readin OISST monthly grid
ncid = netcdf.open('sst.mnmean.nc','nowrite');
varid = netcdf.inqVarID(ncid,'lon');
pop_lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'lat');
pop_lat = netcdf.getVar(ncid,varid);
netcdf.close(ncid);

if 0 % later for HADISST
ncid = netcdf.open('../data/HadISST_sst.nc.gz','nowrite');
varid = netcdf.inqVarID(ncid,'longitude');
lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'latitude');
lat = netcdf.getVar(ncid,varid);
netcdf.close(ncid);
end
data(abs(data)<1e-6) = NaN;
data(data<0) = NaN;
[X0 Y0] = meshgrid(ora_lat,ora_lon);
[X1 Y1] = meshgrid(pop_lat,pop_lon);
data_new = zeros(360,180,2);
for k = 1:2
data_new(:,:,k) = interp2(X0,Y0,squeeze(data(:,:,k)),X1,Y1);
end
sst2 = data_new;
save sst_2016_11_12 sst2

toc;
