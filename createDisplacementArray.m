% Creates the probes for the experimenet 
% Inputs are : object size, probe size, number of probes to take along x
% axis and dimensions of the object image


function [totProbe, shiftData] = createDisplacementArray( probe_radius, overlap, layers)

    
    if layers == 1
        totProbe = 9;
    elseif layers == 2
        totProbe = 25;
    elseif layers == 3
        totProbe = 49;
    else
       error('Invalid layers input into shiftData')
    end

    % Array that tells for how much off center the probe have been shifted
    shiftData = zeros( 2, totProbe);

    % Step size between each probe
    step = (1-overlap) * 2 * probe_radius;
    
    %Moves the probe object and records where the data is to be taken
    count = 1;
    %% Single Domain
 %{  
    for i = -layers : layers
        for j = -layers : layers
        
            % calculate the shiftData
            shiftData(:,count) = [i * step, j * step];
            
            count = count + 1;
        end
    end
   
    holder = zeros( 2, totProbe);
    
    count = 1;
    
    %This is for making a nice spiral
    for i = -layers : layers
        for j = -layers : layers
        
            % calculate the shiftData
            %holder(:,count) = [i * step + 0.0001*(j+i), j * step + 0.0001*(j+i)];
            %holder(:,count) = [i * step + 0.0001*(j+i), j * step + 0.0001*(j+i)];
            if j < 0
                holder(:,count) = [abs(i + 0.001) * step, abs(j + 0.001) * step];
            else 
                holder(:,count) = [abs(i) * step , abs(j) * step ];
            end
            
            count = count + 1;
        end
    end

    %holder = shiftData;
    %holder(holder(1,:) < 0) = holder(holder(1,:) < 0) + 0.1;
    
        %abshi = shiftData(1,:) - shiftData(2,:); %best 
 
    %abshi = shiftData(1,:).^2 + shiftData(2,:).^2;

    abshi = holder(1,:).^2 + holder(2,:).^2;
    %abshi = abs(shiftData(1,:)) + abs(shiftData(2,:));
    
    %abshi = abs(shiftData(1,:));
    
    %abshi = shiftData(1,:) + shiftData(2,:);
    
     %abshi = -abshi;   
        
    [throwaway, ordering] = sort(abshi);
    
    shiftData = shiftData(:,ordering);
  %}  
 %% 4 Domains
    
    
quad1 = zeros( 2, layers);
quad2 = zeros( 2, layers);
quad3 = zeros( 2, layers);
quad4 = zeros( 2, layers);

count = 1;

     for i = -layers : -1
        for j = -layers : 0
        
                        % calculate the shiftData
            quad3(:,count) = [i * step, j * step];
            
            count = count + 1;
            
            
        end
     end  
     
     count = 1;

     for i = 0 : layers
        for j = -layers : -1
        
                        % calculate the shiftData
            quad4(:,count) = [i * step, j * step];
            
            count = count + 1;
            
            
        end
     end
     
     count = 1;

     for i = 1 : layers
        for j = 0 : layers
        
                        % calculate the shiftData
            quad1(:,count) = [i * step, j * step];
            
            count = count + 1;
            
            
        end
     end  
    %quad3(:,count) = [i * step, j * step];
    %quad3(:,count+1) = [i * step, j * step];
     count = 1;
     

     for i = -layers : 0
        for j = 1 : layers
        
                        % calculate the shiftData
            quad2(:,count) = [i * step, j * step];
            
            count = count + 1;
            
            
        end
     end  
        
%when doing 2000 iterations, check which one works better
 if 1
     abshi1 = quad1(1,:).^2 + quad1(2,:).^2;
     abshi2 = quad2(1,:).^2 + quad2(2,:).^2;
     %abshi2 = -abshi2;
     abshi3 = quad3(1,:).^2 + quad3(2,:).^2;
     abshi4 = quad4(1,:).^2 + quad4(2,:).^2;
     %abshi4 = - abshi4;
     
 else     
     abshi1 = quad1(1,:)-quad1(2,:);
     abshi2 = -quad2(1,:)+quad2(2,:);
     abshi3 = quad3(1,:)-quad3(2,:);
     abshi4 = -quad4(1,:)+quad4(2,:);
 end
     [throwaway, ordering1] = sort(abshi1);
     [throwaway, ordering2] = sort(abshi2);
     [throwaway, ordering3] = sort(abshi3);
     [throwaway, ordering4] = sort(abshi4);
     
     quad1 = quad1(:,ordering1);
     quad2 = quad2(:,ordering2);
     quad3 = quad3(:,ordering3);
     quad4 = quad4(:,ordering4);
    
     %shiftData = horzcat(quad1,quad2);
     
     
     shiftData = horzcat(quad1,quad3,quad2,quad4,[0;0],[0;0]);
     
  
 
 %% Add Padding and finish up
 
    shiftData = horzcat(shiftData);
    
    [throwaway,totProbe] = size(shiftData);
    
end