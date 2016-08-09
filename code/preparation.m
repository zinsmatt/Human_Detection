clear all;
% pour faire fonctionner le détecteur il faut exécuter les différents
% scripts dans l'ordre suivant :
% 1) preparation
% 2) extraction_boites_test
% 3) apprentissage
% 4) generation_faux_positifs
% 5) reapprentissage
% 6) detection


% chargement des labels
src_labels = dir('label\*.txt');
labels = [];
for i = 1 : length(src_labels)  
    filename = strcat('label\',src_labels(i).name);
    x = load(filename);
    labels = [labels ; x];   
end
% save('labels.mat','labels');
clear x,src_labels;

% chargement des images d'apprentissage
src_images = dir('train\*.jpg');
images_train = cell(1,length(src_images) );
for i = 1 : length(src_images)  
    filename = strcat('train\',src_images(i).name);
    I = imread(filename);
    images_train{i} = I;
end
% save('images_train.mat','images_train');


% normalisation des images d'apprentissage
images_train_n = cell(1,size(images_train,2));
for i=1:size(images_train,2),
   img = rgb2gray(images_train{i});
   img = im2double(img);
   img_n = (img-mean(img(:)))/sqrt(var(img(:)));
   images_train_n{i} = img_n;
end
% save('images_train_n.mat','images_train_n');
clear images_train;     % pour économiser la mémoire


% chargement des images de test
src_images = dir('test\*.jpg');
images_test = cell(1,length(src_images) );
for i = 1 : length(src_images)  
    filename = strcat('test\',src_images(i).name);
    I = imread(filename);
    images_test{i} = I;
end
% save('images_test.mat','images_test');

% normalisation des images d'apprentissage
images_test_n = cell(1,size(images_test,2));
for i=1:size(images_test,2),
   img = rgb2gray(images_test{i});
   img = im2double(img);
   img_n = (img-mean(img(:)))/sqrt(var(img(:)));
   images_test_n{i} = img_n;
end
% save('images_test_n.mat','images_test_n');
clear images_test img img_n src_images src_labels filename I i;      % pour économiser la mémoire
