%%Run algo for all pictures


for i = 14:72
    I_dest = ['color',num2str(i),'.png'];
    I_color = imread(I_dest);
    I_gray = rgb2gray(I_color);
    I_mask= edge(I_gray,'sobel');

    
    shape = size(I_mask);
    centroids= (zeros(shape(1),2));
    for i = 1:shape(1)
        for j = 1:shape(2)
            if I_mask(i,j)==1
                centroids(i,1)= centroids(i,1)+j;
                centroids(i,2) = centroids(i,2) + 1;
            end
        end
    end
    x= [];
    y = [];
    for i =1:shape(1)
        if centroids(i,2)~=0
            x= [x,int16(centroids(i,1)/centroids(i,2))];
            centroids(i,1) = int16(centroids(i,1)/centroids(i,2));
            y = [y,(480-i)];
        end
    end
    
    %imshow(I_mask);
   % hold on
   
   %% low power approximation
    DOP = 10;  %How many points we will check
    lines = ceil((0:(1/DOP):1)*shape(1));  %Select the points we will check, for now random (can be changed)
    lines= lines(1,2:end);
    coords_found = [];
    %% find coords
    for i=1:size(lines,2)
        line = lines(i);
        if centroids(line,2)~=0
            x_local = int16(centroids(line,1));
            y_local = (480-line);
            coords_found = [coords_found;
                           x_local,y_local];
        end
    end
    %% check for gradients
    for i = 2:size(coords_found,1)
        if i>size(coords_found,1)
            break
        end
        %gradient = abs((coords_found(i,1)-coords_found((i-1),1))/(coords_found(i,2)-coords_found((i-1),2)));
        gradient = abs((coords_found(i,1)-coords_found((i-1),1)))
        if gradient > 100
            coords_found = [coords_found(1:(i-1),:);
                            coords_found((i+1):end,:)];
                        
        end
    end
    %number_centroid = size(x);
    %random = int16(ceil(rand(DOP,1)*number_centroid(2)));
    %random = int16(ceil([0.1,0.7,0.8]*number_centroid(2)));

   
    %% Printing results
   subplot(2,2,1),plot(x,y,'-o'); %plot all sobel outcomes
   axis([0,600,0,600]);       
   hold on
   if size(coords_found)>0
        subplot(2,2,1),scatter(coords_found(:,1),coords_found(:,2),'MarkerEdgeColor','red'); %plot the random points
   end
   hold off
   
   subplot(2,2,2),imshow(I_mask); %show the sobel image
   if size(coords_found)>0
        subplot(2,2,3),scatter(coords_found(:,1),coords_found(:,2),'MarkerEdgeColor','red');
   end
   axis([0,600,0,600]);
   %subplot(2,2,3),scatter(x(random),y(random),'MarkerEdgeColor','red');
   subplot(2,2,4),imshow(I_color);
   hold on 
   subplot(2,2,4),scatter(mean(coords_found(:,1)),mean(coords_found(:,2)),'g');
   %subplot(2,2,4),scatter(320,240);
   hold off
   pause(0.1)

    
end


