% Will shift array by a certain amount of pixels. 

% Input: the array containing an image, and the number of pixels to shift
% by in the x direction and in the y direction

function probe = translate( probe, shift, x, y, xMax)

%Dimentions of the array holding probe
[N , M] = size(probe);

%Fourier transform and translate in Fourier domain
probe = exp( 2i * pi * (-shift(1) * x + shift(2) * y ) * N / xMax^2) .* mfft2(probe);
probe = mifft2(probe);

end