
%
% Exemplo 8.5, p�gina 283, "Computer Methods in Power System Analysis" W.Stagg , H. El-Abiad.
%

clear 
clc
% Input do usu�rio:
% N�mero de barramentos
numBarra = 5;

%%
% Constantes para facilitar a leitura:
SLACK = 1;
PV = 2;
PQ = 3;

% Definindo matrizes das vari�veis que ser�o utilizadas e especificadas:
matriz_P = sym("P" , [numBarra , 1]);
matriz_Q = sym("Q" , [numBarra , 1]);
assume(matriz_Q, 'real');
matriz_theta = sym("theta" , [1 , numBarra]);
matriz_V = sym("V" , [1 , numBarra]);
matriz_YG = zeros(numBarra , 1);
%%
% Input do usu�rio: especifica��es das Linhas de Transmiss�o (LTs):
matriz_Z = zeros(numBarra,numBarra);

% Imped�ncia da LT entre os barramentos 1-2 ou 2-1 (em p.u.):
matriz_Z(1,2) = 0.0200 + j*0.0600;
matriz_Z(2,1) = 0.0200 + j*0.0600;

% Imped�ncia da LT entre os barramentos 1-3 ou 3-1(em p.u.):
matriz_Z(1,3) = 0.0800 + j*0.2400;
matriz_Z(3,1) = 0.0800 + j*0.2400;

% Imped�ncia da LT entre os barramentos 2-3 ou 3-2(em p.u.):
matriz_Z(2,3) = 0.0600 + j*0.1800;
matriz_Z(3,2) = 0.0600 + j*0.1800;

% Imped�ncia da LT entre os barramentos 2-4 ou 4-2(em p.u.):
matriz_Z(2,4) = 0.0600 + j*0.1800;
matriz_Z(4,2) = 0.0600 + j*0.1800;

% Imped�ncia da LT entre os barramentos 2-5 ou 5-2(em p.u.):
matriz_Z(2,5) = 0.0400 + j*0.1200;
matriz_Z(5,2) = 0.0400 + j*0.1200;

% Imped�ncia da LT entre os barramentos 3-4 ou 4-3(em p.u.):
matriz_Z(3,4) = 0.0100 + j*0.0300;
matriz_Z(4,3) = 0.0100 + j*0.0300;

% Imped�ncia da LT entre os barramentos 4-5 ou 5-4(em p.u.):
matriz_Z(4,5) = 0.0800 + j*0.2400;
matriz_Z(5,4) = 0.0800 + j*0.2400;




% Admit�ncia barramento-terra na barra 1, em p.u.:
matriz_YG(1) = 0 + j*0.05500;

% Admit�ncia barramento-terra na barra 2, em p.u.:
matriz_YG(2) = 0 + j*0.08500;

% Admit�ncia barramento-terra na barra 3, em p.u.:
matriz_YG(3) = 0 + j*0.05500;

% Admit�ncia barramento-terra na barra 4, em p.u.:
matriz_YG(4) = 0 + j*0.05500;

% Admit�ncia barramento-terra na barra 5, em p.u.:
matriz_YG(5) = 0 + j*0.04000;




% Formando a matriz admit�ncia:
matriz_Y = matriz_admitancia(matriz_Z, matriz_YG);


%%
% Input do usu�rio: especifica��es dos barramentos:
% Se for barra tipo SLACK, deve-se definir o valor da tens�o (1 p.u.) e �ngulo (0 rad)
% Se for barra tipo PV, deve-se definir Pot�ncia ativa em p.u. e magnitude da tens�o em p.u..
% Se for barra tipo PQ, deve-se definir Pot�ncia ativa em p.u. e Pot�ncia reativa em p.u..

% Base de pot�ncia para o c�lculo em p.u.
P_base = 100000e3;

% Barramento 1: SLACK
Tipo_barra(1) = SLACK;
matriz_V(1) = 1.06;
matriz_theta(1) = 0;



% Barramento 2: PQ
Tipo_barra(2) = PQ;
matriz_P(2) = (40e6  - 20e6)/ P_base;
matriz_Q(2) = (30e6 - 10e6)/P_base;

% Barramento 3: PQ
Tipo_barra(3) = PQ;
matriz_P(3) = (0e6 - 45e6)/P_base;
matriz_Q(3) = (0e6 - 15e6)/P_base;

% Barramento 4: PQ
Tipo_barra(4) = PQ;
matriz_P(4) = (0e6 - 40e6)/P_base;
matriz_Q(4) = (0e6 - 5e6)/P_base;


% Barramento 5: PQ
Tipo_barra(5) = PQ;
matriz_P(5) = (0e6 - 60e6)/P_base;
matriz_Q(5) = (0e6 - 10e6)/P_base;



P_esp = vpa(matriz_P + matriz_Q * 1i);


%%

% Construindo o vetor chute X0 e as vari�veis para o m�todo NR:
[X0 , variaveis_NR] = obter_dadosNR(Tipo_barra);


% Contando n�mero de barramentos PV e PQ:
[nPV , nPQ] = contBarramentos(Tipo_barra);

% Obtendo as equa��es de pot�ncia:
[equacao_potencia_NR , f_potencia_geral] = func_potencia(nPV , nPQ , P_esp, Tipo_barra ,matriz_V , matriz_theta, matriz_Y);



sym_P_geral = symfun(f_potencia_geral , variaveis_NR);
P_numeric_geral = matlabFunction(sym_P_geral);

%%
[final_X , final_JAC , iteracoes] = NewtonRaphson(equacao_potencia_NR , variaveis_NR ,  X0, 10000, 1.0e-20);

fprintf("N�mero de itera��es = %d ", iteracoes);

cell_X = num2cell(final_X);
P_das_barras = P_numeric_geral(cell_X{:});
printP_barras(P_das_barras);

printX(variaveis_NR , final_X, matriz_V, matriz_theta);

[P_nas_LTs] = flxuo_potencia_LT(variaveis_NR , final_X , matriz_V, matriz_theta, matriz_Y);
printP_LTs(P_nas_LTs);


