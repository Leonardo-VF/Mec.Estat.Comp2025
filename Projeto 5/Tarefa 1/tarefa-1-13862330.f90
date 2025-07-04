program tarefaA
  integer, parameter:: n = 20, L = 10
  real*8, parameter:: v_0 = 1.0d0, dt = 0.01d0, t_max = 10.0d0
  real*8, dimension(n,2):: cord, prev_cord, v, a, temp, vel
  real*8:: t, theta, rand1, rand2, l_grid, dx, dy
  integer:: i, j

  open(unit=10, file='positions.out')

  t = 0.0d0

  call init_positions(cord, v, n, L, dt, prev_cord)
  
  do while (t<t_max)
    t = t + dt
    
    temp = cord

    call calculate_forces(cord, a, n)
    call update_positions(cord, prev_cord, a, n, dt)
    call border_conditions(cord, n, prev_cord, L)

    prev_cord = temp

    do i = 1, n
      write(10,*)i, cord(i,1), cord(i,2)
      vel(i,1) = (cord(i,1) - prev_cord(i,1)) / (2.0d0*dt)
      vel(i,2) = (cord(i,2) - prev_cord(i,2)) / (2.0d0*dt)
    end do

  end do
  
  contains 

  subroutine init_positions(cord, v, n, L, dt, prev_cord)
  integer, intent(in) :: n, L
  real*8, intent(in)  :: dt
  real*8, dimension(n,2), intent(out) :: cord, v, prev_cord
  integer :: i, ix, iy
  integer, parameter :: nx = 4, ny = 5
  real*8 :: dx, dy, theta, rand1, rand2
  real*8, parameter :: v_0 = 1.0d0

  dx = real(L) / real(nx)
  dy = real(L) / real(ny)

  i = 0
  do iy = 0, ny-1
    do ix = 0, nx-1
      i = i + 1
      if (i > n) exit

      cord(i,1) = (ix + 0.5d0) * dx
      cord(i,2) = (iy + 0.5d0) * dy

      call random_number(rand1)
      call random_number(rand2)
      cord(i,1) = cord(i,1) + (rand1 - 0.5d0) * dx * 0.2d0
      cord(i,2) = cord(i,2) + (rand2 - 0.5d0) * dy * 0.2d0

      prev_cord = cord

      call random_number(theta)
      theta = theta * 2.0d0 * 3.141592653589793d0
      v(i,1) = v_0 * cos(theta)
      v(i,2) = v_0 * sin(theta)

      write(*,*)v(i,1), v(i,2), theta

      write(10,*) i, cord(i,1), cord(i,2)
    end do
  end do

  do i = 1, n
    cord(i,1) = mod(cord(i,1) + v(i,1) * dt, real(L))
    cord(i,2) = mod(cord(i,2) + v(i,2) * dt, real(L))
    write(10,*) i, cord(i,1), cord(i,2)
  end do
end subroutine init_positions


  subroutine border_conditions(cord, n, prev_cord, L)
    integer, intent(in):: n, L
    real*8, dimension(n,2), intent(inout):: cord, prev_cord
    real*8:: factor
    integer:: i

    do i = 1, n
      cord(i,1) = mod(cord(i,1), real(L))
      cord(i,2) = mod(cord(i,2), real(L))

      prev_cord(i,:) = cord(i,:)
    end do
  end subroutine

  subroutine update_positions(cord, prev_cord, a, n, dt)
    integer:: n, i, j
    real*8, dimension(n,2):: cord, prev_cord, v, a
    real*8:: dt
    real*8:: r, f

    do i = 1, n 
      cord(i,1) = 2.0d0*cord(i,1) - prev_cord(i,1) + a(i,1)*dt**2
      cord(i,2) = 2.0d0*cord(i,2) - prev_cord(i,2) + a(i,2)*dt**2
    end do
  end subroutine update_positions

  subroutine calculate_forces(cord, a, n)
    integer:: n
    real*8, dimension(n,2):: cord, a
    real*8:: r, f, dx, dy
    integer:: i, j

    a = 0.0d0

    do i = 1, n
      do j = i+1, n
        dx = cord(i,1) - cord(j,1)
        dy = cord(i,2) - cord(j,2)
        r = sqrt(dx**2 + dy**2)
        if (r <= 3.0d0) then
          f = 24.0d0 * (2.0d0 / r**13 - 1.0d0 / r**7)
          a(i,1) = a(i,1) + f * dx / r
          a(i,2) = a(i,2) + f * dy / r
          a(j,1) = a(j,1) - f * dx / r
          a(j,2) = a(j,2) - f * dy / r
        end if
      end do
    end do
  end subroutine

end program 