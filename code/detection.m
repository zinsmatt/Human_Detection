detections = []; % contiendra pour chaque image la meilleure détection sous la forme [x y l h s]
    
for k=1:size(images_test_n,2),
    tic
    img_init = images_test_n{k};
    data = [];
    coords = [];
    for ratio_idx=1:size(echelles,2),   
        ratio = echelles(ratio_idx);
        img = imresize(img_init,ratio);
        
        l_img = size(img,2);
        h_img = size(img,1);
        pas_x = max(10,round((l_img-L_boite)/15));
        pas_y = max(10,round((h_img-H_boite)/15));
        
        x = 1; y = 1;    
        while y+H_boite<=size(img,1),
            while x+L_boite<=size(img,2),
                extraction = img(y:y+H_boite-1,x:x+L_boite-1);            
                extraction_hog = extractHOGFeatures(extraction,'CellSize',cell_size,'NumBins',num_bins,'UseSignedOrientation',use_signed_orientation);
                boite = [round(x/ratio) round(y/ratio) round(L_boite/ratio) round(H_boite/ratio)];
                data = [data; extraction_hog];
                coords = [coords; boite];        
                x = x + pas_x;
            end
            x = 1;
            y = y + pas_y;
        end
    end
    % prédiction pour toutes fenêtres de l'image à différentes échelles
    [label, scores] = model.predict(data);
    coords = [coords scores(:,2)];
    label = max(label,0);
    indices_detect = find(label);
    if size(indices_detect,1)>0,
        coords_pos = coords(indices_detect,:);
        [v,i_max] = max(coords_pos(:,5));
        detections = [detections; coords_pos(i_max,:)];
    else
       detections = [detections; 0 0 0 0 0];    %si il n'y a eu aucune détection
    end
    fprintf('fin image %d\n',k);
    toc
end


% sauvegarde des coordonnées des détections et du score dans les fichiers
for i=1:size(detections,1),
    str = sprintf('detections/%03d.txt',i);
    dlmwrite(str,detections(i,:),'delimiter',' ');
end

% affichage de quelques détection pour verifier visuellement
% for i=1:10,
%     figure();
%     str = sprintf('detections/%03d.txt',i);
%     x = load(str);
%     aff_img_n(images_test_n{i});
%     title(num2str(x(1,5)));
%     hold on;
%     rectangle('Position',x(1,1:4),'EdgeColor','g');
% end









