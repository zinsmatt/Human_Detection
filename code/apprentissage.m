% création de la matrice d'apprentissage X avec les étiquettes
% correspondantes Y
X = [boites_pos_hog;boites_neg_hog];
Y = [ones(size(boites_pos_hog,1),1);-ones(size(boites_neg_hog,1),1)];

% par la validation croisée, on obtient un paramètre de 2^-2
model = fitcsvm(X,Y,'BoxConstraint',2^-2);


% --------- validation croisee pour le parametre BoxConstraint ---------
% lx = [];
% ly = [];
% k = 5;
% for t=-2:0.5:0,
%     c = 2^t;
%     total_erreur = 0;
%     for i=1:k,
%         fprintf('c = 2^%d , k = %d\n',t,i);
%         X_train = X;
%         X_train(i:k:end,:) = [];
%         Y_train = Y;
%         Y_train(i:k:end,:) = [];
% 
%         X_test = X(i:k:end,:);
%         Y_test = Y(i:k:end,:);
% 
%         model = fitcsvm(X_train,Y_train,'BoxConstraint',c);
%         disp('fitcsvm fait');
%         pred = model.predict(X_test);
%         erreur = sum(pred~=Y_test,1)/size(Y_test,1);
%         fprintf('erreur = %f\n',erreur);
%         total_erreur = total_erreur + erreur;
%     end
%     lx = [lx t];
%     ly = [ly total_erreur/k];
% end
% plot(lx,ly);
