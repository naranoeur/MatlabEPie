% Creates star shaped aperture to serve as the object in the phase 
% retrieval algorithms.

%Information needed: N, obj_radius, xMax


function aperture = createObjectShape( N, obj_radius, xMax, shape)
    
    if obj_radius > xMax
        error('Invalid Input: Obj size larger than display')
    end

    % Spacing of real space grid
    dx = xMax/N; 
    
    % Create real-space grid
    [x,y] = meshgrid(-xMax/2:dx:xMax/2-dx);
    
    % Resizing image to fit into object size
    obj = meshgrid(-obj_radius/2:dx:obj_radius/2);
    obj = imresize(shape, [size(obj,1) size(obj,2)]);
    
    aperture = zeros(N);
    
    length_obj = size(obj,1);
    start = N/2 - floor( length_obj / 2);
    finish = start + length_obj - 1;
   
    
    aperture(start:finish, start:finish) = obj;

    

%end