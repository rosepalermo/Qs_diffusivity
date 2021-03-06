% format lat and long for GoM barriers, calculate shoreline azimuth
%%%% THESE END POINTS HAVE A PROJECTION ISSUE. DO NOT USE THIS ONE.
load('rawcoords.mat')

startlat = zeros(length(startlat_raw),1);
startlong = zeros(length(startlong_raw),1);
endlat = zeros(length(endlat_raw),1);
endlong = zeros(length(endlong_raw),1);

for i = 1:length(startlat)
    temp1 = strjoin(startlat_raw(i,1:2),'.');
    temp2 = strjoin(startlong_raw(i,1:2),'.');
    temp3 = strjoin(endlat_raw(i,1:2),'.');
    temp4 = strjoin(endlong_raw(i,1:2),'.');
    
    startlat(i) = (str2double(strjoin([temp1,startlat_raw(i,3:end)],'')));
    startlong(i) = -(str2double(strjoin([temp2,startlong_raw(i,3:end)],'')));
    endlat(i) = (str2double(strjoin([temp3,endlat_raw(i,3:end)],'')));
    endlong(i) = -(str2double(strjoin([temp4,endlong_raw(i,3:end)],'')));
end
% rad2deg(mod(atan2(sin(deg2rad(endlong-startlong)).*cos(deg2rad(endlat)),cos(deg2rad(startlat).*sin(deg2rad(endlat))-sin(deg2rad(startlat)).*cos(deg2rad(endlong-startlong)))),2*pi))
sl_az_startend = azimuth(startlat,startlong,endlat,endlong);