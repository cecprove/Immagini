function diff_media_totImm_noise_4 = media_parti_tot_noise_4(thumbnail,lunghezza_tot)
%% Effettuo la stessa cosa per tutte le immagini

elab_immagini = struct;
for i=1:lunghezza_tot
   [~, threshold] = edge(thumbnail.thumbnail_16x16_senza_rif(i).noise_16x16_4, 'sobel');
   fudgeFactor = .2;
   elab_immagini(i).imm_contorni = edge(thumbnail.thumbnail_16x16_senza_rif(i).noise_16x16_4,'sobel', threshold * fudgeFactor);
   
end
%imshow(elab_immagini(3).imm_contorni)

for i=1:lunghezza_tot
   elab_immagini(i).imm_fill = imfill(elab_immagini(i).imm_contorni, 'holes');
end
%figure
%imshow(elab_immagini(5).imm_fill)

background_noise= struct;
for i=1:lunghezza_tot
   elab_immagini(i).binary = imbinarize(thumbnail.thumbnail_16x16_senza_rif(i).noise_16x16_4);
%prendo le due fasce laterali dell'immagine   
    background_noise(i).background_noise = elab_immagini(i).binary - elab_immagini(i).imm_fill;
end
%imshow(background_noise(11).background_noise)



for i=1:lunghezza_tot
    if rank(double(thumbnail.thumbnail_16x16_senza_rif(i).thumbnail.thumbnail_16x16)) ~= 0
        background_noise(i).backpartesx = background_noise(i).background_noise(1:16,1:4);
    end
end
% imshow(background_noise(4).backpartesx)

for i=1:lunghezza_tot
     if rank(double(thumbnail.thumbnail_16x16_senza_rif(i).thumbnail.thumbnail_16x16)) ~= 0
        background_noise(i).backpartedx = background_noise(i).background_noise(1:16,13:16);
     end
end


%calcolo media

for i=1:lunghezza_tot
   media_partesx(i,1) = mean2(background_noise(i).backpartesx);
end


for i=1:lunghezza_tot
   media_partedx(i,1) = mean2(background_noise(i).backpartedx);
end

diff_media_totImm_noise_4 = media_partesx - media_partedx;





end