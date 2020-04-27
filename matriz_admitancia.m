% matriz_admitancia realiza o c�lculo da matriz admit�ncia a partir da
% matriz imped�ncia das LTs e matriz suscpet�ncia das LTs.
%
%
%[matriz_Y] = matriz_admitancia(matriz_Z , matriz_B)
%
% @param matriz_Z: matriz com valores da imped�ncia da LTs de tamanho
%N x N, onde N corresponde ao n�mero de barras.
% @param matriz_B: matriz coluna com os valores das suscept�ncias das LTs. 
%
% @return matriz_Y: matriz quadrada (N x N) contendo os dados das
% admit�ncias das LTs conectando os barramentos (Y(n,m) = 0 significa que
% n�o h� LT entre os barramentos n e m).

function [matriz_Y] = matriz_admitancia(matriz_Z , matriz_B)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = size(matriz_Z , 1);
matriz_Y = zeros(n,n);

for i = 1:1:n
    for z = 1:1:n
        if(matriz_Z(i,z) ~= 0)
            matriz_Y(i,z) = -(1 / matriz_Z(i,z));
        end
        
        if(z == n)
            for(k = 1:1:n)
            if( k ~= i)
                matriz_Y(i,i) = (matriz_Y(i,i) + (-(matriz_Y(i,k))));
            else
                matriz_Y(i,i) = (matriz_Y(i,i) + matriz_B(1));
            end
                
            end
        end
        
    end
end
end

