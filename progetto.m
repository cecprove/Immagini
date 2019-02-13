%% Creare il database
imagespath=dir('C:\Users\cecil\Documents\Universita\ElaborazioneImmagini\Progetto\Database_per_gli_elaborati_di_Tipo_2_20190202\Yale\Yale');
imagespath
ImagesPath=imagespath(4:end,:);% Per eliminare i primi tre elementi che non sono immagini
images=struct;
lista_tipologie=struct;
for i=1:size(ImagesPath,1)
    images(i).images=imread([ImagesPath(i).folder,'/',ImagesPath(i).name]);
    % creo il path totale dell'immagine, quindi
    % sto caricando con ogni ciclo la struttura ad ogni immagine
    % Se volessi solo l'immagine 7 scriverò images(7).images e gli dico di
    % andare a prendere la settima immagine che ha  caricato nel database, in
    % questo caso la struct
    
    
    %creo struct con tuttii nomi delle immagini
    lista_tipologie(i).lista = extractAfter(ImagesPath(i).name,".");
end


%creo array di stringhe che conterrà i nomi delle 11 tipologie delle
%immagini
lista_stringhe = string(lista_tipologie(1).lista);

for i=1:size(lista_tipologie,2)
    %prendo tutti i nomi dalla struct e li confronto con quelli presente in
    %lista_stringhe
    count = 0;
    for k=1:size(lista_stringhe,1)
        if count ==0 && ~strcmp(lista_tipologie(i).lista, lista_stringhe(k))
        else
            count = 1;
        end
    end
    if count == 0
        %aggiungo la nuova tipologia in lista_stringhe
        lista_stringhe = [lista_stringhe;string(lista_tipologie(i).lista)];
    end
end

%% %%%%% P1
%% Costruire per ogni immagine una thumbnail (16x16)
% Quindi attraverso un ciclo for costruisco una thumnail per ogni immagine
thumbnail.thumbnail_16x16= struct;
for i=1:size(ImagesPath,1)
    thumbnail.thumbnail_16x16(i).thumbnail.thumbnail_16x16=imresize(images(i).images,[16 16]);
end
% per prova: imshowpair(images(7).images,thumbnail.thumbnail_16x16(7).thumbnail.thumbnail_16x16,'montage')






%% Costruire le 11 thumbnail di riferimento (dominio dello spazio)
thumbnail.thumbnail_rif = struct;
% Quale immagine scegliamo per l'espessione sad tra queste?

% imshow(images(9).images,images(20).images,images(31).images,images(42).images,images(53).images,...
%     images(64).images,images(75).images,images(86).images,images(97).images,images(108).images,...
%     images(119).images,images(130).images,images(141).images,images(152).images,...
%     images(163).images)
%poniamo es 53

% Creiamo un vettore contenente gli indici delle immagini che prendiamo
% come riferimento nel dominio dello spazio
%k = [35 47 15 60 72 84 107 53 131 143 166]';


%creo riferimenti
stringa_sub = '01';
for i=1:size(lista_stringhe,1)
    for k=1:size(ImagesPath,1)
        if strcmp(extractAfter(ImagesPath(k).name,"."),lista_stringhe(i))&& ...
                strcmp(extractBefore(ImagesPath(k).name,"."),['subject',stringa_sub])
            thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space = imread([ImagesPath(k).folder,'/',ImagesPath(k).name]);
            thumbnail.thumbnail_rif(i).tipologia = extractAfter(ImagesPath(k).name,".");
            thumbnail.thumbnail_rif(i).soggetto = extractBefore(ImagesPath(k).name,".");
            switch stringa_sub
                case '01'
                    stringa_sub = '02';
                case '02'
                    stringa_sub = '03';
                case '03'
                    stringa_sub = '04';
                case '04'
                    stringa_sub = '05';
                case '05'
                    stringa_sub = '06';
                case '06'
                    stringa_sub = '07';
                case '07'
                    stringa_sub = '08';
                case '08'
                    stringa_sub = '09';
                case '09'
                    stringa_sub = '10';
                case '10'
                    stringa_sub = '11';
            end
            break;
        end
    end
end

%associo all immagini della thumbnail le etichette
for k=1:size(ImagesPath,1)
    for i=1:size(lista_stringhe,1)
        if strcmp(extractAfter(ImagesPath(k).name,"."),lista_stringhe(i))
            thumbnail.thumbnail_16x16(k).tipologia = extractAfter(ImagesPath(k).name,".");
        end
    end
end


for i=1:size(thumbnail.thumbnail_16x16,2)
    switch thumbnail.thumbnail_16x16(i).tipologia
        case 'glasses'
           thumbnail.thumbnail_16x16(i).etichetta = 1; 
        case 'happy'
            thumbnail.thumbnail_16x16(i).etichetta = 2;
        case 'leftlight'
            thumbnail.thumbnail_16x16(i).etichetta = 3;
        case 'noglasses'
            thumbnail.thumbnail_16x16(i).etichetta = 4;
        case 'normal'
            thumbnail.thumbnail_16x16(i).etichetta = 5;
        case 'rightlight'
            thumbnail.thumbnail_16x16(i).etichetta = 6;
        case 'sad'
            thumbnail.thumbnail_16x16(i).etichetta = 7;
        case 'sleepy'
            thumbnail.thumbnail_16x16(i).etichetta = 8;
        case 'surprised'
            thumbnail.thumbnail_16x16(i).etichetta = 9;
        case 'wink'
            thumbnail.thumbnail_16x16(i).etichetta = 10;
        case 'centerlight'
            thumbnail.thumbnail_16x16(i).etichetta = 11;
                  
    end
            
