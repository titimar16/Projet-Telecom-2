function f = emitter()
    setting;
    tablM = [];
    for n = 1:N % générer N messages et ajouter dans un tableau
        Md = round(rand(1,Mdlen)); % génération aléatoire
        M = cat(2,Ms,Md);
        tablM = [tablM;M];
    end
    tablM(tablM == 0) = -1; % codage des 0 en -1
    tablM(tablM == 1) = +1; % codage des 1 en +1
    
    %b = rcosdesign(alph, L, bet); % add-on Communication
    %b = rcosfir(0, L, bet, 1); % alpha = vitesse atténuation, centré en L*bet
    [row,col] = size(tablM);
    disp(col)
    for n = 1:col
        disp(n)
        L = 10 + 1 * (n-1);
        k = tablM(1,n);
        b = k*rcosfir(0, L, bet);
        plot((-bet*10):(length(b)-1-bet*10),b)
        hold on
    end
    f = b;
end