function diff_media_totImm = media_parti_tot(thumbnail,lunghezza_tot)



%% Effettuo la stessa cosa per tutte le immagini

elab_immagini = struct;
for i=1:lunghezza_tot
   [~, threshold] = edge(thumbnail.thumbnail_16x16(i).thumbnail.thumbnail_16x16, 'sobel');
   fudgeFactor = .2;
   elab_immagini(i).imm_contorni = edge(thumbnail.thumbnail_16x16(i).thumbnail.thumbnail_16x16,'sobel', threshold * fudgeFactor);
   
end
%imshow(elab_immagini(3).imm_contorni)

for i=1:lunghezza_tot
   elab_immagini(i).imm_fill = imfill(elab_immagini(i).imm_contorni, 'holes');
end
%figure
%imshow(elab_immagini(5).imm_fill)

background= struct;
for i=1:lunghezza_tot
   elab_immagini(i).binary = imbinarize(thumbnail.thumbnail_16x16(i).thumbnail.thumbnail_16x16)
%prendo le due fasce laterali dell'immagine   
    background(i).background = elab_immagini(i).binary - elab_immagini(i).imm_fill
end
%imshow(background(11).background)



for i=1:lunghezza_tot
   background(i).backpartesx = background(i).background(1:16,1:4);
end
% imshow(background(4).backpartesx)

for i=1:lunghezza_tot
   background(i).backpartedx = background(i).background(1:16,13:16);
end


%calcolo media

for i=1:lunghezza_tot
   media_partesx(i,1) = mean2(background(i).backpartesx);
end


for i=1:lunghezza_tot
   media_partedx(i,1) = mean2(background(i).backpartedx);
end

diff_media_totImm = media_partesx - media_partedx;





end