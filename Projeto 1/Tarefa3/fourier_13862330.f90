      program TF
      implicit real*8 (a-h, o-z)
      complex*16:: X
      
      open(unit = 10, file = "data_13862330.in")
      open(unit = 20, file = "real_13862330.out") 
      open(unit = 30, file = "img_13862330.out")
      open(unit = 40, file = "value_serie_13862330.out")
      
      read(10,*)t, a1, a2, w1, w2

      n = 200

      PI = acos(-1.0d0)
      
      do i = 0,n-1
          X = (0.0d0, 0.0d0)

          do j = 0,n-1
              y = cmplx(a1*cos(w1*PI*j*t) + a2*sin(w2*PI*j*t), 0.0d0)

              X = X + y * exp(-2*PI*(0.0d0, 1.0d0)*dble(i)*dble(j) / dble(n))
          end do

          write(20,*)t*i, real(X)
          write(30,*)t*i, aimag(X)
          write(40,*)t*i, a1*cos(w1*PI*i*t) + a2*sin(w2*PI*i*t)
      end do

      close(10)
      close(20)

      end program