program ACD
    implicit none
    integer, parameter :: N = 200
    integer :: i, t, rule(8), L(N), new_L(N)

    open(unit=10, file='rule_138_13862330.out')

    L = InitPosition(N)
    rule = DecomposeRule(138)

    write(10,*)L

    do t = 1, 100
        new_L(1) = rule(L(N)*2**2 + L(1)*2**1 + L(2)*2**0 + 1)

        do i = 2, N-1
            new_L(i) = rule(L(i-1)*2**2 + L(i)*2**1 + L(i+1)*2**0 + 1)
        end do

        new_L(N) = rule(L(N-1)*2**2 + L(N)*2**1 + L(1)*2**0 + 1)

        L = new_L

        write(10,*)L
    end do

contains

    function InitPosition(N) result(L)
        implicit none
        integer, intent(in) :: N
        integer :: i
        real*8 :: L(N)

        call random_number(L)

        do i = 1, N
            L(i) = int(anint(L(i)))
        end do
    end function InitPosition

    function DecomposeRule(x) result(rule)
        integer, intent(in):: x
        integer:: i, new_x
        integer:: rule(8)

        new_x = x

        do i = 0, 7
            if (new_x - 2**(7-i) .GE. 0.0d0) then
                rule(8-i) = 1
                new_x = new_x - 2**(7-i)
            else
                rule(8-i) = 0
            end if
        end do
    end function DecomposeRule
end program ACD
