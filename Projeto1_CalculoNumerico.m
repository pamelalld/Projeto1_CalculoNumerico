function [Raiz, Iter, CondErro] = metodo_newton(f, df, x0, Toler, IterMax)
    x = x0;
    Fx = f(x);
    DFx = df(x);
    Iter = 0;

    fprintf('\nIterações: %d, x: %.6f, DFx: %.6f, Fx: %.6f\n', Iter, x, DFx, Fx);

    while true
        DeltaX = -Fx / DFx;
        x = x + DeltaX;
        
        Fx = f(x);
        DFx = df(x);
        Iter = Iter + 1;
        
        fprintf('Iterações: %d, x: %.6f, DFx: %.6f, Fx: %.6f, DeltaX: %.6f\n', ...
                Iter, x, DFx, Fx, DeltaX);
        
        if (abs(DeltaX) <= Toler && abs(Fx) <= Toler) || DFx == 0 || Iter >= IterMax
            break;
        end
    end

    Raiz = x;

    if abs(DeltaX) <= Toler && abs(Fx) <= Toler
        CondErro = 0;
    else
        CondErro = 1;
    end
end


fprintf("Qual problema gostaria de resolver?\n 1. Juros de financiamento\n 2. Cabo suspenso\n")
problema = input('Informe 1 ou 2: ');

if problema == 1

    fprintf('\nInforme os dados do financiamento\n');

    v = input('Preço à vista (v): ');
    e = input('Valor da entrada (e): ');
    p = input('Número de prestações (p): ');
    m = input('Valor da mensalidade (m): ');

    f = @(j) ((1 - (1 + j)^-p) / j) - ((v - e) / m);
    df = @(j) (j * p * (1 + j)^-(p+1) - (1 - (1 + j)^-p)) / j^2;

elseif problema == 2

    fprintf('\nInforme os dados: \n');

    flecha = input('Flecha: ');
    d = input('Distância entre dois pontos: ');
    
    
    f = @(x) x * (cosh(d / (2*x)) - 1) - flecha;
    df = @(x) cosh(d / (2*x)) - 1 - (d / (2*x)) * sinh(d / (2*x));
else
    fprintf("Valor inválido")
    exit
end


%parâmeteos de entrada: valor inicial, erro tolerado, máximo de iterações
x0 = input('\nInforme o valor inicial (x0): ');
Toler = 1e-7;
IterMax = 100;

%parâmetros de saída: raíz, quantidade de iterações e flag de erro
[raiz, iteracoes, erro] = metodo_newton(f, df, x0, Toler, IterMax);

if erro == 0 %raíz encontrada
    fprintf('\nRaiz: %.6f\n', raiz);
    fprintf('Número de iterações: %d\n', iteracoes);

    if problema == 1
        fprintf('Juros: %.2f%%\n', raiz*100);
    elseif problema == 2
        L= 2*raiz*sinh(d/(2*raiz));
        fprintf('Comprimento do cabo: %.2f\n',L);
    end
else %raíz não encontrada
    fprintf('O método não convergiu em %d iterações.\n', IterMax);
end
