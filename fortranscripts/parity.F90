!!$****** generate the parity of TIs ************* 
implicit real*8 (a-h, o-z) 
complex*8, allocatable :: coeff(:,:) 
complex*16, allocatable :: cener(:) 
real*8, allocatable :: occ(:) 
dimension a1(3),a2(3),a3(3),b1(3),b2(3),b3(3),vtmp(3),sumkg(3),wk(3) 
real*8::efermi,temp 
integer :: parity,parity2 
 
!!$* constant 'c' below is 2m/hbar**2 in units of 1/eV Ang^2 
 
data c/0.26246582250210965422d0/ 
pi=4.*atan(1.) 
efermi=4.9199 
parity=1 
 
!!$* choose an initial recl, open WAVECAR 
 
nrecl=24 
open(unit=10,file='WAVECAR',access='direct',recl=nrecl, & 
 iostat=iost,status='old') 

!!$* read file, spin, and precision information from WAVECAR

read(unit=10,rec=1) xnrecl,xnspin,xnprec 
write(*,*) xnrecl,xnspin,xnprec

nrecl=nint(xnrecl)
nspin=nint(xnspin)
nprec=nint(xnprec)
close(unit=10)

!!$* check errors

if(nprec.eq.45210) then 
 write(6,*) '*** error - WAVECAR_double requires complex*16' 
 stop 
endif 
open(unit=10,file='WAVECAR',access='direct',recl=nrecl, & 
 iostat=iost,status='old') 

if (iost.ne.0) then 
 write(6,*) 'open error - iostat =',iost 
endif

!!$* read the informatio of number of kpoints, number of bands, cutoff energy, and three basis vectors from WAVECAR

read(unit=10,rec=2) xnwk,xnband,ecut,(a1(j),j=1,3),(a2(j),j=1,3), & 
 (a3(j),j=1,3) 

write(*,*) xnwk,xnband,ecut

nwk=nint(xnwk) 
nband=nint(xnband) 
allocate(cener(nband)) 
allocate(occ(nband)) 

!!$* compute lattice properties including volume, reciprocal lattice vectors (both direction and magnitude) 

call vcross(vtmp,a2,a3) 
Vcell=a1(1)*vtmp(1)+a1(2)*vtmp(2)+a1(3)*vtmp(3) 
write(6,*) 'volume unit cell =',sngl(Vcell) 
call vcross(b1,a2,a3) 
call vcross(b2,a3,a1) 
call vcross(b3,a1,a2) 
do j=1,3 
 b1(j)=2.*pi*b1(j)/Vcell 
 b2(j)=2.*pi*b2(j)/Vcell 
 b3(j)=2.*pi*b3(j)/Vcell 
enddo 
b1mag=dsqrt(b1(1)**2+b1(2)**2+b1(3)**2) 
b2mag=dsqrt(b2(1)**2+b2(2)**2+b2(3)**2) 
b3mag=dsqrt(b3(1)**2+b3(2)**2+b3(3)**2) 
 
nb1max=(dsqrt(ecut*c)/b1mag)+1 

!!$* create a file to store the parity information
 
open(unit=11,file='parity.txt')
 
!!$* calculate parity
nparity=1 
do ig1=0,nb1max 
 ig1p=ig1 
 do j=1,3 
 sumkg(j)=(wk(1)+ig1p)*b1(j)+ & 
 wk(2)*b2(j)+wk(3)*b3(j) 
 enddo 
 gtot=sqrt(sumkg(1)**2+sumkg(2)**2+sumkg(3)**2) 
 etot=gtot**2/c 
 if (etot.lt.ecut) nparity=nparity+1 
enddo 
write(*,*) 'nparity= ',nparity 
  
!!$* Begin loops over spin, k-points and bands
irec=2
spin: do isp=1,nspin 
 write(*,*) ' ' 
 write(*,*) '******' 
 write(*,*) 'reading spin ',isp 
kpoints: do iwk=1,nwk 
 irec=irec+1 
 read(unit=10,rec=irec) xnplane,(wk(i),i=1,3), & 
 (cener(iband),occ(iband),iband=1,nband) 
 nplane=nint(xnplane)
 allocate (coeff(nplane,nband)) 
bands: do iband=1,nband 
 irec=irec+1 
 read(unit=10,rec=irec) (coeff(iplane,iband), & 
 iplane=1,nplane) 
 !!if (real(cener(iband)) .lt. efermi) then 
 temp=real(coeff(nparity,iband))/real(coeff(nparity-1,iband)) 
 if (temp .lt. 0) then 
 parity2=-1 
 else if (temp .gt. 0) then 
 parity2=1 
 end if
 write(*,*) parity2 
 write(11,*) iwk, iband, parity2 
 parity=parity*parity2  
 !end if 
 enddo bands 
 deallocate (coeff)
 enddo kpoints
enddo spin 
 
 write(6,*) 'total parity =',parity 
 
stop 
end program 

!!$*
!!$* routine for computing vector cross-product
!!$*
subroutine vcross(a,b,c)
implicit real*8(a-h,o-z)
dimension a(3),b(3),c(3)
a(1)=b(2)*c(3)-b(3)*c(2)
a(2)=b(3)*c(1)-b(1)*c(3)
a(3)=b(1)*c(2)-b(2)*c(1)
return
end subroutine vcross
