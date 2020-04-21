clear 
clc
n = 3;

SLACK = 1;
PV = 2;
PQ = 3;
%%
Z_base = 1190.25;           % Unidade em OhmsPode ser extendido para formula
Z_12_base = (5.55 + 56.4j); % Unidade em Ohms
Z_13_base = (7.40 + 75.2j);
Z_23_base = (5.55 + 56.4j);

Z_12 = 0.0047 + j*0.0474;
Z_13 = 0.0062 + j*0.0632;
Z_23 = 0.0047 + j*0.0474;

matriz_B = [ (j*675e-6/2) ; ((j*900e-6)/2) ; ((j*675e-6)/2) ];
matriz_B = [0 ; 0 ; 0];

matriz_Z = zeros(n,n);
matriz_Z = [0 Z_12 Z_13 ; Z_12 0 Z_23 ; Z_13 Z_12 0]; % Impedancia das linhas de transmissao. Zero igual a nao existir linha.


matriz_Y = zeros(n,n);

matriz_Y = matriz_admitancia(matriz_Z, matriz_B);


%%


Tipo_barra(1) = SLACK;
Tipo_barra(2) = PV;
Tipo_barra(3) = PQ;



matriz_P = sym("P" , [n , 1]);
% matriz_P(1) = -0.15;
matriz_P(2) = 2;
matriz_P(3) = -5;

matriz_Q = sym("Q" , [n , 1]);
assume(matriz_Q, 'real');
% matriz_Q(1) = ;
% matriz_Q(2) = 2.67;
matriz_Q(3) = -1;

P_esp = vpa(matriz_P + matriz_Q * i);



matriz_V = sym("V" , [1 , n]);
vars = matriz_V;
simb_V = matriz_V;
matriz_V(1) = 1;simb_V(1) = 0;
matriz_V(2) = 1.05; simb_V(2) = 0;
% matriz_V(3) = 1; simb_V(3) = 0;


matriz_theta = sym("theta" , [1 , n]);
vars = [matriz_theta vars];
simb_theta = matriz_theta;
matriz_theta(1) = 0; simb_theta(1) = 0;
% matriz_theta(2) = 0; simb_theta(2) = 0;
% matriz_theta(1) =; simb_theta(3) = 0;


%%
non_zero_theta = simb_theta(simb_theta ~= 0);
non_zero_V     = simb_V(simb_V ~= 0);

variaveis_NR = [non_zero_theta , non_zero_V];

X0   = [zeros(1, size(non_zero_theta , 2))  ones(1, size(non_zero_V, 2))]';

%%

variaveis = vars;
[m_funcao_potencia , P_potencia,  Q_potencia] = m_funcao_potencia(P_esp, Tipo_barra ,matriz_V , matriz_theta, matriz_Y);
valor_variaveis = [matriz_theta matriz_V];
f_P = symfun(m_funcao_potencia , variaveis_NR);
mm_P = matlabFunction(f_P);
m_JAC = jacobian(m_funcao_potencia , variaveis_NR);
f_JAC = symfun(m_JAC , variaveis_NR);
mm_JAC = matlabFunction(f_JAC);


P_func = symfun(P_potencia , variaveis_NR);
Q_func = symfun(Q_potencia , variaveis_NR);

P_numeric = matlabFunction(P_func);
Q_numeric = matlabFunction(Q_func);

[X1 , final_JAC] = NewtonRaphson(m_funcao_potencia , variaveis_NR ,  X0)
P_missing = symvar(P_esp)
cell_X1 = num2cell(X1);
P_final = P_numeric(cell_X1{:}) + Q_numeric(cell_X1{:}) * i



