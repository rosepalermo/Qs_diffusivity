% This code takes in a shoreline wave buoy data and outputs wave climate info, Qs, and diffusivity
% input is long and lat of shoreline, WaveWatch3, and WIS data
% only difference for using UTM is that "stretching" step is not needed.

% Last updated Sept. 30, 2021
% Rose Palermo

%% Part 1: WAVES

%%%%% WIS and WW3 -- This only needs to be done once for each shoreline. Then saved data can be reused.
% here, we take WIS data and wave watch 3 data and save them as wave roses
% input is WIS and WW3 data as a table format saved in its own folder
% output is matlab files of computed wave climate info using CERC formula

% WIS and WW3 data should be input in separate folders. Saved into same
% folder.

% WaveWatch3
% LINK for WW3:https://jhnienhuis.users.earthengine.app/view/changing-shores
inputFolder_WW3 = []; % where is your WW3 data?
outputFolder_Waves = []; % where do you want the wave roses to go?
ShorelineAngle_init = []; % where the shoreline angle loop starts
saveWW3data(inputFolder_WW3,outputFolder_Waves,ShorelineAngle_init)

% WIS
% LINK for WIS: https://chlthredds.erdc.dren.mil/thredds/catalog/wis/catalog.html
inputFolder_WIS = []; % where is your WW3 data?
outputFolder_Waves = []; % where do you want the wave roses to go?
saveWISdata(inputFolder_WIS,outputFolder_Waves,ShorelineAngle_init)

%%%%% compute wave climate -- this only needs to be done one time for a set of WIS & WW3 stations
outputFolder_Waves = [];
outputFolder_waveclimate = [];
plot_on = 1; % 1 to make plots, 0 to not
computewaveclimate_CERC(outputFolder_Waves,outputFolder_waveclimate,plot_on)


%% Part 2 shoreline
%%%%% load shoreline data
% need long and lat points of the open ocean coast
% load data as data_raw, an nx2 matrix of long and lat data
data_raw = [];

%%%%% shorefixer
% this function makes continuous coastline from fragmented segments by
% joining expoints of segments less than TOL distance apart.
tol = 0.01; % in degrees, change to m if UTM
SLdata = join_cst(data_raw,tol);


%%%%% open ocean only
% here, create a variable of the indices of open ocean shoreline points (not in an estuary
% or on the backbarrier). I haven't figured out a way to do this that isn't
% by hand yet.
ind_all = 1:length(SLdata);
ind_open = []; % if all points are open coastline, ind_open = ind_all;

%%%%% stretch
% convert long and lat to x and y
%the below conversion factors are calculated for 41.8 degrees latitude, a
%central point along the cape, by a National Geospatial-Intelligence Agency
%calculator:
%http://msi.nga.mil/MSISiteContent/StaticFiles/Calculators/degree.html
lat = 111.069; % cape cod example
lon = 83.110; % cape cod example

SLdata(:,1) = (SLdata(:,1)-min(SLdata(:,1))) * lon;%changed from lon/lat*lon to just lon
SLdata(:,2) = (SLdata(:,2)-min(SLdata(:,2))) * lat;

%%%%% detrend
% rotate shoreline so that it is flat, land is down and ocean is up

% Confirm that the shoreline is mostly oriented up. If not, first rotate by 180
% degrees using the rotate180 function.

% [SLdata_180rot] = rotate180(SLdata); % uncomment if needed

% if do 180, add 180 to RotationAngle (Maybe? we'll check together)
[SLdata_detrend, RotationAngle] = detrendshoreline(SLdata);




%% Part 3: calculate sediment flux and diffusivity given shoreline and wave climate

plot_on = 1;
outputFolder_waveclimate = '/Users/rosepalermo/Documents/Research/Luis Stuff/Files Rose Changed/_qsdif';
outputFolder_Dif = '/Users/rosepalermo/Documents/Research/Luis Stuff/Files Rose Changed/test';

calculateQs_Dif(outputFolder_waveclimate,outputFolder_Dif,SLdata_detrend,ind_open,RotationAngle,plot_on)

