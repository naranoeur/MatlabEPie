function F = mifft2(f)

    F = fftshift( ifft2( ifftshift( f ) ) );

end