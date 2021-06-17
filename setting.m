% taille des messages
Ms = [1 0 1 1 0];
Mslen = length(Ms);
Mdlen = 8;

% nature des messages
Nature = 'SI'; % SI, SGA, ...

% nombre de modules
K = 3;

% nombre de ressources phys dispo
N = 4;

% débit binaire
Tb = 0.01;
R = 1/Tb;

% facteur de surechantill
%bet = 4*N-2;
bet = 100;
% paramètres du FIR
alph = 0.1;
L = 5;
nb = 3;

% puissance transmise et impédance du câble
Pt = 1;
Zc = 50;

% facteur de suréchantillonnage
gamm = 1;

% paramètre du canal
alphan = 0.4;
taun = 0;

% SNR
SNR = 1000000;

% seuil pour le récepteur simplifié
V = 4;

%filter variable
norder = 5;


% calcul de variables
Tn = Tb/bet;
Ta = Tn/gamm;
Mlen = Mslen + Mdlen;
Lar = 2;