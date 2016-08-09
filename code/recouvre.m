function [ res ] = recouvre( zone1, zone2)
% calcul le taux de recouvrement entre les deux zones
res = 0;

x1 = zone1(1);
y1 = zone1(2);
l1 = zone1(3);
h1 = zone1(4);

x2 = zone2(1);
y2 = zone2(2);
l2 = zone2(3);
h2 = zone2(4);

liste_x1 = x1:x1+l1-1;
liste_x2 = x2:x2+l2-1;
inter_x = intersect(liste_x1,liste_x2);

liste_y1 = y1:y1+h1-1;
liste_y2 = y2:y2+h2-1;
inter_y = intersect(liste_y1,liste_y2);
if size(inter_x,2)>1 && size(inter_y,2)>1,
    aire_inter = (inter_x(end)-inter_x(1)+1)*(inter_y(end)-inter_y(1)+1);
    aire_union = l1*h1+l2*h2-aire_inter;
    res = aire_inter/aire_union;
end
end

