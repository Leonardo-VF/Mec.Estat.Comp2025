      program TF
      implicit real*8 (a-h, o-z)
      complex*16:: X
      real*8:: values(4)
      
      open(unit = 10, file = "data_13862330.in")
      open(unit = 20, file = "time_13862330.out")
      
      read(10,*)t, a1, a2, w1, w2

      values = [50,100,200,400]
      
      do n = 50,1000
      
      PI = acos(-1.0d0)
      
      do i = 0,n-1
          X = (0.0d0, 0.0d0)

          do j = 0,n-1
              y = cmplx(a1*cos(w1*PI*j*t) + a2*sin(w2*PI*j*t), 0.0d0)

              X = X + y * exp(-2*PI*(0.0d0, 1.0d0)*dble(i)*dble(j) / dble(n))
          end do
      end do

      call cpu_time(finish)

      write(20,*)n, finish
      end do 
      
      close(10)
      close(20)

      end program