end



for i=1:size(thumbnail.thumbnail_rif,2)
    thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space=imresize(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space,[16 16]);
  %  figure
  %  imshow(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space);
end



%creo dominio di riferimento (DCT2)
for i=1:size(thumbnail.thumbnail_rif,2)
    thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_freq = dct2(im2double(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space));
    %creo etichette
    thumbnail.thumbnail_rif(i).etichetta = i;
end


diff_media = media_parti_rif(thumbnail, size(thumbnail.thumbnail_rif,2));
diff_media_totImm = media_parti_tot(thumbnail,size(thumbnail.thumbnail_16x16,2));




%creo feature.normals di riferimento
for i=1:size(thumbnail.thumbnail_rif,2)
     feature.normal_rif(i).media =  mean(mean(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space));
     feature.normal_rif(i).entropia = entropy(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space);
     feature.normal_rif(i).etichetta =    thumbnail.thumbnail_rif(i).etichetta;
     feature.normal_rif(i).mediaparti = diff_media(i);
     feature.normal_rif(i).simmetria = skewness(skewness(double(thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space)));
 end

% %creo DB
% for i=1:size(thumbnail.thumbnail_rif,2)
%     DB(i,:)=[feature.normal(i).media ,feature.normal(i).entropia,thumbnail.thumbnail_rif(i).etichetta]; 
% end


%creo feature.normals per tutte le immagini
%devo togliere le 11 immagini di riferimento
for i=1:size(thumbnail.thumbnail_16x16,2)
     feature.normal(i).media =  mean(mean(thumbnail.thumbnail_16x16(i).thumbnail.thumbnail_16x16));
     feature.normal(i).entropia = entropy(thumbnail.thumbnail_16x16(i).thumbnail.thumbnail_16x16);
     feature.normal(i).mediaparti = diff_media_totImm(i);
     feature.normal(i).simmetria = skewness(skewness(double(thumbnail.thumbnail_16x16(i).thumbnail.thumbnail_16x16)));
end

 % tolgo le 11 di riferimento aggiugenoìdo matrici nulle
for i=1:size(thumbnail.thumbnail_rif,2)
  trovato = 0;
  for k=1:size(thumbnail.thumbnail_16x16,2)
      if thumbnail.thumbnail_rif(i).thumbnail.thumbnail_rif_space == thumbnail.thumbnail_16x16(k).thumbnail.thumbnail_16x16 
          thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16 = zeros(16);
          feature.normal(k).media = 0;
          feature.normal(k).entropia = 0; 
          feature.normal(k).mediaparti = 0;
          feature.normal(k).simmetria = 0;
          trovato = 1;
          indici(i)=k;
      else
          if trovato == 1
          thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16 = thumbnail.thumbnail_16x16(k).thumbnail.thumbnail_16x16;
          end
      end
  end
end


for i=1:size(thumbnail.thumbnail_16x16_senza_rif,2)
    if mean(mean(double(thumbnail.thumbnail_16x16_senza_rif(i).thumbnail.thumbnail_16x16) == zeros(16))) ~= 1 
        thumbnail.thumbnail_16x16_senza_rif(i).tipologie = thumbnail.thumbnail_16x16(i).tipologia;
        thumbnail.thumbnail_16x16_senza_rif(i).etichetta = thumbnail.thumbnail_16x16(i).etichetta;
    end
end

