program Spin
    implicit none
    integer, parameter :: L = 60
    real*8, parameter  :: BETA_FINAL = 1.75d0
    real*8, parameter  :: db = 0.0001d0
    integer :: mesh(L,L)
    integer :: ip, im, jp, jm, x, y, i, iterations
    real*8  :: b, rand1, dE, E_total, E_per_spin

    call random_seed()

    call init_mesh_random(mesh)

    open(unit=20, file='db.out', status='replace')

    b = 0.0d0
    iterations = 0

    do while (b <= BETA_FINAL)
        do i = 1, L * L
            call random_number(rand1)
            x = int(rand1 * L) + 1
            call random_number(rand1)
            y = int(rand1 * L) + 1

            ip = mod(x, L) + 1
            im = mod(x - 2 + L, L) + 1
            jp = mod(y, L) + 1
            jm = mod(y - 2 + L, L) + 1

            dE = 2.0d0 * real(mesh(x,y)) * real(mesh(im,y) + mesh(ip,y) + mesh(x,jm) + mesh(x,jp))

            call random_number(rand1)
            if (dE <= 0.0d0 .or. rand1 < exp(-b * dE)) then
                mesh(x,y) = -mesh(x,y)
            end if
        end do

        E_total = calculate_total_energy(mesh)
        E_per_spin = E_total / real(L*L)
        write(20, '(F15.6, F15.6)') b, E_per_spin

        b = b + db
        iterations = iterations + 1
        if(mod(iterations, 100) == 0) write(*,*) 'Beta atual: ', b
    end do

    close(20)

    call print_mesh_final(mesh)

contains

    subroutine init_mesh_random(mesh)
        integer, intent(out) :: mesh(L,L)
        integer :: i, j
        real*8 :: r

        do i = 1, L
            do j = 1, L
                call random_number(r)
                if (r < 0.5d0) then
                    mesh(i,j) = -1
                else
                    mesh(i,j) = 1
                end if
            end do
        end do
    end subroutine init_mesh_random

    function calculate_total_energy(mesh) result(energy)
        integer, intent(in) :: mesh(L,L)
        real*8 :: energy
        integer :: i, j, ip, jp

        energy = 0.0d0
        do i = 1, L
            do j = 1, L
                ip = mod(i, L) + 1
                jp = mod(j, L) + 1

                energy = energy - real(mesh(i,j)) * (real(mesh(ip, j)) + real(mesh(i, jp)))
            end do
        end do
    end function calculate_total_energy

    subroutine print_mesh_final(mesh)
        integer, intent(in) :: mesh(L,L)
        integer :: i, j

        open(10, file='configuracao_final_db.out', status='replace')
        do i = 1, L
            do j = 1, L
                write(10, '(I5)', advance='no') mesh(i,j)
            end do
            write(10,*)
        end do
        close(10)
    end subroutine print_mesh_final

end program Spin