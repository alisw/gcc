! { dg-do compile }
! { dg-additional-options "-fcoarray=lib" }
!
! PR fortran/63861
! { dg-xfail-if "<http://gcc.gnu.org/PR63861>" { *-*-* } }

module test
contains
  subroutine oacc1(a)
    implicit none
    integer :: i
    integer, codimension[*] :: a
    !$acc declare device_resident (a)
    !$acc data copy (a)
    !$acc end data
    !$acc data deviceptr (a)
    !$acc end data
    !$acc parallel private (a)
    !$acc end parallel
    !$acc host_data use_device (a)
    !$acc end host_data
    !$acc parallel loop reduction(+:a)
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc parallel loop
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc update device (a)
    !$acc update host (a)
    !$acc update self (a)
  end subroutine oacc1

  subroutine oacc2(a)
    implicit none
    integer :: i
    integer, allocatable, codimension[:] :: a
    !$acc declare device_resident (a)
    !$acc data copy (a)
    !$acc end data
    !$acc parallel private (a)
    !$acc end parallel
! FIXME:
!       !$acc parallel loop reduction(+:a)
!       This involves an assignment, which shall not reallocate
!       the LHS variable. Version without reduction:
    !$acc parallel loop
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc parallel loop
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc update device (a)
    !$acc update host (a)
    !$acc update self (a)
  end subroutine oacc2

  subroutine oacc3(a)
    implicit none
    integer :: i
    integer, codimension[*] :: a(:)
    !$acc declare device_resident (a)
    !$acc data copy (a)
    !$acc end data
    !$acc data deviceptr (a)
    !$acc end data
    !$acc parallel private (a)
    !$acc end parallel
    !$acc host_data use_device (a)
    !$acc end host_data
    !$acc parallel loop reduction(+:a)
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc parallel loop
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc update device (a)
    !$acc update host (a)
    !$acc update self (a)
  end subroutine oacc3

  subroutine oacc4(a)
    implicit none
    integer :: i
    integer, allocatable, codimension[:] :: a(:)
    !$acc declare device_resident (a)
    !$acc data copy (a)
    !$acc end data
    !$acc parallel private (a)
    !$acc end parallel
    !$acc parallel loop reduction(+:a)
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc parallel loop
    do i = 1,5
    enddo
    !$acc end parallel loop
    !$acc update device (a)
    !$acc update host (a)
    !$acc update self (a)
  end subroutine oacc4
end module test
! { dg-excess-errors "sorry, unimplemented: directive not yet implemented" }
