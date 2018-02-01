close all
clear
clc
%% Connection
a = arduino('COM3', 'uno');

%%Parameters
T = 10;        % number of samples to view on plot
nCount = 1;
voltage = zeros(T,1);
FEK = zeros(T,1);
sample = [];

writeDigitalPin(a, 'D13', 1);

%% Getting data
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
while double(get(gcf,'CurrentCharacter'))~=27
    if nCount == T
        voltage = voltage(2:end, :);
        FEK = FEK(2:end, :);
    else
        nCount = nCount + 1;
        
    end
    voltage(nCount,:) = readVoltage(a, 'A0'); %Already converted to 0-5V
    FEK(nCount,:) = kalman_voltage(voltage);
    
    dataPlot = [voltage, FEK];
    plot(1:T,dataPlot)
    title(sprintf('Voltage = %fV', (voltage(nCount))))
    grid on;
    axis([0 T 0 5])
    xlabel('Samples') % x-axis label
    ylabel('Voltage') % y-axis label
    %legend('Voltage','FKE')
    drawnow
end

writeDigitalPin(a, 'D13', 0);
%% Saving on file
% fileID = fopen('muscle_firstTest.txt','w');
% fprintf(fileID,'%10s %10s\r\n','Stamp','Data');
% fprintf(fileID,'%10.2f %10.4f\r\n',nCount, voltage(nCount));
% fclose(fileID);

%% Plotting all data
% TODO

disp('End')