%plot delle immagini di riferimento
  for i=1:size(feature.normal_rif,2)
      scatter(feature.normal_rif(i).media,feature.normal_rif(i).entropia)
      text(feature.normal_rif(i).media,feature.normal_rif(i).entropia,string(feature.normal_rif(i).etichetta),'VerticalAlignment','bottom')
      hold on
  end

  
  
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if rank(double(thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16)) ~= 0
         for i= 1: size(thumbnail.thumbnail_rif,2)
                 distanze.distanze_normal.distanze_m_e(i,k) = pdist([feature.normal(k).media, feature.normal(k).entropia;feature.normal_rif(i).media,feature.normal_rif(i).entropia]);
                 distanze.distanze_normal.distanze_m_e_mp(i,k) = pdist([feature.normal(k).media, feature.normal(k).entropia,feature.normal(k).mediaparti;feature.normal_rif(i).media,feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);  
                 distanze.distanze_normal.distanze_e_mp(i,k) = pdist([feature.normal(k).entropia,feature.normal(k).mediaparti;feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_normal.distanze_m_mp(i,k) = pdist([feature.normal(k).media,feature.normal(k).mediaparti;feature.normal_rif(i).media, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_normal.distanze_s_mp(i,k) = pdist([feature.normal(k).simmetria,feature.normal(k).mediaparti;feature.normal_rif(i).simmetria, feature.normal_rif(i).mediaparti]);
         end
         end
 end  

 
     %verità per features media e entropia
 counter.counter_normal.counter_m_e=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_normal.distanze_m_e(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_normal.distanze_m_e(:,k));
        verita.verita_normal.verita_m_e(k).minimi = minimo;
        verita.verita_normal.verita_m_e(k).etichetta_calcolata = index;
        verita.verita_normal.verita_m_e(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_normal.verita_m_e(k).etichetta_calcolata == verita.verita_normal.verita_m_e(k).etichetta_vera
            verita.verita_normal.verita_m_e(k).gt=1;
             counter.counter_normal.counter_m_e =  counter.counter_normal.counter_m_e+1;
        else
            verita.verita_normal.verita_m_e(k).gt=0;
        end
     end
 end
 
 
  %verità per features simmetria e media parti
  counter.counter_normal.counter_s_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_normal.distanze_s_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_normal.distanze_s_mp(:,k));
        verita.verita_normal.verita_s_mp(k).minimi = minimo;
        verita.verita_normal.verita_s_mp(k).etichetta_calcolata = index;
        verita.verita_normal.verita_s_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_normal.verita_s_mp(k).etichetta_calcolata == verita.verita_normal.verita_s_mp(k).etichetta_vera
            verita.verita_normal.verita_s_mp(k).gt=1;
            counter.counter_normal.counter_s_mp = counter.counter_normal.counter_s_mp+1;
        else
            verita.verita_normal.verita_s_mp(k).gt=0;
        end
     end
 end
 
 
 
   %verità per features media e entropia e media parti
 counter.counter_normal.counter_m_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_normal.distanze_m_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_normal.distanze_m_e_mp(:,k));
        verita.verita_normal.verita_m_e_mp(k).minimi = minimo;
        verita.verita_normal.verita_m_e_mp(k).etichetta_calcolata = index;
        verita.verita_normal.verita_m_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_normal.verita_m_e_mp(k).etichetta_calcolata == verita.verita_normal.verita_m_e_mp(k).etichetta_vera
            verita.verita_normal.verita_m_e_mp(k).gt=1;
             counter.counter_normal.counter_m_e_mp =  counter.counter_normal.counter_m_e_mp+1;
        else
            verita.verita_normal.verita_m_e_mp(k).gt=0;
        end
     end
 end
 
 
    %verità per features entropia e media parti
 counter.counter_normal.counter_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_normal.distanze_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_normal.distanze_e_mp(:,k));
        verita.verita_normal.verita_e_mp(k).minimi = minimo;
        verita.verita_normal.verita_e_mp(k).etichetta_calcolata = index;
        verita.verita_normal.verita_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_normal.verita_e_mp(k).etichetta_calcolata == verita.verita_normal.verita_e_mp(k).etichetta_vera
            verita.verita_normal.verita_e_mp(k).gt=1;
             counter.counter_normal.counter_e_mp =  counter.counter_normal.counter_e_mp+1;
        else
            verita.verita_normal.verita_e_mp(k).gt=0;
        end
     end
 end
 
 
 
     %verità per features media e media parti
 counter.counter_normal.counter_m_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_normal.distanze_m_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_normal.distanze_m_mp(:,k));
        verita.verita_normal.verita_m_mp(k).minimi = minimo;
        verita.verita_normal.verita_m_mp(k).etichetta_calcolata = index;
        verita.verita_normal.verita_m_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_normal.verita_m_mp(k).etichetta_calcolata == verita.verita_normal.verita_m_mp(k).etichetta_vera
            verita.verita_normal.verita_m_mp(k).gt=1;
             counter.counter_normal.counter_m_mp =  counter.counter_normal.counter_m_mp+1;
        else
            verita.verita_normal.verita_m_mp(k).gt=0;
        end
     end
 end
 
 %% introduco rumore
 potenza_rumore = logspace(-5,-1,5);
for k=1:size(thumbnail.thumbnail_16x16,2)
      if rank(double(thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16)) ~= 0
          
      thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_1 =...
      double(thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16) + ...
      sqrt(potenza_rumore(2))*randn(size( thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16));
  
  
      thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_2 =...
      double(thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16) +...
      sqrt(potenza_rumore(3))*randn(size( thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16));
  
  
      thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_3 =...
      double(thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16) +...
      sqrt(potenza_rumore(4))*randn(size( thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16));
  
      thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_4 =...
      double(thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16) +...
      sqrt(potenza_rumore(5))*randn(size( thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16));
  
  
  
      end
end
 

%calcolo features per immagini rumorose


 diff_media_totImm_noise_1 = media_parti_tot_noise_1(thumbnail,size(thumbnail.thumbnail_16x16,2));
 diff_media_totImm_noise_2 = media_parti_tot_noise_2(thumbnail,size(thumbnail.thumbnail_16x16,2));
 diff_media_totImm_noise_3 = media_parti_tot_noise_3(thumbnail,size(thumbnail.thumbnail_16x16,2));
 diff_media_totImm_noise_4 = media_parti_tot_noise_4(thumbnail,size(thumbnail.thumbnail_16x16,2));
 
 %potenza 0.0001
  for k=1:size(thumbnail.thumbnail_16x16,2)
      if feature.normal(k).entropia==0
          feature.potenza_1(k).media = 0;
          feature.potenza_1(k).entropia = 0; 
          feature.potenza_1(k).mediaparti = 0; 
          feature.potenza_1(k).simmetria = 0;
      else
          feature.potenza_1(k).media =  mean(mean(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_1)));
          feature.potenza_1(k).entropia = entropy(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_1));
          feature.potenza_1(k).mediaparti = diff_media_totImm_noise_1(k);
          feature.potenza_1(k).simmetria = skewness(skewness(double(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_1)));
          end
      end

