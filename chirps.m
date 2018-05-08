% read chirps data
clear;clc;close all
FILE = '/Users/shu/data/CHIRPS/new/chirps-v2.0.monthly.nc';
lon = ncread(FILE,'longitude');
lat = ncread(FILE,'latitude');
TIME = ncread(FILE,'time');


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

N_LAT = LAT_E-LAT_B+1;
N_LON = LON_E-LON_B+1;

lat = lat(LAT_B:LAT_E);
lon = lon(LON_B:LON_E);
lat = double(lat);
lon = double(lon);

START = [LON_B LAT_B 1];
COUNT = [N_LON N_LAT length(TIME)];
STRIDE = [1 1 1];

PR = ncread(FILE,'precip',START,COUNT,STRIDE);
N_yr = floor(length(TIME)/12);

PR = PR(:,:,1:N_yr*12);

save PR_SETH_1981_2017 PR lat lon N_yr N_LON N_LAT
stop

bk_PR = PR;
mbk_PR = squeeze(mean(reshape(PR,N_LON,N_LAT,12,N_yr),4));
PR = reshape(PR,N_LON*N_LAT,12,N_yr);
PR = squeeze(mean(PR));
MON = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}
scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)*9/10])

bar(mean(PR,2))
set(gca,'xtick',1:12)
set(gca,'xticklabel',MON)
set(gca,'fontsize',40);
    set(gcf,'color','w')
    set(gcf,'paperpositionmode','auto')
    
scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)*9/10])

PR = sum(PR(6:9,:));
yr= 1981:1981+N_yr-1;
plot(yr,PR,'k','linewidth',3);
hold on
scatter(yr,PR,200,'filled')
set(gca,'xtick',1981:5:2017)
set(gca,'fontsize',30)
set(gcf,'color','w')
grid on

ll =  linspecer;
ca = 500;
inv = 50;
DL = 0:inv:ca;
INV = floor(size(ll,1)/length(DL));
lineStyles = (ll(1:INV:end,:));
lineStyles =  lineStyles(1:length(DL)-1,:);

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)*9/10])
for m = 1:12
    subplot(3,4,m)
    m_proj('miller','long',[lon(1) lon(end)],'lat',[lat(1) lat(end)]);
    hold on
    colormap(lineStyles)
    temp = squeeze(mbk_PR(:,:,m))';
    [cc,hh]=m_contourf(lon,lat,temp,DL);
    set(hh,'lineStyle','none');
    [cc,hh]=m_contour(lon,lat,temp,[0 0],'k','linewidth',3);
    m_coast('line','color',[0.1 0.1 0.1]);
    titlename=MON(m);
    title(titlename,'fontsize',20);
    hcb=colorbar;
    set(hcb,'YTick',[DL])
    set(gcf,'color','w')
    set(gcf,'paperpositionmode','auto')
    caxis([0 ca])
    set(gca,'fontsize',12)
    m_grid('linestyle','none','tickdir','out','linewidth',3);
end


