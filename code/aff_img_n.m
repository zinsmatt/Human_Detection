function [] = aff_img_n( img )
% affiche une image normalis�es
mini = min(img(:));
img = img - mini;
maxi = max(img(:));
img = img./maxi;
imshow(img);
end

