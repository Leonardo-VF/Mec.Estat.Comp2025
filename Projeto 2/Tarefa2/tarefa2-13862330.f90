program tarefa2
    implicit real*8 (a-h, o-z)
    integer, parameter :: max = 1000
    real*8 :: x(0:max), y_prev(0:max), y_curr(0:max), y_next(0:max)

    open(unit = 10, file="saida_1_13862330.out")
    open(unit = 20, file="saida_2_13862330.out")

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
        y_curr(max) = 0.0d0

        y_prev = y_curr

        do n = 1, Nt
            do i = 1, max-1
                y_next(i) = 2.0d0 * (1 - r**2) * y_curr(i) + r**2 * (y_curr(i+1) + y_curr(i-1)) - y_prev(i)
            end do

            y_next(0) = 0.0d0
            y_next(max) = 0.0d0

            y_prev = y_curr
            y_curr = y_next

            if (n.EQ.n_max) then
                do i = 0, max
                    if (int(x(i)*1000).EQ.250) then
                       write(20, *) n, y_curr(i)
                    end if
                    write(10, *) x(i), y_curr(i)
                end do
            end if
        end do
    end do

    close(10)
end program

function f(x, L) result(y)
    implicit real*8 (a-h, o-z)

    if (x >= 0.0d0 .and. x <= 0.25d0) then
        y = x
    else if (x > 0.25d0 .and. x <= 1.0d0) then
        y = -1.0d0 / 3.0d0 * x + 1.0d0 / 3.0d0
    end if
end function