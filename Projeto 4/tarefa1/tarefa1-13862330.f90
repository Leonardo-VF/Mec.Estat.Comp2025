program Spin
implicit none
integer, parameter:: L = 50
real*8, parameter:: tol = 1.0d-3
integer:: symble(-1:1), mesh(L,L)
integer:: i, j, ip, im, jp, jm
real*8:: k, m, b, E_i, E_f, E, P_i, P_f, M_i, M_f, rand1

symble(-1) = -1
symble(1) = 1

call init_mesh(mesh)
!call print_mesh(mesh)

b = 3.0d0

M_i = 0.0d0
M_f = 1.0d0

do while (abs(M_i - M_f) > tol)
    E_i = 0.0d0
    E_f = 0.0d0
    P_i = 0.0d0
    P_f = 0.0d0
    M_i = 0.0d0
    M_f = 0.0d0

    do i = 1, L
        do j = 1, L
            ip = mod(i, L) + 1
            im = mod(i - 2 + L, L) + 1
            jp = mod(j, L) + 1
            jm = mod(j - 2 + L, L) + 1 

            E_i = E_i - (1.0d0/2.0d0)*(mesh(i,j) * (mesh(im,j) + mesh(ip,j) + mesh(i,jm) + mesh(i,jp)))
        end do
    end do

    M_i = sum(mesh) / real(L*L)

    call random_number(k)
    call random_number(m)

    i = int(k * L) + 1
    j = int(m * L) + 1

    mesh(i,j) = -mesh(i,j)

    do i = 1, L
        do j = 1, L
            ip = mod(i, L) + 1
            im = mod(i - 2 + L, L) + 1
            jp = mod(j, L) + 1
            jm = mod(j - 2 + L, L) + 1 

            E_f = E_f - (1.0d0/2.0d0)*(mesh(i,j) * (mesh(im,j) + mesh(ip,j) + mesh(i,jm) + mesh(i,jp)))
        end do
    end do

    call random_number(rand1)
    if (deltaE > 0.0d0 .or. rand1 > exp(-b * deltaE)) then
        mesh(k,m) = -mesh(k,m)
    end if

    M_f = sum(mesh) / real(L*L)

    write(*,*)abs(M_i - M_f)

    P_i = exp(-b*E_i)/(exp(-b*E_i) + exp(-b*E_f))
    P_f = exp(-b*E_f)/(exp(-b*E_i) + exp(-b*E_f))

    E = E_f
end do

write(*,*)"Energia: ",E
write(*,*)"Peso de Boltzman: ", exp(-b*E)

call print_mesh(mesh)

contains

subroutine init_mesh(mesh)
    integer:: mesh(L,L)
    integer:: i, j
    real*8:: k

    do i = 1, L
        do j = 1, L
            call random_number(k)
            if (k < 0.5d0) then
                mesh(i,j) = symble(-1)
            else
                mesh(i,j) = symble(1)
            end if
        end do   
    end do
end subroutine init_mesh

subroutine print_mesh(mesh)
    integer:: mesh(L,L)
    integer:: i, j

    open(10, file='saida_mesh_13862330.out')

    do i = 1, L
        do j = 1, L
            write(10, '(I5)', advance='no') mesh(i,j)
        end do
        write(*,*)
    end do
end subroutine print_mesh
end program


