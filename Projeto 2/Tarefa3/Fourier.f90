      program TF
      implicit real*8 (a-h, o-z)
      real*8:: y(1000)
      complex*16:: X
      
      open(unit = 10, file = "saida_2_13862330.out")
      open(unit = 20, file = "real_13862330.out") 
      open(unit = 30, file = "img_13862330.out")

      n = 1000

      PI = acos(-1.0d0)

      t = 0.04d0

      do i = 1, 1000
          read(10,*)var, y(i)
      end do

      do i = 0,n-1
          X = (0.0d0, 0.0d0)

          do j = 0,n-1
              X = X + y(j+1) * exp(-2*PI*(0.0d0, 1.0d0)*dble(i)*dble(j) / dble(n))
          end do

          write(20,*)t*i, real(X)
          write(30,*)t*i, aimag(X)
      end do

      close(10)
      close(20)

      end program