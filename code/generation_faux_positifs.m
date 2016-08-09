% echelles qui seront utilisées
echelles = [1/13 1/12 1/11 1/10 1/9 1/8 1/7 1/6 1/5 1/4 1/3 1/2 3/4 1];

boites_extractions = cell(0);
index=1;
boites_neg_hog_supp = [];
for k=1:size(images_train_n,2),
    tic   
    img_init = images_train_n{k};
    positif_r = [];
    positif_extraction = [];
    
    for ratio_idx=1:size(echelles,2),
        ratio = echelles(ratio_idx);
        img = imresize(img_init,ratio);
        
        l_img = size(img,2);
        h_img = size(img,1);
        pas_x = max(10,round((l_img-L_boite)/15));
        pas_y = max(10,round((h_img-H_boite)/15));
        
        x = 1; y = 1;
        
        data = [];
        coords = [];
        
        while y+H_boite<=size(img,1),
            while x+L_boite<=size(img,2),
                extraction = img(y:y+H_boite-1,x:x+L_boite-1);
                extraction_hog = extractHOGFeatures(extraction,'CellSize',cell_size,'NumBins',num_bins,'UseSignedOrientation',use_signed_orientation);
                data = [data; extraction_hog];
                boite = [round(x/ratio) round(y/ratio) round(L_boite/ratio) round(H_boite/ratio)];
                coords = [coords; boite];
                x = x + pas_x;
            end
            x = 1;
            y = y + pas_y;
        end
        
        % prédiction pour toutes les boîtes de l'image avec l'échelle
        % actuelle
        if size(data,1)>0,
            [label, score] = model.predict(data);
            label = max(label,0);
            indices_detect = find(label);
            for ind=1:size(indices_detect,1),
                idx = indices_detect(ind);
                if recouvre(labels(k,:),coords(idx,:))<=0.5,    
                    % il s'agit d'un faux positif
                    positif_r = [positif_r; coords(idx,:)]; 
                    positif_extraction = [positif_extraction; extraction_hog];
                end
            end
        end
    end
    if size(positif_extraction,1)>0,
        boites_neg_hog_supp = [boites_neg_hog_supp ; positif_extraction];
    end
    fprintf('img %d\n',k);
    fprintf('boites négatives supplémentaires : %d \n',size(boites_neg_hog_supp,1));
    toc
end

