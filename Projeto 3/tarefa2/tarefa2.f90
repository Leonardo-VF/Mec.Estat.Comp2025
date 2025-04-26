program DLA
    implicit none
    integer, parameter :: N = 150
    integer, parameter :: num_particles = 1000
    integer, parameter :: pi = acos(-1.0d0)
    integer:: mesh(N,N), particles(2, num_particles), val(2)
    integer:: i, j, cord, val_pos, iterations
    real*8:: r, k, max_radius, theta
    
    open(unit=10, file="saida_1_13862330.out")

    mesh = 0
    val = [-1, 1]

    particles(1, 1) = N / 2
    particles(2, 1) = N / 2

    max_radius = 0.0d0

    mesh(particles(1, 1), particles(2, 1)) = 1

    do i = 2, num_particles
        call ShowMesh(mesh, N)

        max_radius = max(max_radius, ((particles(1, i-1)-N/2.0d0)**2.0d0 + (particles(2, i-1)-N/2.0d0)**2.0d0)**(1.0d0/2.0d0))

        call random_number(r)
        call random_number(k)

        theta = 2.0d0 * pi * r

        particles(1, i) = int(max_radius * cos(theta)) + 1
        particles(2, i) = int(max_radius * sin(theta)) + 1

        write(*,*)max_radius, particles(1, i), particles(2, i)

        do while (.not.neighbor(particles(1, i), particles(2, i), mesh))
            call random_number(r)
            call random_number(k)

            cord = int(2 * r) + 1
            val_pos = int(2 * k) + 1

            particles(cord, i) = particles(cord, i) + val(val_pos)

            if (particles(1, i)**2.0d0 + particles(2, i)**2.0d0 .GT. 1.5d0*max_radius**2.0d0) then
                particles(1, i) = int(max_radius * cos(theta)) + 1
                particles(2, i) = int(max_radius * sin(theta)) + 1
            end if
        end do

        mesh(particles(1, i), particles(2, i)) = 1
    end do

contains 

subroutine ShowMesh(mesh, N)
    implicit none
    integer:: i, j, N
    integer:: mesh(N,N)

    do i = 1, N
        do j = 1, N
            write(10,'(I4)', advance='no') mesh(i,j)
        end do
        write(10,*)
    end do
end subroutine ShowMesh

function neighbor(x, y, mesh) result(has_neighbor)
    implicit none
    integer:: x, y
    integer:: mesh(N,N)
    integer:: i, j
    logical:: has_neighbor

    has_neighbor = .false.

    do i = -1, 1
        do j = -1, 1
            if (mesh(x+i,y+j).EQ.1) then
                has_neighbor = .true.
                return
            end if
        end do
    end do
end function neighbor
end program DLA
