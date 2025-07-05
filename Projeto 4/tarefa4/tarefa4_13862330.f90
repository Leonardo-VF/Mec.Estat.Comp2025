program QuebraDeSimetria
    implicit none
    integer, parameter :: L_values(7) = [4, 5, 6, 7, 8, 9, 10]
    integer, parameter :: THERMALIZATION_MCS = 2000
    integer, parameter :: MEASUREMENT_MCS = 500000
    real*8, parameter  :: BETA = 0.5d0           
    integer :: iL, L
    real*8  :: avg_flip_time

    call random_seed()

    open(unit=10, file='resultados_d1.out', status='replace')

    do iL = 1, size(L_values)
        L = L_values(iL)
        write(*,'(A,I2,A)') '--- Iniciando simulação para L = ', L, ' ---'

        avg_flip_time = calculate_avg_flip_time(L)

        if (avg_flip_time > 0) then
            write(10, '(I4, F20.4)') L, avg_flip_time
        end if
    end do

    close(10)

contains

    function calculate_avg_flip_time(L) result(avg_time)
        integer, intent(in) :: L
        real*8 :: avg_time

        integer, allocatable :: mesh(:,:)
        integer :: mcs, i_flip, x, y, ip, im, jp, jm, flip_count, last_flip_mcs
        real*8  :: rand1, dE, current_m, last_sign, current_sign, total_interval_time

        allocate(mesh(L,L))
        call init_mesh_random(mesh, L)

        do mcs = 1, THERMALIZATION_MCS
            do i_flip = 1, L*L
                call random_number(rand1); x = int(rand1 * L) + 1
                call random_number(rand1); y = int(rand1 * L) + 1
                ip = mod(x,L)+1; im = mod(x-2+L,L)+1; jp = mod(y,L)+1; jm = mod(y-2+L,L)+1
                dE = 2.0d0 * real(mesh(x,y)) * real(mesh(im,y)+mesh(ip,y)+mesh(x,jm)+mesh(x,jp))
                call random_number(rand1)
                if (dE <= 0.0d0 .or. rand1 < exp(-BETA * dE)) then; mesh(x,y)=-mesh(x,y); end if
            end do
        end do

        flip_count = 0
        total_interval_time = 0.0d0
        last_flip_mcs = 0
        current_m = sum(mesh)
        last_sign = sign(1.0d0, current_m)
        if (last_sign == 0) last_sign = 1.0d0

        do mcs = 1, MEASUREMENT_MCS
            do i_flip = 1, L*L
                call random_number(rand1); x = int(rand1 * L) + 1; call random_number(rand1); y = int(rand1 * L) + 1
                ip=mod(x,L)+1; im=mod(x-2+L,L)+1; jp=mod(y,L)+1; jm=mod(y-2+L,L)+1
                dE = 2.0d0*real(mesh(x,y))*real(mesh(im,y)+mesh(ip,y)+mesh(x,jm)+mesh(x,jp))
                call random_number(rand1)
                if(dE<=0.0d0 .or. rand1<exp(-BETA*dE)) then; mesh(x,y)=-mesh(x,y); end if
            end do

            current_m = sum(mesh)
            current_sign = sign(1.0d0, current_m)

            if (current_sign /= last_sign .and. current_sign /= 0) then
                flip_count = flip_count + 1
                total_interval_time = total_interval_time + (mcs - last_flip_mcs)
                last_flip_mcs = mcs
                last_sign = current_sign
            end if
        end do

        if (flip_count > 0) then
            avg_time = total_interval_time / real(flip_count)
        else
            avg_time = -1.0d0
        end if

        deallocate(mesh)
    end function calculate_avg_flip_time

    subroutine init_mesh_random(mesh, L)
        integer, intent(out) :: mesh(L,L); integer, intent(in) :: L
        integer :: i, j; real*8 :: r
        do i=1,L; do j=1,L; call random_number(r)
            if(r<0.5d0) then; mesh(i,j)=-1; else; mesh(i,j)=1; end if
        end do; end do
    end subroutine init_mesh_random

end program QuebraDeSimetria
