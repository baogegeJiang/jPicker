      subroutine CPUTIMER(cpusec)   ! Urs Kradolfer, 16.9.1991
c
c     File: cputimer_vms.f
c
c     runs on VAX/VMS
c
c     first call:       start counting CPU-time
c     subsequent calls: report elapsed CPU-time [sec] since first call
c
c     Call:       call CPUTIMER(cpusec)     where cpusec is a real variable
c
      implicit none
c
      integer itask, itimer
      integer lib$init_timer, lib$stat_timer, icpu,jcpu, ifirst
      real cpusec
      save icpu,jcpu, ifirst
c
      if(ifirst.ne.123456789)then
         call lib$init_timer(icpu)
         ifirst=123456789
      else
         call lib$stat_timer(2,jcpu,icpu)
         cpusec=float(jcpu)/100.
      endif
c
      RETURN
c
      end ! of subroutine cputimer
c
