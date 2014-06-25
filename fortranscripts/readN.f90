INTEGER IRECL,NKPTS,NTET,ISPIN,NBTOT,NBVAL,NBCON
INTEGER NKPTS_KPOINTS,NK
REAL*8 RIRECL,RISPIN,RNBTOT,RNBVAL,RNBCON,RNKPTS
INTEGER I, J, ISP, IDIR, NV, NN, N, NP, spin,kpoint,bandone,bandtwo
REAL*8 ENone, ENtwo, Ediff
REAL*8 FEone, FEtwo
COMPLEX*8 NABLA, NABLA2
REAL*8, ALLOCATABLE    :: VKPT(:,:),EIGEN(:,:,:),FERWE(:,:,:)
REAL*8, ALLOCATABLE    :: VKPT_KPOINTS(:,:),WTKPT_KPOINTS(:)
REAL*8, ALLOCATABLE    :: QUASI(:,:,:)
COMPLEX*8, ALLOCATABLE :: NABIJ(:,:,:,:,:)
REAL*8, ALLOCATABLE    :: WTKPT(:)


OPEN(UNIT=20,FILE='OPTIC',FORM='UNFORMATTED',ACCESS='DIRECT', &
     STATUS='OLD',RECL=48)
READ(20,REC=1) RIRECL, RNBTOT, RNBVAL, RNBCON, RNKPTS, RISPIN
CLOSE(20)
IRECL =NINT(RIRECL)
NBVAL =NINT(RNBVAL)
NBCON =NINT(RNBCON)
NBTOT =NINT(RNBTOT)
NKPTS =NINT(RNKPTS)
ISPIN =NINT(RISPIN)

write(*,*) IRECL, NBVAL, NBCON, NBTOT, NKPTS, ISPIN

ALLOCATE( VKPT(3,NKPTS), &
          EIGEN(NBTOT,NKPTS,ISPIN), FERWE(NBTOT,NKPTS,ISPIN), &
          QUASI(NBTOT,NKPTS,ISPIN) )
ALLOCATE( VKPT_KPOINTS(3,NKPTS), WTKPT_KPOINTS(NKPTS) )
ALLOCATE( NABIJ(NBVAL,3,ISPIN,NKPTS,NBCON) )
ALLOCATE( WTKPT(NKPTS) )

call parse(spin,kpoint,bandone,bandtwo)

      OPEN(UNIT=20,FILE='OPTIC',FORM='UNFORMATTED', &
           ACCESS='DIRECT',RECL=IRECL,STATUS='OLD')
!      DO I = 2,20
!          READ(20, REC=I) &
!          ENone, ENtwo, FEone
!          write(*,*) ENone, ENtwo, FEone
!      ENDDO
      NKPTS = 4
      DO NK = 1, 4
         READ(20,REC=NK+1) (VKPT(I,NK),I=1,3), WTKPT(NK)
         write(*,*) VKPT(1,NK), VKPT(2,NK), VKPT(3,NK),  WTKPT(NK)
         DO ISP = 1, ISPIN
            READ(20,REC=ISP*NKPTS+NK+1) &
               (EIGEN(N,NK,ISP),FERWE(N,NK,ISP),N=1,NBVAL)
               write(*,*) EIGEN(bandone,NK,ISP)
            DO NN = 1, NBCON
               N = NBTOT - NBCON + NN
               DO IDIR = 1, 3
!                  write(*,*) (1+ISPIN)*NKPTS+1+IDIR+3*(ISP-1)     &
!                           +3*ISPIN*(NK-1)+3*ISPIN*NKPTS*(NN-1)
                  READ(20,REC=(1+ISPIN)*NKPTS+1+IDIR+3*(ISP-1)     &
                            +3*ISPIN*(NK-1)+3*ISPIN*NKPTS*(NN-1))  &
                       EIGEN(N,NK,ISP), FERWE(N,NK,ISP),             &
                       (NABIJ(NP,IDIR,ISP,NK,NN),NP=1,NBVAL)
               ENDDO
            ENDDO
         ENDDO
      ENDDO
      CLOSE(20)
ISP=1
NN=-NBTOT+NBCON+bandtwo
write(*,*) EIGEN(bandtwo,kpoint,ISP), &
      NABIJ(bandone,1,ISP,kpoint,NN), &
      NABIJ(bandone,2,ISP,kpoint,NN), &
      NABIJ(bandone,3,ISP,kpoint,NN)
!write(*,*) EIGEN(bandone,kpoint,spin), EIGEN(bandtwo,kpoint,spin)
!write(*,*)  NABIJ(bandone,1,spin,kpoint,NN), &
!        NABIJ(bandone,1,spin,kpoint,NN), &
!        NABIJ(bandone,1,spin,kpoint,NN)

!write(*,*) 'here'

DEALLOCATE(VKPT,EIGEN,FERWE,QUASI,VKPT_KPOINTS,WTKPT_KPOINTS,NABIJ)

stop
end program

subroutine parse(spin,kpoint,bandone,bandtwo)
integer spin,bandone,bandtwo,kpoint
real*8 x,y
character*20 option,value
integer iarg,narg,ia
iarg=iargc()
nargs=iarg/2
spin = 1
kpoint = 1
bandone = 232
bandtwo = 233
do ia=1,nargs
   call getarg(2*ia-1,option)
   call getarg(2*ia,value)
   if(option == "-s") then
read(value,*) spin
   else if(option == "-k") then
read(value,*) kpoint
   else if(option == "-bandone") then
read(value,*) bandone
   else if(option == "-bandtwo") then
read(value,*) bandtwo
   else
   endif
enddo
return
end subroutine parse
