clear 
clc

Z_base = 1190.25;           % Unidade em OhmsPode ser extendido para formula
Z_12_base = (5.55 + 56.4j); % Unidade em Ohms
Z_13_base = (7.40 + 75.2j);
Z_23_base = (5.55 + 56.4j);

Z_12  = Z_12_base / Z_base  % Por unidade (pu)
Z_13 = Z_13_base / Z_base
Z_23 = Z_23_base / Z_base

matriz_Z = zeros(3,3);
matriz_Z = []

B_12_total_base = 675e-6; % Unidade em Siemens
B_13_total_base = 900e-6;
B_23_total_base = 675e-6;

B_12_total = 0.8034;
B_13_total = 1.0712;
B_23_total = 0.8034;


Y_12 = - (1/Z_12)
Y_21 = Y_12;


Y_13 = -(1/Z_13)
Y_31 = Y_13;



Y_11 = 0;

Y_22 = 0;
Y_23 = -(1/Z_23);
Y_32 = Y_23;

Y_33 = 0;
Y_23 = Y_32;



Y_1G = -(Y_12 + Y_13)
Y_11 = Y_1G;

Y_2G = -(Y_21 + Y_23)
Y_22 = Y_2G

Y_3G = -(Y_32 + Y_31)
Y_33 = Y_3G

Y_bus = [Y_11 Y_12 Y_13; Y_21 Y_22 Y_23; Y_31 Y_32 Y_33]
