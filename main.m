%% Settings
k=25; % k largest eigenvectors of Laplacian 
K=2;  % K for the k means algorithm 
file = './example2.dat'; %select file

%% 1. Get affinity matrix 

E = csvread(file);
col1 = E(:,1);
col2 = E(:,2);
max_ids = max(max(col1,col2));
As = sparse(col1, col2, 1, max_ids, max_ids); 
A = full(As);
A = double(A > 0);
figure,
hold on
G = graph(A);
p = plot(G,'layout','force','Marker','.','MarkerSize',15);
title('Graph');
axis equal
hold off
%% 2. Get Laplacian
D = diag(sum(A,2));
L = (D^-0.5)*A*(D^-0.5);

%% 2.1 plot fiedler vector
[v,d] = eigs(L,k,'sa'); % get k smallest eigenvectors
fiedler=v(:,2);
figure,
plot(sort(fiedler))
title('fiedler')

%% 3. Get k largest eigenvectors of laplacian
[eigs_Lk,eigsLk_d] = eigs(L,k); % get k largest eigenvectors

%% 4. Normalize X
Y = normalize(eigs_Lk);

%% K means
rng(30)
opts = statset('Display','final');
[idx,C] = kmeans(Y,K,'Distance','cityblock',...
'Replicates',5,'Options',opts);
cc=hsv(K);
figure,
hold on;
G = graph(A);
p = plot(G,'layout','force','Marker','.','MarkerSize',20);
for i = 1:K
    highlight(p,find(idx==i),'NodeColor',cc(i,:))
end
title('Clusters')
hold off;
