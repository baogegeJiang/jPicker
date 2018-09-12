      subroutine DATETIME(ctime)  ! Urs Kradolfer, 14. Jan. 1988
c
c     File:  datetime_vms.f
c
c     Call:  call DATETIME(ctime)
c
c            where ctime is a character*20 string which contains
c            the system DATE&TIME of the VAX-computer running VMS)
c            ( example: ctime='24-FEB-1986 16:10:03' )
c
      implicit none
      integer LIB$DATE_TIME
      character*20 ctime
c
      call LIB$DATE_TIME(ctime)
c
      RETURN
      end ! of subroutine datetime
c
