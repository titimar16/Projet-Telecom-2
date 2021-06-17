function f = emitter()
    setting;
    tablM = [];
    for n = 1:N % générer N messages et ajouter dans un tableau
        %Md = round(rand(1,Mdlen)); % génération aléatoire
        Md = [0 0 0 1 1 0 0 1];
        M = cat(2,Ms,Md);
        tablM = [tablM;M];
    end
    tablM(tablM == 0) = -1; % codage des 0 en -1
    tablM(tablM == 1) = +1; % codage des 1 en +1
    tablN = [];
    disp(tablM(1,:));
    
    for n = 1:N
        value = tablM(n,:);
        tablN = [tablN;reshape([value;zeros(bet-1,numel(value))],1,[])]; % message Tb -> Tn
    end
    %disp(tablN);
    
    prefilter = rcosfir(alph,L,bet);
    %disp(size(prefilter))
    filter_time = -(L*Tb):Tn:(L*Tb);
    %disp(size(filter_time))
    
    tabfilter = [];
    for n = 0:N-1 % création d'un tableau avec les filtres
        filter = prefilter .* cos(2*pi*2*n*filter_time/Tb);
        if n == 0
            plot(filter_time,filter);
            hold off;
        else
            plot(filter_time,filter)
        end
        tabfilter = [tabfilter;filter];
        %hold on
    end
    %disp(tabfilter);
    %disp(size(tabfilter));
    hold off
    %legend('canal 0','canal 1')
    %xlabel("numéro d'échantillon") 
    %ylabel('FIR normalisé')
    tabsig = [];
    tabbj = [];
    for n = 0:N-1
        bj = conv(tablN(n+1,:),tabfilter(n+1,:));
        w = interpft(bj,gamm*(length(tablN(n+1,:))+2*L*bet));
        tabbj = [tabbj;bj];
        tabsig = [tabsig;w];
    end
%     plot(1:length(tabbj),tabbj(1,:));
%     hold on
%     plot(1:length(tabbj),ones(length(tabbj)));
%     hold on
%     plot(1:length(tabbj),-ones(length(tabbj)));
%     figure();
    %disp(size(interpft(tabbj(3,:), gamm*(Mlen+2*L*bet))));
    %o = plot(1:(length(tablN(1,:))+2*L*bet),tabbj(1,:), 'o');
%     hold off
%     plot(1:(1/gamm):((length(tablN(2,:))+2*L*bet+1)-(1/gamm)), tabsig(2,:));
%     hold on
%     plot(1:(1/gamm):((length(tablN(2,:))+2*L*bet+1)-(1/gamm)), tabsig(2,:), '.');
%     hold off
    %disp(size(tabsig));
    %signal = sum(tabsig);
    %disp(size(signal));
    %plot (1:length(signal), signal);
    %hold on
    for n = 1:N
        RMS = rms(tabsig(n,:));
        U = sqrt(Pt*Zc);
        A = U/RMS; 
        tabsig(n,:) = A*tabsig(n,:);
        %plot(1:length(tabsig(n,:)),tabsig(n,:));
        %hold on
    end
    figure();
    %disp(A);
    %plot (1:length(tabsig(1,:)), tabsig(1,:));
    %hold off
    %disp(tabsig);
    f = tabsig;
end