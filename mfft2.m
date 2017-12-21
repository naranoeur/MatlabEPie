function F = mfft2(f)

    F = fftshift( fft2( ifftshift( f ) ) );

end