program tarefa1
    implicit real*8 (a-h, o-z)
    real*8:: x(3), y(3)

    open(unit = 10, file="data_13862330.out")

    L = 1.0d0
    c = 300.0d0
    dx = 0.001d0
    dt = 0.001d0
    s = L/30.0d0
    r = c*dt/dx
    max = int(L/dx)
    PrevY = 0.0d0

    do i = 0, max
        x(1) = f(dx*(i-1.0d0), L)
        x(2) = f(dx*i, L)
        x(3) = f(dx*(i+1.0d0), L)

        NextY = 2.0d0*(1-r**2.0d0)*x(2) + r**2.0d0*(x(3)+x(1)) - PrevY

        PrevY = CurrY
        CurrY = NextY

        write(10,*)NextY
    end do

    close(10)
end program

function f(x, L) result(y)
    implicit real*8 (a-h, o-z)
    x_0 = L/3.0d0
    s = L/30.0d0

    y = exp(-(x - x_0)**2.0d0/(s**2.0d0))

end function