function [] = printX(variaveis_NR , valores , matriz_V , matriz_theta, iteracoes)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tamanho = size(matriz_V , 2);

valores_total = [matriz_V ; matriz_theta];
output = vpa(subs(valores_total , variaveis_NR , valores' ));
V = output(1,:)';
theta = output(2,:)';

fprintf("Tens�o e �ngulo nos barramentos depois de %d itera��es. \n", iteracoes);
fprintf(" n |     V  [p.u.]|  %c [degree]\n", 952);
fprintf("------------------------------\n");
for i = 1:1:tamanho
    degree = theta(i)*(180/pi);
    fprintf("%2.0d | %10.5f   | %10.5f \n", i , V(i) , degree);
end
end

