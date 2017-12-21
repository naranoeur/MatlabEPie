% ePIE algorithm as depicted in Maidan

function ePIE4

% Close all previously opened plots
close all
clear all
%% Constants

um = 1e-6;

% Number of pixels in the simulation
N = 128;

% Maximum number of iterations that will be performed
maxNumIterations = 20;

% Overlap between probe
overlap = 0.75;
layers = 2;

% Constant in IO algorithm
alpha = 1;
beta = 1;

%% Object

% Object dimension
obj_radius = 100 * um; 
probe_radius = obj_radius;

% Extent of real space grid
xMax = 10*obj_radius;
dx = xMax/N; 
[x,y] = meshgrid(-xMax/2:dx:xMax/2-dx);

%Load shape of the aperture
load shape5.mat
object = createObjectShape( N, 7 * obj_radius, xMax, shape);

load shape5.mat
imobject = createObjectShape( N, 7 * obj_radius, xMax, shape);
object = object.*exp(1i * imobject);

%%  Data

% Probe and positions
probe = createCircularObject( N, probe_radius , xMax);
[totProbe, positionData] = createDisplacementArray( probe_radius, overlap , layers);

% Array to hold experiment data
diffData = zeros( N, N, totProbe);

% Propagate light through probe and object to far field
for i = 1 : totProbe
    probeDisplaced = translate( probe, positionData(:, i), x, y , xMax);
    diffData( :, :, i) = abs( mfft2( probeDisplaced .* object));
end

%% ePIE Algorithm 

% Initial guess of the object
load squareShape.mat
obj_guess = createObjectShape( N, 3 * obj_radius, xMax, shape);

%probe_guess = createCircularObject ( N , 1.2 * probe_radius, xMax); 
probe_guess = probe;

errorMetric = zeros( 1, maxNumIterations); % Will take average of img and obj domain error
normalization = sum(abs( reshape(diffData(:,:,totProbe),[],1)));


for j = 1 : maxNumIterations
    for k = 1 : totProbe
        %if strcmp(get(gcf,'currentCharacter'),'b'), break; end
        %Shift probe
        probe_guess = translate(probe_guess, positionData(:, k),x, y , xMax);
        obj0 = obj_guess .* probe_guess;
        
        % 1. Fourier Transform the guess to calculate G(u)
        obj1 = mfft2( obj0 );
        
        %Compute error at the end of each iteration
        if k == totProbe
            errorMetric(j) = sqrt( mean( (abs(obj1(:)./max(abs(obj1(:)))) - abs(reshape(diffData(:,:,k),[],1) ./ max(abs(reshape(diffData(:,:,k),[],1))))).^2)) ;
        end

        % 2. Fix using F(u) to get G'_k(u) 
        obj1 = diffData(:,:,k) .* exp( 1i * angle(obj1) );
        
        % 3. Fourier Transform back to get 
        obj1 = mifft2( obj1 );
        
        % 4. Find the next guess
        
        holder = conj(obj_guess)/max(abs(obj_guess(:))).^2 .* ( obj1 - obj0 );
        obj_guess = obj_guess + alpha * conj(probe_guess)./ max(abs(probe_guess(:))).^2 .* ( obj1 - obj0 );
        %obj_guess = obj_guess + alpha * conj(probe_guess)./ mean(abs(probe_guess(:))).^2 .* ( obj1 - obj0 );
        
        probe_guess = probe_guess + holder;        
        probe_guess = translate( probe_guess , -positionData(:, k),x, y , xMax);
         
    end
    
    subplot(1,2,1)
    imagesc(flipud(abs(obj_guess))); axis xy image;
    subplot(1,2,2)
    imagesc(abs(probe_guess)); axis xy image;
    title(['Iteration #: ', num2str(j)]);
    drawnow
end
%% Plot results

disp(['Final error metric: ' num2str(errorMetric(maxNumIterations))])
figure()
loglog(errorMetric, '-o');

end

