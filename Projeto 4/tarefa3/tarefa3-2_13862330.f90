program Spin_C2
    implicit none
    integer, parameter :: L = 100
    real*8, parameter  :: BETA_INICIAL = 0.40d0
    real*8, parameter  :: BETA_FINAL   = 0.50d0
    real*8, parameter  :: db = 0.01d0
    integer, parameter :: Npassos = 1000

    integer :: mesh(L,L)
    integer :: ip, im, jp, jm, x, y, i, passo
    real*8  :: b, rand1, dE, E_total, E_per_spin
    character(len=50) :: nome_arquivo
    integer :: unidade

    call random_seed()

    b = BETA_INICIAL

    do while (b <= BETA_FINAL)
        call init_mesh_misto(mesh)

        write(nome_arquivo, '("evolucao_beta_", F4.2, ".out")') b
        open(newunit=unidade, file=trim(nome_arquivo), status='replace')

        do passo = 1, Npassos
            do i = 1, L*L
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
            write(unidade, '(I6, F15.6)') passo, E_per_spin
        end do

        close(unidade)

        write(*,'(A, F4.2)') "Finalizado beta = ", b
        b = b + db
    end do

contains

    subroutine init_mesh_misto(mesh)
        integer, intent(out) :: mesh(L,L)
        integer :: i, j
        real*8 :: r

        do i = 1, int(L/2)
            do j = 1, L
                mesh(i,j) = 1
            end do
        end do

        do i = int(L/2)+1, L
            do j = 1, L
                call random_number(r)
                if (r < 0.5d0) then
                    mesh(i,j) = -1
                else
                    mesh(i,j) = 1
                end if
            end do
        end do
    end subroutine init_mesh_misto

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
end program Spin_C2
