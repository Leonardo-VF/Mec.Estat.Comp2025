program Spin
implicit none
integer, parameter :: L = 60, N_avg = 100
real*8, parameter :: tol = 1.0d-4, db = 1.0d-2
integer :: mesh(L,L)
integer :: i, j, ip, im, jp, jm, b_steps, mc_steps
real*8 :: rand1, rand2, deltaE, b, M, M_hist(N_avg)
real*8 :: M_mean, M_std
integer :: k

b = 0.1d0
b_steps = 0

do while (b < 3.0d0)

    b_steps = b_steps + 1
    call init_mesh(mesh)
    call magnetization(mesh, M)

    mc_steps = 0
    M_hist = 0.0d0
    k = 0

    do
        mc_steps = mc_steps + 1

        call random_number(rand1)
        call random_number(rand2)
        i = int(rand1 * L) + 1
        j = int(rand2 * L) + 1

        ip = mod(i, L) + 1
        im = mod(i - 2 + L, L) + 1
        jp = mod(j, L) + 1
        jm = mod(j - 2 + L, L) + 1

        deltaE = 2.0d0 * mesh(i,j) * (mesh(im,j) + mesh(ip,j) + mesh(i,jm) + mesh(i,jp))

        call random_number(rand1)
        if (deltaE <= 0.0d0 .or. rand1 < exp(-b * deltaE)) then
            mesh(i,j) = -mesh(i,j)
        end if

        call magnetization(mesh, M)

        ! Salva o valor da magnetização na janela
        if (mc_steps <= N_avg) then
            M_hist(mc_steps) = M
        else
            do k = 1, N_avg-1
                M_hist(k) = M_hist(k+1)
            end do
            M_hist(N_avg) = M
        end if

        ! Verifica se pode parar
        if (mc_steps >= N_avg) then
            call mean_std(M_hist, N_avg, M_mean, M_std)
            if (M_std < tol) exit
        end if
    end do

    call compute_energy(mesh, b, mc_steps)
    b = b + db
end do

call print_mesh(mesh)

contains

subroutine init_mesh(mesh)
    integer :: mesh(L,L), i, j
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
end subroutine init_mesh

subroutine magnetization(mesh, M)
    integer :: mesh(L,L), i, j
    real*8 :: M
    M = 0.0d0
    do i = 1, L
        do j = 1, L
            M = M + real(mesh(i,j))
        end do
    end do
end subroutine magnetization

subroutine mean_std(arr, N, mean, std)
    integer, intent(in) :: N
    real*8, intent(in) :: arr(N)
    real*8, intent(out) :: mean, std
    integer :: i
    real*8 :: sum, sumsq

    sum = 0.0d0
    sumsq = 0.0d0

    do i = 1, N
        sum = sum + arr(i)
        sumsq = sumsq + arr(i)**2
    end do

    mean = sum / N
    std = sqrt(sumsq/N - mean**2)
end subroutine mean_std

subroutine compute_energy(mesh, b, mc_steps)
    integer :: mesh(L,L), i, j, ip, jp, mc_steps
    real*8 :: b, E

    E = 0.0d0
    do i = 1, L
        do j = 1, L
            ip = mod(i, L) + 1
            jp = mod(j, L) + 1
            E = E - 0.5d0 * mesh(i,j) * (mesh(ip,j) + mesh(i,jp))
        end do
    end do

    write(*,'(A,F6.3,A,I6,A,E10.3)') "b = ", b, " MC steps = ", mc_steps, " Energy = ", E
end subroutine compute_energy

subroutine print_mesh(mesh)
    integer :: mesh(L,L), i, j
    open(unit=10, file="saida_mesh.out")
    do i = 1, L
        do j = 1, L
            write(10,'(I3)', advance='no') mesh(i,j)
        end do
        write(10,*)
    end do
    close(10)
end subroutine print_mesh

end program Spin
