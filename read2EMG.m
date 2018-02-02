%% 01.02.18 Reading EMG sensor data from Arduino UNO. Sensors connected to A0 and A1
close all
clear
clc

%% Connection
a = arduino('COM5', 'uno');
writeDigitalPin(a, 'D13', 1);
%%Parameters
T = 100;        % number of samples to view on plot
nCount = 1;
voltageS1 = zeros(T,1);
voltageS2 = zeros(T,1);
avrgVolt = zeros(T,1);
FEK = zeros(T,1);
%sample = [];

%% Getting data
disp('Plotting ...')
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
set(gcf,'WindowStyle','normal');
while double(get(gcf,'CurrentCharacter'))~=27
    clf;
    if nCount == T
        voltageS1 = voltageS1(2:end, :);
        voltageS2 = voltageS2(2:end, :);
        avrgVolt = avrgVolt(2:end, :);
        FEK = FEK(2:end, :);
    else
        nCount = nCount + 1;
    end
    voltageS1(nCount,:) = readVoltage(a, 'A0'); % Sensor 1 connected to input A0 biceps brachii.
    voltageS2(nCount,:) = readVoltage(a, 'A1'); % Sensor 2 connected to input A1 triceps brachii.
    %avrgVolt(nCount,:) = ((voltageS1(nCount,:)/5)-(voltageS2(nCount,:)/5));
    avrgVolt(nCount,:) = ((voltageS1(nCount,:))-(voltageS2(nCount,:)));
    FEK(nCount,:) = kalman_voltage(avrgVolt);
    
    data = [voltageS1(nCount,:), voltageS2(nCount,:)];
    decision = funcMyoDecision(data);
    
    dataPlot = [voltageS1, voltageS2, avrgVolt, FEK];
    plot(1:T,dataPlot)
    title(sprintf('A0 = %fV A1 = %fV Avg = %f FEK= %f', (voltageS1(nCount)), (voltageS2(nCount)) , avrgVolt(nCount,:), FEK(nCount,:)))
    grid on;
    axis([0 T -5 5])
    xlabel('Samples') % x-axis label
    ylabel('Voltage') % y-axis label
    drawnow
end

%% Disconnecting
writeDigitalPin(a, 'D13', 0);
clear a
disp('End')
