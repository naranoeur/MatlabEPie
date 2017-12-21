% Creates circular aperture to serve as the object in the phase retrieval
% algorithms.

%Information needed: N, obj_radius, xMax

function aperture = createCircularObject( N, obj_radius, xMax)
    
    % Spacing of real space grid
    dx = xMax/N; 
    
    % Create real-space grid
    [x,y] = meshgrid(-xMax/2:dx:xMax/2-dx);
    
    % Create aperture
    %aperture = exp(-(x.^2 + y.^2)/(2 * obj_radius^2));
    aperture = double( x.^2 + y.^2 < obj_radius^2);

end