%potenza 0.001

  for k=1:size(thumbnail.thumbnail_16x16,2)
      if feature.normal(k).entropia==0
          feature.potenza_2(k).media = 0;
          feature.potenza_2(k).entropia = 0; 
          feature.potenza_2(k).mediaparti = 0;
          feature.potenza_2(k).simmetria = 0;
      else
          feature.potenza_2(k).media =  mean(mean(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_2)));
          feature.potenza_2(k).entropia = entropy(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_2));
          feature.potenza_2(k).mediaparti = diff_media_totImm_noise_2(k);
          feature.potenza_2(k).simmetria = skewness(skewness(double(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_2)));
          end
  end

% potenza 0.01
      
  for k=1:size(thumbnail.thumbnail_16x16,2)
      if feature.normal(k).entropia==0
          feature.potenza_3(k).media = 0;
          feature.potenza_3(k).entropia = 0; 
          feature.potenza_3(k).mediaparti = 0;
          feature.potenza_3(k).simmetria = 0;
      else
          feature.potenza_3(k).media =  mean(mean(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_3)));
          feature.potenza_3(k).entropia = entropy(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_3));
          feature.potenza_3(k).mediaparti = diff_media_totImm_noise_3(k);
          feature.potenza_3(k).simmetria = skewness(skewness(double(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_3)));
      end
  end

  % potenza 0.1
  
   for k=1:size(thumbnail.thumbnail_16x16,2)
      if feature.normal(k).entropia==0
          feature.potenza_4(k).media = 0;
          feature.potenza_4(k).entropia = 0; 
          feature.potenza_4(k).mediaparti = 0;
          feature.potenza_4(k).simmetria = 0;
      else
          feature.potenza_4(k).media =  mean(mean(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_4)));
          feature.potenza_4(k).entropia = entropy(uint8(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_4));
          feature.potenza_4(k).mediaparti = diff_media_totImm_noise_4(k);
          feature.potenza_4(k).simmetria = skewness(skewness(double(thumbnail.thumbnail_16x16_senza_rif(k).noise_16x16_4)));
      end
  end
  
  
   for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if rank(double(thumbnail.thumbnail_16x16_senza_rif(k).thumbnail.thumbnail_16x16)) ~= 0
         for i= 1: size(thumbnail.thumbnail_rif,2)
             %per potenza 0.0001
                 distanze.distanze_noise1.distanze_m_e(i,k) = pdist([feature.potenza_1(k).media, feature.potenza_1(k).entropia;feature.normal_rif(i).media,feature.normal_rif(i).entropia]);
                 distanze.distanze_noise1.distanze_m_e_mp(i,k) = pdist([feature.potenza_1(k).media, feature.potenza_1(k).entropia,feature.potenza_1(k).mediaparti;feature.normal_rif(i).media,feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);  
                 distanze.distanze_noise1.distanze_e_mp(i,k) = pdist([feature.potenza_1(k).entropia,feature.potenza_1(k).mediaparti;feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise1.distanze_m_mp(i,k) = pdist([feature.potenza_1(k).media,feature.potenza_1(k).mediaparti;feature.normal_rif(i).media, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise1.distanze_s_mp(i,k) = pdist([feature.potenza_1(k).simmetria,feature.potenza_1(k).mediaparti;feature.normal_rif(i).simmetria, feature.normal_rif(i).mediaparti]);
                 
             %per potenza 0.0010
                 distanze.distanze_noise2.distanze_m_e(i,k) = pdist([feature.potenza_2(k).media, feature.potenza_2(k).entropia;feature.normal_rif(i).media,feature.normal_rif(i).entropia]);
                 distanze.distanze_noise2.distanze_m_e_mp(i,k) = pdist([feature.potenza_2(k).media, feature.potenza_2(k).entropia,feature.potenza_2(k).mediaparti;feature.normal_rif(i).media,feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);  
                 distanze.distanze_noise2.distanze_e_mp(i,k) = pdist([feature.potenza_2(k).entropia,feature.potenza_2(k).mediaparti;feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise2.distanze_m_mp(i,k) = pdist([feature.potenza_2(k).media,feature.potenza_2(k).mediaparti;feature.normal_rif(i).media, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise2.distanze_s_mp(i,k) = pdist([feature.potenza_2(k).simmetria,feature.potenza_2(k).mediaparti;feature.normal_rif(i).simmetria, feature.normal_rif(i).mediaparti]);
                 
             %per potenza 0.0100
                 distanze.distanze_noise3.distanze_m_e(i,k) = pdist([feature.potenza_3(k).media, feature.potenza_3(k).entropia;feature.normal_rif(i).media,feature.normal_rif(i).entropia]);
                 distanze.distanze_noise3.distanze_m_e_mp(i,k) = pdist([feature.potenza_3(k).media, feature.potenza_3(k).entropia,feature.potenza_3(k).mediaparti;feature.normal_rif(i).media,feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);  
                 distanze.distanze_noise3.distanze_e_mp(i,k) = pdist([feature.potenza_3(k).entropia,feature.potenza_3(k).mediaparti;feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise3.distanze_m_mp(i,k) = pdist([feature.potenza_3(k).media,feature.potenza_3(k).mediaparti;feature.normal_rif(i).media, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise3.distanze_s_mp(i,k) = pdist([feature.potenza_3(k).simmetria,feature.potenza_3(k).mediaparti;feature.normal_rif(i).simmetria, feature.normal_rif(i).mediaparti]);
                 
             % per potenza 0.1
                 distanze.distanze_noise4.distanze_m_e(i,k) = pdist([feature.potenza_4(k).media, feature.potenza_4(k).entropia;feature.normal_rif(i).media,feature.normal_rif(i).entropia]);
                 distanze.distanze_noise4.distanze_m_e_mp(i,k) = pdist([feature.potenza_4(k).media, feature.potenza_4(k).entropia,feature.potenza_4(k).mediaparti;feature.normal_rif(i).media,feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);  
                 distanze.distanze_noise4.distanze_e_mp(i,k) = pdist([feature.potenza_4(k).entropia,feature.potenza_4(k).mediaparti;feature.normal_rif(i).entropia, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise4.distanze_m_mp(i,k) = pdist([feature.potenza_4(k).media,feature.potenza_4(k).mediaparti;feature.normal_rif(i).media, feature.normal_rif(i).mediaparti]);
                 distanze.distanze_noise4.distanze_s_mp(i,k) = pdist([feature.potenza_4(k).simmetria,feature.potenza_4(k).mediaparti;feature.normal_rif(i).simmetria, feature.normal_rif(i).mediaparti]);
         end
         end
   end  
  
   %% Noise 1 
  %verità per features media e entropia noise1
 counter.counter_noise_1.counter_m_e=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise1.distanze_m_e(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise1.distanze_m_e(:,k));
        verita.verita_noise_1.verita_m_e(k).minimi = minimo;
        verita.verita_noise_1.verita_m_e(k).etichetta_calcolata = index;
        verita.verita_noise_1.verita_m_e(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_1.verita_m_e(k).etichetta_calcolata == verita.verita_noise_1.verita_m_e(k).etichetta_vera
            verita.verita_noise_1.verita_m_e(k).gt=1;
             counter.counter_noise_1.counter_m_e =  counter.counter_noise_1.counter_m_e+1;
        else
            verita.verita_noise_1.verita_m_e(k).gt=0;
        end
     end
 end

 %verità per features simmetria e media parti noise1
  counter.counter_noise_1.counter_s_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise1.distanze_s_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise1.distanze_s_mp(:,k));
        verita.verita_noise_1.verita_s_mp(k).minimi = minimo;
        verita.verita_noise_1.verita_s_mp(k).etichetta_calcolata = index;
        verita.verita_noise_1.verita_s_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_1.verita_s_mp(k).etichetta_calcolata == verita.verita_noise_1.verita_s_mp(k).etichetta_vera
            verita.verita_noise_1.verita_s_mp(k).gt=1;
            counter.counter_noise_1.counter_s_mp = counter.counter_noise_1.counter_s_mp+1;
        else
            verita.verita_noise_1.verita_s_mp(k).gt=0;
        end
     end
 end

  %verità per features media e entropia e media parti noise1
 counter.counter_noise_1.counter_m_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise1.distanze_m_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise1.distanze_m_e_mp(:,k));
        verita.verita_noise_1.verita_m_e_mp(k).minimi = minimo;
        verita.verita_noise_1.verita_m_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_1.verita_m_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_1.verita_m_e_mp(k).etichetta_calcolata == verita.verita_noise_1.verita_m_e_mp(k).etichetta_vera
            verita.verita_noise_1.verita_m_e_mp(k).gt=1;
             counter.counter_noise_1.counter_m_e_mp =  counter.counter_noise_1.counter_m_e_mp+1;
        else
            verita.verita_noise_1.verita_m_e_mp(k).gt=0;
        end
     end
 end
 
 
 %verità per features entropia e media parti noise1
 counter.counter_noise_1.counter_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise1.distanze_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise1.distanze_e_mp(:,k));
        verita.verita_noise_1.verita_e_mp(k).minimi = minimo;
        verita.verita_noise_1.verita_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_1.verita_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_1.verita_e_mp(k).etichetta_calcolata == verita.verita_noise_1.verita_e_mp(k).etichetta_vera
            verita.verita_noise_1.verita_e_mp(k).gt=1;
             counter.counter_noise_1.counter_e_mp =  counter.counter_noise_1.counter_e_mp+1;
        else
            verita.verita_noise_1.verita_e_mp(k).gt=0;
        end
     end
 end
 
  %verità per features media e media parti noise1
 counter.counter_noise_1.counter_m_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise1.distanze_m_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise1.distanze_m_mp(:,k));
        verita.verita_noise_1.verita_m_mp(k).minimi = minimo;
        verita.verita_noise_1.verita_m_mp(k).etichetta_calcolata = index;
        verita.verita_noise_1.verita_m_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_1.verita_m_mp(k).etichetta_calcolata == verita.verita_noise_1.verita_m_mp(k).etichetta_vera
            verita.verita_noise_1.verita_m_mp(k).gt=1;
             counter.counter_noise_1.counter_m_mp =  counter.counter_noise_1.counter_m_mp+1;
        else
            verita.verita_noise_1.verita_m_mp(k).gt=0;
        end
     end
 end
 
 
 
 
 
 
 %% Noise 2
 
 
  %verità per features media e entropia noise2
 counter.counter_noise_2.counter_m_e=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise2.distanze_m_e(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise2.distanze_m_e(:,k));
        verita.verita_noise_2.verita_m_e(k).minimi = minimo;
        verita.verita_noise_2.verita_m_e(k).etichetta_calcolata = index;
        verita.verita_noise_2.verita_m_e(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_2.verita_m_e(k).etichetta_calcolata == verita.verita_noise_2.verita_m_e(k).etichetta_vera
            verita.verita_noise_2.verita_m_e(k).gt=1;
             counter.counter_noise_2.counter_m_e =  counter.counter_noise_2.counter_m_e+1;
        else
            verita.verita_noise_2.verita_m_e(k).gt=0;
        end
     end
 end

 %verità per features simmetria e media parti noise2
  counter.counter_noise_2.counter_s_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise2.distanze_s_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise2.distanze_s_mp(:,k));
        verita.verita_noise_2.verita_s_mp(k).minimi = minimo;
        verita.verita_noise_2.verita_s_mp(k).etichetta_calcolata = index;
        verita.verita_noise_2.verita_s_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_2.verita_s_mp(k).etichetta_calcolata == verita.verita_noise_2.verita_s_mp(k).etichetta_vera
            verita.verita_noise_2.verita_s_mp(k).gt=1;
            counter.counter_noise_2.counter_s_mp = counter.counter_noise_2.counter_s_mp+1;
        else
            verita.verita_noise_2.verita_s_mp(k).gt=0;
        end
     end
 end

  %verità per features media e entropia e media parti noise2
 counter.counter_noise_2.counter_m_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise2.distanze_m_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise2.distanze_m_e_mp(:,k));
        verita.verita_noise_2.verita_m_e_mp(k).minimi = minimo;
        verita.verita_noise_2.verita_m_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_2.verita_m_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_2.verita_m_e_mp(k).etichetta_calcolata == verita.verita_noise_2.verita_m_e_mp(k).etichetta_vera
            verita.verita_noise_2.verita_m_e_mp(k).gt=1;
             counter.counter_noise_2.counter_m_e_mp =  counter.counter_noise_2.counter_m_e_mp+1;
        else
            verita.verita_noise_2.verita_m_e_mp(k).gt=0;
        end
     end
 end
 
 
 %verità per features entropia e media parti noise2
 counter.counter_noise_2.counter_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise2.distanze_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise2.distanze_e_mp(:,k));
        verita.verita_noise_2.verita_e_mp(k).minimi = minimo;
        verita.verita_noise_2.verita_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_2.verita_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_2.verita_e_mp(k).etichetta_calcolata == verita.verita_noise_2.verita_e_mp(k).etichetta_vera
            verita.verita_noise_2.verita_e_mp(k).gt=1;
             counter.counter_noise_2.counter_e_mp =  counter.counter_noise_2.counter_e_mp+1;
        else
            verita.verita_noise_2.verita_e_mp(k).gt=0;
        end
     end
 end
 
  %verità per features media e media parti noise2
 counter.counter_noise_2.counter_m_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise2.distanze_m_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise2.distanze_m_mp(:,k));
        verita.verita_noise_2.verita_m_mp(k).minimi = minimo;
        verita.verita_noise_2.verita_m_mp(k).etichetta_calcolata = index;
        verita.verita_noise_2.verita_m_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_2.verita_m_mp(k).etichetta_calcolata == verita.verita_noise_2.verita_m_mp(k).etichetta_vera
            verita.verita_noise_2.verita_m_mp(k).gt=1;
             counter.counter_noise_2.counter_m_mp =  counter.counter_noise_2.counter_m_mp+1;
        else
            verita.verita_noise_2.verita_m_mp(k).gt=0;
        end
     end
 end
 
 
 
 %% Noise 3
 %verità per features media e entropia noise3
 counter.counter_noise_3.counter_m_e=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise3.distanze_m_e(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise3.distanze_m_e(:,k));
        verita.verita_noise_3.verita_m_e(k).minimi = minimo;
        verita.verita_noise_3.verita_m_e(k).etichetta_calcolata = index;
        verita.verita_noise_3.verita_m_e(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_3.verita_m_e(k).etichetta_calcolata == verita.verita_noise_3.verita_m_e(k).etichetta_vera
            verita.verita_noise_3.verita_m_e(k).gt=1;
             counter.counter_noise_3.counter_m_e =  counter.counter_noise_3.counter_m_e+1;
        else
            verita.verita_noise_3.verita_m_e(k).gt=0;
        end
     end
 end

 %verità per features simmetria e media parti noise3
  counter.counter_noise_3.counter_s_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise3.distanze_s_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise3.distanze_s_mp(:,k));
        verita.verita_noise_3.verita_s_mp(k).minimi = minimo;
        verita.verita_noise_3.verita_s_mp(k).etichetta_calcolata = index;
        verita.verita_noise_3.verita_s_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_3.verita_s_mp(k).etichetta_calcolata == verita.verita_noise_3.verita_s_mp(k).etichetta_vera
            verita.verita_noise_3.verita_s_mp(k).gt=1;
            counter.counter_noise_3.counter_s_mp = counter.counter_noise_3.counter_s_mp+1;
        else
            verita.verita_noise_3.verita_s_mp(k).gt=0;
        end
     end
 end

  %verità per features media e entropia e media parti noise3
 counter.counter_noise_3.counter_m_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise3.distanze_m_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise3.distanze_m_e_mp(:,k));
        verita.verita_noise_3.verita_m_e_mp(k).minimi = minimo;
        verita.verita_noise_3.verita_m_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_3.verita_m_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_3.verita_m_e_mp(k).etichetta_calcolata == verita.verita_noise_3.verita_m_e_mp(k).etichetta_vera
            verita.verita_noise_3.verita_m_e_mp(k).gt=1;
             counter.counter_noise_3.counter_m_e_mp =  counter.counter_noise_3.counter_m_e_mp+1;
        else
            verita.verita_noise_3.verita_m_e_mp(k).gt=0;
        end
     end
 end
 
 
 %verità per features entropia e media parti noise3
 counter.counter_noise_3.counter_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise3.distanze_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise3.distanze_e_mp(:,k));
        verita.verita_noise_3.verita_e_mp(k).minimi = minimo;
        verita.verita_noise_3.verita_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_3.verita_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_3.verita_e_mp(k).etichetta_calcolata == verita.verita_noise_3.verita_e_mp(k).etichetta_vera
            verita.verita_noise_3.verita_e_mp(k).gt=1;
             counter.counter_noise_3.counter_e_mp =  counter.counter_noise_3.counter_e_mp+1;
        else
            verita.verita_noise_3.verita_e_mp(k).gt=0;
        end
     end
 end
 
  %verità per features media e media parti noise3
 counter.counter_noise_3.counter_m_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise3.distanze_m_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise3.distanze_m_mp(:,k));
        verita.verita_noise_3.verita_m_mp(k).minimi = minimo;
        verita.verita_noise_3.verita_m_mp(k).etichetta_calcolata = index;
        verita.verita_noise_3.verita_m_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_3.verita_m_mp(k).etichetta_calcolata == verita.verita_noise_3.verita_m_mp(k).etichetta_vera
            verita.verita_noise_3.verita_m_mp(k).gt=1;
             counter.counter_noise_3.counter_m_mp =  counter.counter_noise_3.counter_m_mp+1;
        else
            verita.verita_noise_3.verita_m_mp(k).gt=0;
        end
     end
 end
 
 
 %% Noise 4
  %verità per features media e entropia noise1
 counter.counter_noise_4.counter_m_e=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise1.distanze_m_e(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise4.distanze_m_e(:,k));
        verita.verita_noise_4.verita_m_e(k).minimi = minimo;
        verita.verita_noise_4.verita_m_e(k).etichetta_calcolata = index;
        verita.verita_noise_4.verita_m_e(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_4.verita_m_e(k).etichetta_calcolata == verita.verita_noise_4.verita_m_e(k).etichetta_vera
            verita.verita_noise_4.verita_m_e(k).gt=1;
             counter.counter_noise_4.counter_m_e =  counter.counter_noise_4.counter_m_e+1;
        else
            verita.verita_noise_4.verita_m_e(k).gt=0;
        end
     end
 end

 %verità per features simmetria e media parti noise4
  counter.counter_noise_4.counter_s_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise4.distanze_s_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise4.distanze_s_mp(:,k));
        verita.verita_noise_4.verita_s_mp(k).minimi = minimo;
        verita.verita_noise_4.verita_s_mp(k).etichetta_calcolata = index;
        verita.verita_noise_4.verita_s_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_4.verita_s_mp(k).etichetta_calcolata == verita.verita_noise_4.verita_s_mp(k).etichetta_vera
            verita.verita_noise_4.verita_s_mp(k).gt=1;
            counter.counter_noise_4.counter_s_mp = counter.counter_noise_4.counter_s_mp+1;
        else
            verita.verita_noise_4.verita_s_mp(k).gt=0;
        end
     end
 end

  %verità per features media e entropia e media parti noise4
 counter.counter_noise_4.counter_m_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise4.distanze_m_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise4.distanze_m_e_mp(:,k));
        verita.verita_noise_4.verita_m_e_mp(k).minimi = minimo;
        verita.verita_noise_4.verita_m_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_4.verita_m_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_4.verita_m_e_mp(k).etichetta_calcolata == verita.verita_noise_4.verita_m_e_mp(k).etichetta_vera
            verita.verita_noise_4.verita_m_e_mp(k).gt=1;
             counter.counter_noise_4.counter_m_e_mp =  counter.counter_noise_4.counter_m_e_mp+1;
        else
            verita.verita_noise_4.verita_m_e_mp(k).gt=0;
        end
     end
 end
 
 
 %verità per features entropia e media parti noise4
 counter.counter_noise_4.counter_e_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise4.distanze_e_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise4.distanze_e_mp(:,k));
        verita.verita_noise_4.verita_e_mp(k).minimi = minimo;
        verita.verita_noise_4.verita_e_mp(k).etichetta_calcolata = index;
        verita.verita_noise_4.verita_e_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_4.verita_e_mp(k).etichetta_calcolata == verita.verita_noise_4.verita_e_mp(k).etichetta_vera
            verita.verita_noise_4.verita_e_mp(k).gt=1;
             counter.counter_noise_4.counter_e_mp =  counter.counter_noise_4.counter_e_mp+1;
        else
            verita.verita_noise_4.verita_e_mp(k).gt=0;
        end
     end
 end
 
  %verità per features media e media parti noise4
 counter.counter_noise_4.counter_m_mp=0;
 for k= 1:size(thumbnail.thumbnail_16x16_senza_rif,2)
     if sum(distanze.distanze_noise4.distanze_m_mp(:,k)) ~= 0
        [minimo,index] = min(distanze.distanze_noise4.distanze_m_mp(:,k));
        verita.verita_noise_4.verita_m_mp(k).minimi = minimo;
        verita.verita_noise_4.verita_m_mp(k).etichetta_calcolata = index;
        verita.verita_noise_4.verita_m_mp(k).etichetta_vera = thumbnail.thumbnail_16x16_senza_rif(k).etichetta;
        if verita.verita_noise_4.verita_m_mp(k).etichetta_calcolata == verita.verita_noise_4.verita_m_mp(k).etichetta_vera
            verita.verita_noise_4.verita_m_mp(k).gt=1;
             counter.counter_noise_4.counter_m_mp =  counter.counter_noise_4.counter_m_mp+1;
        else
            verita.verita_noise_4.verita_m_mp(k).gt=0;
        end
     end
 end
 
 %% Accuratezza
 %% Accuraezza normale
 % media e entropia
 accuratezza.accuratezza_normal.accuratezza_m_e = counter.counter_normal.counter_m_e / 153;
 % simmetria e media parti
 accuratezza.accuratezza_normal.accuratezza_s_mp = counter.counter_normal.counter_s_mp / 153;
 % media e  entropia e media parti
 accuratezza.accuratezza_normal.accuratezza_m_e_mp = counter.counter_normal.counter_m_e_mp / 153;
 % entropia e media parti
 accuratezza.accuratezza_normal.accuratezza_e_mp = counter.counter_normal.counter_e_mp / 153;
 % media e media parti
 accuratezza.accuratezza_normal.accuratezza_m_mp = counter.counter_normal.counter_m_mp / 153;
 
 
 %% Accuratezza noise 1
 % media e entropia
 accuratezza.accuratezza_noise_1.accuratezza_m_e = counter.counter_noise_1.counter_m_e / 153;
 % simmetria e media parti
 accuratezza.accuratezza_noise_1.accuratezza_s_mp = counter.counter_noise_1.counter_s_mp / 153;
 % media e  entropia e media parti
 accuratezza.accuratezza_noise_1.accuratezza_m_e_mp = counter.counter_noise_1.counter_m_e_mp / 153;
 % entropia e media parti
 accuratezza.accuratezza_noise_1.accuratezza_e_mp = counter.counter_noise_1.counter_e_mp / 153;
 % media e media parti
 accuratezza.accuratezza_noise_1.accuratezza_m_mp = counter.counter_noise_1.counter_m_mp / 153;
 
 %% Accuratezza noise 2
 % media e entropia
 accuratezza.accuratezza_noise_2.accuratezza_m_e = counter.counter_noise_2.counter_m_e / 153;
 % simmetria e media parti
 accuratezza.accuratezza_noise_2.accuratezza_s_mp = counter.counter_noise_2.counter_s_mp / 153;
 % media e  entropia e media parti
 accuratezza.accuratezza_noise_2.accuratezza_m_e_mp = counter.counter_noise_2.counter_m_e_mp / 153;
 % entropia e media parti
 accuratezza.accuratezza_noise_2.accuratezza_e_mp = counter.counter_noise_2.counter_e_mp / 153;
 % media e media parti
 accuratezza.accuratezza_noise_2.accuratezza_m_mp = counter.counter_noise_2.counter_m_mp / 153;
 
 %% Accuratezza noise 3
 % media e entropia
 accuratezza.accuratezza_noise_3.accuratezza_m_e = counter.counter_noise_3.counter_m_e / 153;
 % simmetria e media parti
 accuratezza.accuratezza_noise_3.accuratezza_s_mp = counter.counter_noise_3.counter_s_mp / 153;
 % media e  entropia e media parti
 accuratezza.accuratezza_noise_3.accuratezza_m_e_mp = counter.counter_noise_3.counter_m_e_mp / 153;
 % entropia e media parti
 accuratezza.accuratezza_noise_3.accuratezza_e_mp = counter.counter_noise_3.counter_e_mp / 153;
 % media e media parti
 accuratezza.accuratezza_noise_3.accuratezza_m_mp = counter.counter_noise_3.counter_m_mp / 153;
 
  %% Accuratezza noise 4
 % media e entropia
 accuratezza.accuratezza_noise_4.accuratezza_m_e = counter.counter_noise_4.counter_m_e / 153;
 % simmetria e media parti
 accuratezza.accuratezza_noise_4.accuratezza_s_mp = counter.counter_noise_4.counter_s_mp / 153;
 % media e  entropia e media parti
 accuratezza.accuratezza_noise_4.accuratezza_m_e_mp = counter.counter_noise_4.counter_m_e_mp / 153;
 % entropia e media parti
 accuratezza.accuratezza_noise_4.accuratezza_e_mp = counter.counter_noise_4.counter_e_mp / 153;
 % media e media parti
 accuratezza.accuratezza_noise_4.accuratezza_m_mp = counter.counter_noise_4.counter_m_mp / 153;
 
