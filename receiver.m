function f = receiver(ref, signal)
    setting;
    tabbuttera = [];
    tabbutterb = [];
    [b,a] = butter(norder,(2/(3*Tb)), 'low','s');
    %[b,a] = butter(norder,150, 'low','s');
    b = [zeros(1,(length(b)-1)),b];
    tabbutterb = [tabbutterb; b];
    %disp(size(tabbutterb));
    a = [zeros(1,(length(a)-1)),a];
    tabbuttera = [tabbuttera; a];
    if N ~= 1
        for n = 1:N-1
            fn = (2*(n)/Tb);
            %disp(fn)
            g = 2/(3*Tb);
            %g = 150;
            fc = [fn-g,fn+g];
            %disp(fc)reslut
            [b,a] = butter(norder,fc, 's');
            %disp(size(b));
            tabbutterb = [tabbutterb; b];
            tabbuttera = [tabbuttera; a];
        end
    end
    tabmag = [];
    figure();
    for n = 1:N
        w = 1:1:10000;
        [h,w] = freqs(tabbutterb(n,:),tabbuttera(n,:),w);
        mag = 20*log10(abs(h));
        delay = diff(unwrap(angle(h)))./diff(w);
        subplot(2,2,1)
        plot(w,mag);
        grid on
        xlabel('Frequency (Hz)')
        ylabel('Magnitude')
        hold on
        ylim([-20, 1])
        xlim([0 N*200]);
        subplot(2,2,3)
        %disp(size(delay));
        %disp(size(w));
        plot(w(2:end),-delay)
        grid on
        xlabel('Frequency (Hz)')
        ylabel('Group delay (s)')
        hold on
        xlim([0 N*200]);
        subplot(2,2,2)
        %lk = 2^9;
        %h = cat(2,(flip(conj(real(h)))).',(real(h)).');
        %h1 = ifft(h);
        %h2 = [real(h),flip(conj(real(h)))];
        h2 = ifft(h, 'symmetric');
        %disp(size(h2))
        %disp(size(h2));
        %h2 = tf(tabbutterb(n,:),tabbuttera(n,:));
        %h2 = impulse(h2).';
        if length(real(h2)) > 500
            h2 = h2(1:500);
        end
        NFFT=1024;      
        X=fftshift(fft(h2,NFFT));         
        fVals=(1/Ta)*(-NFFT/2:NFFT/2-1)/NFFT;        
        %plot(fVals,abs(X));
        plot(1:length(real(h2)),real(h2))
        %disp(size(h2));
        %xlim([0 5000])
%         if n == N
%             siz = length(h1);
%         else
%             h1 = [h1,zeros(1,siz-length(h1))];
%         end
        tabmag = [tabmag;real(h2)];
        %disp(h);
        %plot(0:length(h)-1, h);
        %impulse(1:length(h),h);
        hold on
        subplot(2,2,4)
        plot(1:length(imag(h2)),imag(h2))
        hold off
    end
    hold off
    figure();
    t = tiledlayout(N/Lar+1,Lar);
    t.Padding = 'compact';
    t.TileSpacing = 'compact';
    one = nexttile([1 2]);
    title(one, 'Received signal')
    plot(1:length(signal), signal);
    tabech = [];
    for n = 1:N
        signall = signal(1:gamm:end);
        con = conv(signall,tabmag(n,:));
        con = con/4;
        tabech = [tabech;con];
        nexttile
        %figure();
        sig = con;
        NFFT=1024;      
        X=fftshift(fft(con,NFFT));         
        fVals=(1/Ta)*(-NFFT/2:NFFT/2-1)/NFFT;        
        %plot(fVals,abs(X),'b');
        plot(1:length(con),con);
        hold on
    end
    figure();
    NFFT=1024;      
    X=fftshift(fft(signal,NFFT));         
    fVals=(1/Ta)*(-NFFT/2:NFFT/2-1)/NFFT;        
    plot(fVals,abs(X));
    
    figure();
    t = tiledlayout(N/Lar,Lar);
    t.Padding = 'compact';
    t.TileSpacing = 'compact';
    lag = [];
    for n = 1:N
        sig = tabech(n,:);
        refe = ref(n,:);
        [c,lags] = xcorr(sig,refe);
        c = c/max(c);
        [~, i] = max(c);
        t = lags(i);
        nexttile
        plot(lags,c,[t t],[-1 1],'r:')
        text(t+100,0.5,['Lag: ' int2str(t)])
        lag = [lag;t];
    end
    figure();
    t = tiledlayout(N/Lar,Lar);
    t.Padding = 'compact';
    t.TileSpacing = 'compact';
    for n = 1:N
        sign = tabech(n,:);
        sign = sign(lag(n):end);
        nexttile
        plot(1:length(sign),sign);
        start = L*bet;
        if n > 0
            hold on 
            range = start:bet:(bet*(Mlen-1)+start);
            listt = [];
            for i = 1:length(range)
                listt(i) = sign(range(i));
            end
            partition = [-0.3,0.3];
            codebook = [-1,0,1];
            [index, quantized] = quantiz(sign, partition, codebook);
            plot(1:length(sign), quantized);
            hold on
            plot(range,listt,'*')
        end
    end
f = 2;
end

