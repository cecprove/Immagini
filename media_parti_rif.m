function diff_media = media_parti_rif(thumbnail, lunghezza_rif)

%% Feature: Media delle parti rif
elab_immagine_rif = struct;
for i=1:lunghezza_rif
   [~, threshold] = edge(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space, 'sobel');
   fudgeFactor = .2;
   elab_immagini_rif(i).imm_contorni = edge(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space,'sobel', threshold * fudgeFactor);
   
end
%imshow(elab_immagini(3).imm_contorni)

for i=1:lunghezza_rif
   elab_immagini_rif(i).imm_fill = imfill(elab_immagini_rif(i).imm_contorni, 'holes');
end
%figure
%imshow(elab_immagini(5).imm_fill)

background_rif= struct;
for i=1:lunghezza_rif
   elab_immagini_rif(i).binary = imbinarize(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space)
%prendo le due fasce laterali dell'immagine   
   background_rif(i).background = elab_immagini_rif(i).binary - elab_immagini_rif(i).imm_fill
end
%imshow(background(11).background)



for i=1:lunghezza_rif
   background_rif(i).backpartesx = background_rif(i).background(1:16,1:4);
end
% imshow(background(4).backpartesx)

for i=1:lunghezza_rif
   background_rif(i).backpartedx = background_rif(i).background(1:16,13:16);
end


%calcolo media

for i=1:lunghezza_rif
   media_partesx_rif(i,1) = mean2(background_rif(i).backpartesx);
end


for i=1:lunghezza_rif
   media_partedx_rif(i,1) = mean2(background_rif(i).backpartedx);
end
diff_media=media_partesx_rif-media_partedx_rif;

end