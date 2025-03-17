program TIF
implicit real*8 (a-h, o-z)
complex*16:: X(0:199), x_n
dimension t(0:199), f_real(0:199), f_img(0:199)

open(unit = 10, file = "real_13862330.in")
open(unit = 20, file = "img_13862330.in")
open(unit = 30, file = "serie_13862330.out")

PI = acos(-1.0d0)
n = 200

do k = 0, n-1
    read(10,*) t(k), f_real(k)
    read(20,*) t(k), f_img(k)
    X(k) = cmplx(f_real(k), f_img(k))
end do

do j = 0, n-1
    x_n = cmplx(0.0d0, 0.0d0)
    do k = 0, n-1
        x_n = x_n + X(k) * exp(2.0d0 * PI * (0.0d0, 1.0d0) * dble(k) * dble(j) / dble(n))
    end do
    x_n = x_n / dble(n) 
    write(30,*) t(j), real(x_n)
end do

close(10)
close(20)
close(30)

end program