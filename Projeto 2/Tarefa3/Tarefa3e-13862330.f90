program tarefa1
    implicit real*8 (a-h, o-z)
    integer, parameter :: max = 1000
    real*8 :: x(0:max), y_prev(0:max), y_curr(0:max), y_next(0:max)

    open(unit = 10, file="saida_3e_13862330.out")

    L = 1.0d0
    c = 300.0d0
    dx = L / real(max)
    dt = dx / c       
    r = c * dt / dx   
    Nt = 1000         
    
    do n_max = 1,1000
        do i = 0, max
            x(i) = i * dx
        end do

        do i = 0, max
            y_curr(i) = f(x(i), L)
        end do

        y_curr(0) = 0.0d0
        y_next(max) = y_prev(max-1)

        y_prev = y_curr

        do n = 1, Nt
            do i = 1, max-1
                y_next(i) = 2.0d0 * (1 - r**2) * y_curr(i) + r**2 * (y_curr(i+1) + y_curr(i-1)) - y_prev(i)
            end do

            y_next(0) = 0.0d0
            y_next(max) = y_prev(max-1)

            y_prev = y_curr
            y_curr = y_next

            if (n == n_max) then
                do i = 0, max
                    write(10, *) x(i), y_curr(i)
                end do
            end if
        end do
    end do

    close(10)
end program

function f(x, L) result(y)
    implicit real*8 (a-h, o-z)
    x_0 = L / 3.0d0
    s = L / 30.0d0
    y = exp(-(x - x_0)**2.0d0 / (s**2.0d0))
end function f