

% réglage de la taille de nos fenetres
L_boite = 33;
H_boite = 66;
nb_images = size(images_train_n,2);

% paramètres utilisé pour l'extraction des HOG
cell_size = [8,8];
num_bins = 9;
use_signed_orientation = true;

% reglage du nombre de boites négatives par images
nb_neg_par_image = 10;


% ---------- boites positives ----------
fprintf('Extraction des boites positives\n');
boites_pos_temp = cell(1,nb_images);
for i=1:nb_images,
    fprintf('image %d\n',i);
    x = labels(i,1);
    y = labels(i,2);
    l = labels(i,3);
    h = labels(i,4);
        
    % ajoute du padding pour lui donner le rapport H/L = 2
    L2 = (h / 2);
    diff = L2-l;
    x = floor(x - diff /2);
    if(x<1),
        x = 1;
    end
    % gere les boites qui depassent de l'image   
    if x+L2-1>size(images_train_n{i},2),
       x = x - (x+L2-1-size(images_train_n{i},2));
    end
    boites_pos_temp{i} = images_train_n{i}(y:y+h-1,x:floor(x+L2-1));
end
% redimensionnement des boites pour leur donner la meme taille
boites_pos = cell(1,nb_images);
for i=1:nb_images,
    boites_pos{i} = imresize(boites_pos_temp{i},[H_boite,L_boite]);
end
clear boites_pos_temp;
% extraction des HOG des images positives
boites_pos_hog = [];
for i=1:nb_images,
   fprintf('image %d\n',i);
   boites_pos_hog = [boites_pos_hog ; extractHOGFeatures(boites_pos{i},'CellSize',cell_size,'NumBins',num_bins,'UseSignedOrientation',use_signed_orientation)];
   img_inverse = boites_pos{i}(:,end:-1:1);
   boites_pos_hog = [boites_pos_hog ; extractHOGFeatures(img_inverse,'CellSize',cell_size,'NumBins',num_bins,'UseSignedOrientation',use_signed_orientation)];
end
clear boites_pos;
% save('boites_pos_hog.mat','boites_pos_hog');


% ---------- boites negatives ----------
fprintf('Extraction des boites négatives\n');
boites_neg_hog = [];
nb_boites_neg = nb_images*nb_neg_par_image;

% generer les negatifs
boites_neg_temp = cell(1,nb_boites_neg);
j=1;
labels_neg = [];
for i=1:nb_images,
    for n=1:nb_neg_par_image,
       % on genere des boites fausses aleatoirement de largeur 0.5 à 1 fois
       % la largeur de la vraie boite
       img = images_train_n{i};
       l_img = size(img,2);
       h_img = size(img,1);
       
       l_boite_init = labels(i,3);

       l_boite = labels(i,3);
       h_boite = labels(i,4);
       x_boite = labels(i,1);
       y_boite = labels(i,2);
       
       while recouvre(labels(i,:),[x_boite,y_boite,l_boite,h_boite])>0.5,
           l_boite = randi([round(0.5*l_boite_init),l_boite_init]);
           h_boite = l_boite * 2;
           x_boite = randi([1 max(1,l_img-l_boite)]);
           y_boite = randi([1 max(1,h_img-h_boite)]);     
       end
       
       % boite negative qui ne recouvre pas la vraie
        boites_neg_temp{j} = img(y_boite:min(h_img,y_boite+h_boite-1),x_boite:min(l_img,x_boite+l_boite-1),:); 
        labels_neg = [labels_neg ; [x_boite y_boite l_boite h_boite]];
        j = j +1; 
       % fprintf('boite negative %d \n',n);
    end   
end
% redimensionnement des boites negatives
boites_neg = cell(1,nb_boites_neg);
for i=1:nb_boites_neg,
    boites_neg{i} = imresize(boites_neg_temp{i},[H_boite,L_boite]);
end
clear boites_neg_temp;
% extraction des HOG des images neg
for i=1:nb_boites_neg,
    fprintf('image %d\n',i);
    boites_neg_hog = [boites_neg_hog ; extractHOGFeatures(boites_neg{i},'CellSize',cell_size,'NumBins',num_bins,'UseSignedOrientation',use_signed_orientation)];
    img_inverse = boites_neg{i}(:,end:-1:1);
    boites_neg_hog = [boites_neg_hog ; extractHOGFeatures(img_inverse,'CellSize',cell_size,'NumBins',num_bins,'UseSignedOrientation',use_signed_orientation)];
end
% save('boites_neg_hog.mat','boites_neg_hog');
clear boites_neg;




% On peut afficher certaines images avec les boites negatives et
% la boite positive pour visualiser le resultat

% for a=26:30,
%     figure();
%     aff_img_n(images_train_n{a});
%     hold on;
%     rectangle('Position',labels(a,:),'EdgeColor','g');
%     for i = 1:nb_neg_par_image,
%         rectangle('Position',labels_neg((a-1)*nb_neg_par_image+i,:),'EdgeColor','r');
%     end
% end


