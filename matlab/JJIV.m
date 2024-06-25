%
% A yokogawa drives a voltage divider which divides by 100 and then the
% device under test.  One volt meter reads out the voltage on the device,
% called VV and the other reads out the voltage on a 10 k bias resistor,
% and that's called IV.  I is then calculated from IV and Rbias.  
%

clear all
clc

%%
yoko_GS200 = 2;
    obj_yoko = instrfind('Type', 'gpib', 'BoardIndex', 7, 'PrimaryAddress', yoko_GS200, 'Tag', '');
    if isempty(obj_yoko)
         obj_yoko = gpib('KEYSIGHT', 7, yoko_GS200);
    else
        fclose(obj_yoko);
        obj_yoko = obj_yoko(1);
    end
    fopen(obj_yoko);
%    clear yoko_GS200

%% load voltmeter
% 
address_VV = 24;
    obj_VV = instrfind('Type', 'gpib', 'BoardIndex', 7, 'PrimaryAddress', address_VV, 'Tag', '');
    if isempty(obj_VV)
         obj_VV = gpib('KEYSIGHT', 7, address_V);
    else
        fclose(obj_VV);
        obj_VV = obj_VV(1);
    end
    fopen(obj_VV);
 %   clear address_V
 
 %%
%% load voltmeter
% 
address_IV = 26;
    obj_IV = instrfind('Type', 'gpib', 'BoardIndex', 7, 'PrimaryAddress', address_IV, 'Tag', '');
    if isempty(obj_IV)
         obj_IV = gpib('KEYSIGHT', 7, address_I);
    else
        fclose(obj_IV);
        obj_IV = obj_IV(1);
    end
    fopen(obj_IV);
%%
%% JJIV

JJIV = struct;          % declare a structure
JJIV.D = [];            % drive array will be in volts 
JJIV.VV = [];           % voltage across device
JJIV.IV = [];           % voltage across Rbias
JJIV.I = [];            % current through device and bias resistor
JJIV.Rbias = 1e4;       % Bias resistor in ohms
JJIV.npoints = 100;     % Number of points
JJIV.Dmin = -1.0;       % Start drive voltage
JJIV.Dmax = 1.0;        % Stop drive voltage
JJIV.Rn = NaN;          % Measured Normal state resistance in ohms
JJIV.Ic = NaN;          % Measured critical current in amperes
JJIV.temperature = NaN; % Temperature
JJIV.username = "lafe"  % put a unique username for whoever created the data set

JJIV.Dmin = -1;         % Drive start voltage
JJIV.Dmax =  1;         % Drive stop voltage

JJIV.D = JJIV.Dmin:((JJIV.Dmax-JJIV.Dmin)/JJIV.npoints):JJIV.Dmax;% D stands for "drive", this is voltage on the Yokogawa in volts

%% settings
VDwellTime = 0;
Yokorange = 10;
VVrange = 1e-4;
IVrange = 1e-4;

%compliance_voltage = 10;
nplc = 1;
%path = 'C:\Users\mac3\Documents\DATA\IMS\dunktest\2018_06_18\';
%Initialize Current source
fprintf(obj_yoko,':SOUR:FUNC VOLT');
fprintf(obj_yoko,[':SOUR:RANG ',num2str(Yokorange)]);  % sets yoko voltage range
% fprintf(obj_yoko,[':SOUR:PROT:VOLT ',num2str(compliance_voltage)])  % sets complaince voltage
%reset current to 0:
fprintf(obj_yoko, [':SOUR:LEV:FIX ',num2str(0)]);
fprintf(obj_yoko,'OUTP ON');
% turn off signal
%set8195_runenable(obj8195,false)
%pause(1)
% Initialize Voltmeter
fprintf(obj_VV,'*RST');
fprintf(obj_VV,'status:preset');
fprintf(obj_VV,'*cls');
fprintf(obj_VV,['conf:volt:dc ',num2str(VVrange)]);
fprintf(obj_VV,'*sre 32') %not sure what this does either
%The following line sets the rate at which the voltmeter averages the data over (ie sampling rate)
%0.02, 0.2, 1, 2, 10, 20, 100, 200 where 0.02 is the fastest sampling rate and lowest averaging
fprintf(obj_VV,['SENS:VOLT:DC:NPLC ',num2str(nplc)]) %number of power line cycles to average over
fprintf(obj_VV,'trigger:source bus')
fprintf(obj_VV,'trigger:delay 0')
fprintf(obj_VV,'initiate')
fprintf(obj_VV,'*TRG')
%VV  = str2num(query(obj_VV,'fetch?'));
%turn on signal
%set8195_runenable(obj8195,true)
%pause(1)

fprintf(obj_IV,'*RST');
fprintf(obj_IV,'status:preset');
fprintf(obj_IV,'*cls');
fprintf(obj_IV,['conf:volt:dc ',num2str(IVrange)]);
fprintf(obj_IV,'*sre 32') %not sure what this does either
%The following line sets the rate at which the voltmeter averages the data over (ie sampling rate)
%0.02, 0.2, 1, 2, 10, 20, 100, 200 where 0.02 is the fastest sampling rate and lowest averaging
fprintf(obj_IV,['SENS:VOLT:DC:NPLC ',num2str(nplc)]) %number of power line cycles to average over
fprintf(obj_IV,'trigger:source bus')
fprintf(obj_IV,'trigger:delay 0')
fprintf(obj_IV,'initiate')
fprintf(obj_IV,'*TRG')

%IV = str2num(query(obj_curr,'fetch?'));
%turn on signal
%set8195_runenable(obj8195,true)
%pause(1)

%%
JJIV.timestamp = num2str(round(posixtime(datetime('now'))));

for n = 1:length(JJIV.D)
    
 %   sprintf('Starting sweep up')
    fprintf(obj_yoko, [':SOUR:LEV:FIX ',num2str(JJIV.D(n))])
    fprintf(obj_VV,'initiate')
    fprintf(obj_VV,'*TRG')
    fprintf(obj_IV,'initiate')
    fprintf(obj_IV,'*TRG')
    if n==1
        pause(0.2);
    end          
    JJIV.VV(n) = str2num(query(obj_VV,'fetch?'));
    JJIV.IV(n) = str2num(query(obj_IV,'fetch?'));
    JJIV.I(n) = JJIV.IV(n)/JJIV.Rbias;
end
fprintf(obj_yoko, [':SOUR:LEV:FIX ',num2str(0e-3)])


JJIV.filename = "JJIV_" + JJIV.username + "_" + JJIV.timestamp + ".txt";
 
jsontext = jsonencode(JJIV,PrettyPrint=true);



%%
%figure(1);
% uiopen('E:\DATA\QuantumComputing\XLD Runs\January_20_2021_cooldown\IVcurves\210126_4500jj_array_ref.fig',1)
% hold on
figure(1); 
clf
% hold on
plot(JJIV.I,JJIV.V,'+-')

grid on
%xlabel('mV')
%ylabel('mA')

%%


save('pqfile.txt','jsontext',['-' ...
    '-json'])
type('pqfile.txt')

%%

%%
jsontext = jsonencode(JJIV,PrettyPrint=true);
JJIV.filename = "JJIV_" + JJIV.username + "_" + JJIV.timestamp + ".txt";
fileID = fopen(JJIV.filename,'w');
fprintf(fileID,jsontext);
fclose(fileID);

