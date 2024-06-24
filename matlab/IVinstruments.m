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