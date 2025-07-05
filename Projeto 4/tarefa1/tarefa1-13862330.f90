program Spin
    implicit none
    integer, parameter :: L = 60
    integer, parameter :: N_steps = 2 * L * L * 100 
    integer :: mesh(L,L)
    integer :: ip, im, jp, jm, x, y, i
    real*8  :: b, M_final, rand1, dE

    call random_seed()

    call init_mesh(mesh)

    b = 0.1d0

    do i = 1, N_steps
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
            mesh(x,y) = -mesh(x,y)  !
        end if
    end do

    write(*,*) 'Simulação concluída.'

    M_final = sum(mesh) / real(L*L)
    write(*,*) 'Magnetização final (M): ', M_final

    call print_mesh(mesh, b)
    write(*,*) 'Configuração final salva no arquivo.'

contains

    subroutine init_mesh(mesh)
        integer, intent(out) :: mesh(L,L)
        integer :: i, j

        do i = 1, L
            do j = 1, L
                mesh(i,j) = 1
            end do
        end do
    end subroutine init_mesh

    subroutine print_mesh(mesh, beta)
        integer, intent(in) :: mesh(L,L)
        real*8, intent(in)  :: beta
        integer :: i, j
        character(len=20) :: filename

        write(filename, '(A,F3.1,A)') 'saida_beta_', beta, '.out'
        open(10, file=trim(filename), status='replace')

        do i = 1, L
            do j = 1, L
                write(10, '(I5)', advance='no') mesh(i,j)
            end do
            write(10,*)
        end do
        close(10)
    end subroutine print_mesh
end program Spin