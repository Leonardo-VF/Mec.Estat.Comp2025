program DLA
    implicit none
    integer, parameter :: N = 25
    integer, parameter :: num_particles = 10000
    integer:: mesh(N,N), particles(2, num_particles), val(2)
    integer:: i, j, cord, val_pos
    real*8:: r, k
    
    mesh = 0
    val = (-1, 1)

    do i = 1, num_particles
        particles(1, i) = N / 2
        particles(2, i) = N / 2

        mesh(particles(1, i), particles(2, i)) = 1
    end do

    do i = 1, num_particles
        call random_number(r)
        call random_number(k)

        cord = int(2 * r) + 1
        val_pos = int(2 * k) + 1

        particles(cord, i) = particles(cord, i) + val(val_pos)
        write(*,*)particles(cord, i), val(val_pos)

        mesh(particles(1, i), particles(2, i)) = 1

        call ShowMesh(mesh, N)
    end do


contains

subroutine ShowMesh(mesh, N)
    implicit none
    integer:: i, j, N
    integer:: mesh(N,N)

    do i = 1, N
        do j = 1, N
            write(*,'(I4)', advance='no') mesh(i,j)
        end do
        write(*,*)
    end do
end subroutine ShowMesh

end program DLA
