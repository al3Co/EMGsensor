% 020218 Function to know the behavior of the motor who will move the elbow
% Sensor 1 connected to input A0 biceps brachii.
% Sensor 2 connected to input A1 triceps brachii.
% data = [voltageA0, voltageA1]
function [decision, strength]  = funcMyoDecision(data)
%decision = 'None';
% convert data from 0 to 1 values
data(1) = data(1) /5;
data(2) = data(2) /5;

if data(1) >= data(2)
    decision = 'Biceps';
    disp('Biceps')
else
    decision = 'Triceps';
    disp('Triceps')
end
strength = 0; % Fuerza = masa * aceleración lineal

end
