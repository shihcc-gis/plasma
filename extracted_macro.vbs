Sub radpf005()
'
' radpf Macro
' Macro recorded 22/05/00 by NIE; last modified Melbourne October 2007; 10 January 2008
'RADPFV5.13.6  version5.13.6 includes separate current factors for axial and radial phases.
' Keyboard Shortcut: Ctrl+a
'
    Range("A20:DA30000").Select
    Selection.ClearContents

Rem File Name: RADPFV5.15de.c1 dated 20 July 2016; removed limitation to operate above 19 Torr and below 0.1, 0.05 Torr
Rem File Name: RADPFV5.15de.c dated 25 June 2016; corrected for dissociate number (pointed out by:Mohamed Abd Al-Halim); 1.ni corrected; increases by factor dissociatenumber 2. Yn b-t no difference; Yn thermo increased by factor dn^2 3.Yline Ybrem Yrec increased by dissociatenumber^2
Rem File Name: RADPFV5.15de dated 15 Feb 2010; removed Qsxr and changed term Qline to Yline
Rem File Name: RADPFV5.15dd dated 20 July 2009; add dataline and sheet 2 with charts for diagnostic reference
Rem FILE Name: RADPF05.15d dated 14 Dec 2008 to add contribution from PRADS to Qline and Qsxr
Rem FILE Name: RADPF05.15c dated 13 Dec 2008 corrected for Ysxr inconsistency with Yline (minor correction)
Rem FILE Name: RADPF05.15b dated 8 November 2008 corrected for N2/Kr g & z mixup; and added Ysxr using temp range; N2:0.86-2.0*10^6; Neon: 2.3-5.0*10^6
Rem FILE Name: RADPF05.15a dated 25 October 2008 corrected for fcr housekeeping error pointed out by M Akel
Rem 13.8 Smooth transition from plasma self-absorption corrected volume emission to surface emission, tested for NX2 neon
Rem 13.9a has proper output of tapered anode PF; and g properly incorporated.
Rem 13.9b corrects for an error in expanded phase current calculations
Rem 13.9c has dataline for ease of data compilation; includes Nitrogen, thermodynamic data input as 6-order polynomial with limits
Rem 14a: corrected 5.14 for a numerical instability feature during RS phase for Neon low pressure operation
Rem 15: includes D-T (1:1);includes Krypton, thermodynamic data input as 6-order polynomial; includes dataline & datasheet

Rem The following ranges of pressure apply to UNU/ICTP PFF
Rem Hydrogen operation                                                    Atomic No 1,  Mass No 2 (molecular)
Rem CHECKED OK FOR DEUTERIUM OPERATION IN PRESSURE RANGE 0.5 TO 10 TORR   Atomic No 1,  Mass No 4 (molecular)
Rem D-T (1:1)                                                             Atomic No 1,  Mass no 5 (molecular)
Rem Helium operation                                                      Atomic No 2,  Mass No 4
Rem Nitrogen operation                                                    Atomic No 7,  Mass No 28 (molecular)
Rem CHECKED OK FOR NEON OPERATION IN PRESSURE RANGE 0.1 TO 6 TORR         Atomic No 10, mass No 20
Rem CHECKED OK FOR Ar OPERATION IN PRESSURE RANGE 0.1 TO 2.5 TORR         Atomic No 18, mass No 40
Rem Kr                                                                    Atomic No 36, mass No 84
Rem Xenon operation                                                       Atomic No 54, mass No 132

Rem For H2, D2 and He, assume fully ionized and gamma=1.667 for all of radial phase; practically this means
Rem For H2, D2 and He, starting radial speed exceeds approx 5 cm/us and for D2 and He 4 cm/us

Rem GAS IS SWITCHED BY INPUTTING, ON EXCEL SHEET, MOLEFULAR WEIGHT, ATOMIC NUMBER, DISSOCIATION NUMBER, SPECIFIC HEAT RATIO; ALSO INPUT CORRECT AMBIENT PRESSURE

Rem DETAILED INFORMATION ON SPEC HT RATIO AND EFFECTIVE CHARGE NUMBER included.

Rem  *    LANGUAGE  : Microsoft EXCEL Visual Basic; converted from GWBASIC*
Rem  *    DATE      : 10 MAY 1991 (version 3) -JUNE 2000 (version 5)*

Rem "PF-4 PHASE" MODEL-S.LEE 10.5.1991 (ver 3) FOR ICTP SPRING COLLEGE ON PLASMA "
Rem MODIFIED 7.7.92-S.LEE; Modified Radiative PF-S.LEE 19.3.1995 (version 4) & 22.3.96
Rem Standard S.Lee Model 12.6.2000 (EXCEL Visual Basic for training manual; version 5)

Rem Updated October 2005 to include ratio "alpha" too low warning! version 5.008
Rem Updated May 2006 to include Xenon; as version 5.010; and He; also trial include plasma self-absorption
Rem Modified Oct 2007 improved neutron yield inductive model; with yield calibrated against the UNU/ICTP PFF 3kJ 180kA PF

Rem Standard S Lee Model has 5 Phases
Rem "PhaseI:Axial. Phase II: Radial INWARD SHOCK. Phase III: RADIAL REFLECTED SHOCK. Phase IV: Slow Compression (Radiative). Part V:Expanded Large Column Axial.

Rem For each numerical experiment use suggested MODEL PARAMETERS only as first attempt
Rem Then COMPARE Computed current trace with Measured Current trace; adjust Model Parameters to best match the following points
Rem (1)  Axial phase transit time (time to current dip): adjust MASSF (principally)
Rem (1a) Value of peak current and current rise shape: may also need to adjust CURRF and Lo and ro
Rem (1) and (1a) may need several iterations
Rem (2)  Next adjust MASSFR to match the current dip, depth of dip, shape of dip; if measured trace shows oscillations

Rem * G = specific heat ratio
Rem * RADB = OUTER RADIUS (in m, for calculations in real quantities)
Rem * RADA = INNER RADIUS (in m,  ditto )
Rem * Z0   = LENGTH OF ANODE (in m, ditto)
Rem * C    = RADB/RADA
Rem * F    = Z0/RADA
Rem * L0   = CIRCUIT STRAY INDUCTANCE (in HENRY, ditto)
Rem * C0   = ENERGY STORAGE CAPACITANCE (in FARAD, ditto)
Rem * AL= capacitor time T0/TA, axial run-down time
Rem * BE= full axial phase inductance LZ0/L0
Rem MASSF= REDUCED MASS FACTOR DUE TO MASS SHEDDING
Rem CURRF= REDUCED CURRENT FACTOR DUE TO CURRENT SHEDDING
Rem R0 IS STRAY CIRCUIT RESISTANCE IN OHM; RESF=R0/Surge Impedance
Rem * Z1 is end position, to end calculation of phase 5;
Rem * MASSF, MASSFR are incorporated in TA & AL & in AA;
Rem * CURRF IS INcorporated into BE
Rem * For Phase I calculations, T = Time, Z = Axial position (normalized to Zo)
Rem * I = Current, ZZ = Speed, AC = Acceleration
Rem * II = Current derivative, I0 = Current Intergral, all normalized
Rem * HOWEVER ALL QUANTITIES WITH An R ATTACHED, HAVE BEEN RE-COMPUTED TO GIVE LABORATORY VALUES; e.g. TR IS TIME RE-COMPUTED IN MICROSEC;IR IS CURRENT RE-COMPUTED IN kA AND SO ON.
Rem  D = Time increment, V = tube voltage, all normalized

Dim backhowmanyrows As Integer
ENDFLAG = 0
DFLAG = 0
DVFLAG = 0
NTN = 0
NBN = 0
NN = 0
VRMAX = 0
peakvs = 0
peakvp = 0
tc5 = 1
Rem Quick Device Choice
device = ActiveSheet.Cells(4, 18)
If device = 0 Then GoTo 320
If device = 1 Then ActiveSheet.Cells(3, 2) = "UNUICTPPFF": L0 = 110: C0 = 30: RADB = 3.2: RADA = 0.95: Z0 = 16: R0 = 12: V0 = 15: P0 = 3.5: MW = 4: ZN = 1: dissociatenumber = 2: massf = 0.08: CURRF = 0.7: massfr = 0.16: currfr = 0.7: ActiveSheet.Cells(5, 1) = L0: ActiveSheet.Cells(5, 2) = C0: ActiveSheet.Cells(5, 3) = RADB: ActiveSheet.Cells(5, 4) = RADA: ActiveSheet.Cells(5, 5) = Z0: ActiveSheet.Cells(5, 6) = R0: ActiveSheet.Cells(7, 1) = massf: ActiveSheet.Cells(7, 2) = CURRF: ActiveSheet.Cells(7, 3) = massfr: ActiveSheet.Cells(7, 4) = currfr: ActiveSheet.Cells(9, 1) = V0: ActiveSheet.Cells(9, 2) = P0: ActiveSheet.Cells(9, 3) = MW: ActiveSheet.Cells(9, 4) = ZN: ActiveSheet.Cells(9, 5) = dissociatenumber: GoTo 356
If device = 2 Then ActiveSheet.Cells(3, 2) = "NX2-RGNeon": L0 = 20: C0 = 28: RADB = 4.1: RADA = 1.9: Z0 = 5: R0 = 2.3: V0 = 11: P0 = 2.63: MW = 20: ZN = 10: dissociatenumber = 1: massf = 0.0635: CURRF = 0.7: massfr = 0.16: currfr = 0.7: ActiveSheet.Cells(5, 1) = L0: ActiveSheet.Cells(5, 2) = C0: ActiveSheet.Cells(5, 3) = RADB: ActiveSheet.Cells(5, 4) = RADA: ActiveSheet.Cells(5, 5) = Z0: ActiveSheet.Cells(5, 6) = R0: ActiveSheet.Cells(7, 1) = massf: ActiveSheet.Cells(7, 2) = CURRF: ActiveSheet.Cells(7, 3) = massfr: ActiveSheet.Cells(7, 4) = currfr: ActiveSheet.Cells(9, 1) = V0: ActiveSheet.Cells(9, 2) = P0: ActiveSheet.Cells(9, 3) = MW: ActiveSheet.Cells(9, 4) = ZN: ActiveSheet.Cells(9, 5) = dissociatenumber: GoTo 356
If device = 3 Then ActiveSheet.Cells(3, 2) = "PF1000 27D": L0 = 33: C0 = 1332: RADB = 16: RADA = 11.55: Z0 = 60: R0 = 6.3: V0 = 27: P0 = 3.5: MW = 4: ZN = 1: dissociatenumber = 2: massf = 0.14: CURRF = 0.7: massfr = 0.35: currfr = 0.7: ActiveSheet.Cells(5, 1) = L0: ActiveSheet.Cells(5, 2) = C0: ActiveSheet.Cells(5, 3) = RADB: ActiveSheet.Cells(5, 4) = RADA: ActiveSheet.Cells(5, 5) = Z0: ActiveSheet.Cells(5, 6) = R0: ActiveSheet.Cells(7, 1) = massf: ActiveSheet.Cells(7, 2) = CURRF: ActiveSheet.Cells(7, 3) = massfr: ActiveSheet.Cells(7, 4) = currfr: ActiveSheet.Cells(9, 1) = V0: ActiveSheet.Cells(9, 2) = P0: ActiveSheet.Cells(9, 3) = MW: ActiveSheet.Cells(9, 4) = ZN: ActiveSheet.Cells(9, 5) = dissociatenumber: GoTo 356

Rem Input, from EXCEL Sheet, Machine Parameters, in convenient units

320 L0 = ActiveSheet.Cells(5, 1)
322 C0 = ActiveSheet.Cells(5, 2)
324 RADB = ActiveSheet.Cells(5, 3)
326 RADA = ActiveSheet.Cells(5, 4)
328 Z0 = ActiveSheet.Cells(5, 5)
336 R0 = ActiveSheet.Cells(5, 6)

Rem Is anode tapered?
TAPER = ActiveSheet.Cells(7, 8)
Rem Input, from EXCEL Sheet, Machine Operational parameters, in convenient units

350 V0 = ActiveSheet.Cells(9, 1)
352 P0 = ActiveSheet.Cells(9, 2)
354 MW = ActiveSheet.Cells(9, 3)
355 ZN = ActiveSheet.Cells(9, 4)
dissociatenumber = ActiveSheet.Cells(9, 5)

Rem range of experimentally found Model parameters:

Rem ZN = 1  massf = 0.06 to 0.15; typically try 0.08 ; massfr = 0.15-0.4; typically try 0.2; currf = 0.7-0.8; typically try 0.75
Rem ZN = 10 or 18 massf = 0.04-0.12; typically try 0.046: massfr = 0.1-0.2; currf = 0.7-0.8
Rem for UNU/ICTP PFF for ZN=1, try massf=0.073, massfr=0.16, currf=0.7; ZN=10 or 18 try massf=0.046, massfr=0.3 currf=0.8
Rem NX2 is a 'fatter' focus than UNU/ICTP PFF with length to radius ratio of ~2.5 compared UNU/ICTP PFF of ~17
Rem for NX2 for ZN=1, try massf=0.1, massfr=0.2, currf=0.7; for ZN=10 or 18 try massf=0.095, massfr=0.16, currf=0.7
Rem Input, from EXCEL Sheet, Model Parameters

massf = ActiveSheet.Cells(7, 1)
CURRF = ActiveSheet.Cells(7, 2)
massfr = ActiveSheet.Cells(7, 3)
currfr = ActiveSheet.Cells(7, 4)
356 R0 = R0 / 1000
Rem Input some constants in SI units

MU = 1.257 * 10 ^ -6
Pi = 3.142
bc = 1.38 * 10 ^ -23
mi = 1.67 * 10 ^ -27
MUK = MU / (8 * Pi * Pi * bc)
CON11 = 1.6 * 10 ^ -20
CON12 = 9.999999 * 10 ^ -21
CON2 = 4.6 * 10 ^ -31
UGCONS = 8.310001 * 10 ^ 3
FRF = 0.3
fe = 1 / 3
FLAG = 0

Rem reset EINP, energy dissipated by dynamic resistance effect, which is 0.5 (Ldot) I^2, considering current taking part in the motion
EINP = 0
Rem If operating in Deuterium, set value of G

If ZN = 1 Then GoTo 358
If ZN = 2 Then GoTo 358
Rem If Ne or argon or Xenon, Kr or N2, set approx initial values of G

g = 1.3
G1 = 2 / (g + 1)
G2 = (g - 1) / g
GCAP = (g + 1) / (g - 1)
GoTo 359

Rem Deuterium values of G

358 g = 1.66667
G1 = 2 / (g + 1)
G2 = (g - 1) / g
GCAP = (g + 1) / (g - 1)

Rem Calculate ambient atomic number density (no of atoms per m^2)and some ratios
Rem For PF operation assume all molecules are completely dissociated in all phases
Rem N0= number of atoms per m^2; atomic number density
Rem DNchange
359 N0 = dissociatenumber * 2.69 * (10 ^ 25) * P0 / 760
360 C = RADB / RADA
361 f = Z0 / RADA

Rem Convert to SI units

362 C0 = C0 * 10^-6
364 L0 = L0 * 10^-9
365 RADB = RADB * 0.01
366 RADA = RADA * 0.01
368 Z0 = Z0 * 10^-2
370 V0 = V0 * 1000
380 RHO = P0 * 2.33 * (10 ^ -4) * MW / 4
TM = 0
If TAPER = 0 Then GoTo 382
TAPERSTART = ActiveSheet.Cells(7, 9)
ENDRAD = ActiveSheet.Cells(7, 10)
TAPERSTART = TAPERSTART * 0.01
ENDRAD = ENDRAD * 0.01
zTAPERSTART = TAPERSTART / Z0
tapergrad = (RADA - ENDRAD) / (Z0 - TAPERSTART)

Rem Calculate characteristic quantities and scaling parameters

382 I0 = V0 / (Sqr(L0 / C0))
# Lee paper, page 5
384 T0 = Sqr(L0 * C0)
390 TA = Sqr(4 * Pi * Pi * (C * C - 1) / (MU * Log(C))) * ((Z0 * Sqr(RHO)) / (I0 / RADA)) * ((Sqr(massf)) / CURRF)
395 ZZCHAR = Z0 / TA
400 AL = T0 / TA
401 AA = Sqr((g + 1) * (C * C - 1) / Log(C)) * (f / 2) * (Sqr(massf / massfr)) * (currfr / CURRF)
402 RESF = R0 / (Sqr(L0 / C0))
404 BE = 2 * (10 ^ -7) * Log(C) * Z0 * CURRF / L0
BF = BE / (Log(C) * f)
410 VPINCHCH = ZZCHAR * AA / f
TPINCHCH = RADA / VPINCHCH
Rem Calculate ratio of characteristic capacitor time to sum of characteristic axial & radial times
ALT = (AL * AA) / (1 + AA)
Rem Write on EXCEL SHEET, in convenient units, density, characteristic quantities and scaling parameters

415 ActiveSheet.Cells(11, 1) = RHO
416 ActiveSheet.Cells(11, 2) = I0
417 ActiveSheet.Cells(11, 3) = T0
418 ActiveSheet.Cells(11, 4) = TA
419 ActiveSheet.Cells(11, 5) = ZZCHAR
420 ActiveSheet.Cells(11, 6) = VPINCHCH
ActiveSheet.Cells(11, 7) = TPINCHCH

422 ActiveSheet.Cells(13, 1) = C
423 ActiveSheet.Cells(13, 2) = f
424 ActiveSheet.Cells(13, 3) = AL
425 ActiveSheet.Cells(13, 4) = AA
426 ActiveSheet.Cells(13, 5) = BE
427 ActiveSheet.Cells(13, 6) = RESF
ActiveSheet.Cells(13, 7) = ALT

Rem ActiveSheet.Cells(16, 8) = 0
Rem ActiveSheet.Cells(16, 10) = 0
Rem ActiveSheet.Cells(16, 12) = 0
Rem ActiveSheet.Cells(16, 14) = 0

ActiveSheet.Cells(7, 11) = 0
ActiveSheet.Cells(7, 12) = 0
ActiveSheet.Cells(7, 13) = 0
ActiveSheet.Cells(7, 14) = 0
ActiveSheet.Cells(7, 15) = 0

Rem ActiveSheet.Cells(9, 8) = 0
Rem ActiveSheet.Cells(9, 10) = 0
Rem ActiveSheet.Cells(9, 11) = 0
Rem ActiveSheet.Cells(9, 12) = 0
Rem ActiveSheet.Cells(9, 13) = 0
Rem ActiveSheet.Cells(9, 14) = 0

ActiveSheet.Cells(11, 8) = 0
ActiveSheet.Cells(11, 10) = 0
ActiveSheet.Cells(11, 12) = 0
ActiveSheet.Cells(11, 14) = 0

ActiveSheet.Cells(17, 25) = 0
ActiveSheet.Cells(17, 32) = 0

Rem Removed limitation to operate above 19 Torr

440 If ZN = 1 Then GoTo 460
If ZN = 2 Then GoTo 460

If ZN = 7 Then GoTo 470
452 If ZN = 10 Then GoTo 470
453 If ZN = 18 Then GoTo 470
    If ZN = 36 Then GoTo 470
454 If ZN = 54 Then GoTo 470

460 Rem Removed limitation to operate above 19 Torr
470 Rem Removed limitation to operate below 0.1 0.05 Torr

480 GoTo 482
482 If ZN = 1 Then GoTo 485: If ZN = 2 Then GoTo 485

If ZN = 7 Then GoTo 488
If ZN = 10 Then GoTo 488
If ZN = 18 Then GoTo 488
If ZN = 36 Then GoTo 488
If ZN = 54 Then GoTo 488

485 If ALT > 0.68 Then GoTo 500

Stop
Rem WARNING! Total TRANSIT TIME (axial + radial) MAY BE TOO LONG COMPARED TO effective DISCHARGE Drive TIME
Rem  FOLLOWING ACTION RECOMMENDED:
Rem                               REDUCE FILL PRESSURE  OR
Rem                               INCREASE CHARGE VOLTAGE  OR
Rem                               SHORTEN AXIAL LENGTH
Rem  It may also be necessary to check that you have not unreasonably reduced the value of C or L or
Rem  unreasonably increased the value of radius or length
Rem You may attempt to OVER-RIDE this stop; go to run; continue

Rem  or Click on red cross on top right hand corner to get back to spread sheet
Rem You may attempt to OVER-RIDE this stop; go to run; continue

488 If ALT > 0.65 Then GoTo 500

Stop
Rem WARNING! Total TRANSIT TIME (axial + radial) MAY BE TOO LONG COMPARED TO effective DISCHARGE Drive TIME
Rem  FOLLOWING ACTION RECOMMENDED:
Rem                               REDUCE FILL PRESSURE  OR
Rem                               INCREASE CHARGE VOLTAGE  or
Rem                               SHORTEN AXIAL LENGTH
Rem  It may also be necessary to check that you have not unreasonably reduced the value of C or L or
Rem  unreasonably increased the value of radius or length
Rem You may attempt to OVER-RIDE this stop; go to run; continue
Rem  or Click on red cross on top right hand corner to get back to spread sheet

Rem Set the first row to record data from numerical integration
500 rowj = 20

Rem Set time increment and initial values

530 d = 0.002
540 T = 0: z = 0: ZZ = 0
550 II = 1: I = 0: IO = 0
570 AC = AL * Sqr(1 / 2)

Rem Start numerical integration of AXIAL PHASE
Ipeak = 0
580 T = T + d
If T > 6 Then Stop
610 ZZ = ZZ + AC * d
615 z = z + ZZ * d
630 I = I + II * d
635 IO = IO + I * d

Rem Convert data to real, but convenient units

671 TR = T * T0 * 10 ^ 6
672 VR = V * V0 * 10 ^ -3
673 IR = I * I0 * 10 ^ -3
674 ZZR = (ZZCHAR / AL) * ZZ * 10 ^ -4
675 ACR = ((ZZCHAR / AL) / T0) * AC * 10 ^ -10
676 ZR = z * Z0 * 100
677 IIR = (II * I0 / T0) * 10 ^ -9
678 IOR = IO * I0 * T0

If IR > Ipeak Then Ipeak = IR
Rem DR is time increment in sec
DR = d * T0
Rem DZR is z increment in m
DZR = DR * ZZR * 10 ^ 4
Rem Integrate to find EINP, energy dissipated by dynamic resistance effect, which is 0.5 (Ldot) I^2, considering current taking part in the motion
EINP = EINP + (10 ^ -7) * (Log(C) * ZZR * (10 ^ 4) * IR * IR * (10 ^ 6) * CURRF * CURRF) * DR
Rem Also integrate for piston work
Wpiston = Wpiston + (10 ^ -7) * (Log(C)) * IR * IR * (10 ^ 6) * CURRF * CURRF * DZR

Lz = (10 ^ -9) * ZR * 2 * Log(C)

Rem Einductance is total inductive energy (in all inductances)
Einductance = 0.5 * 10 ^ 6 * IR * IR * (CURRF * CURRF * Lz + L0)
GoTo 680
Rem Following statement computes shock temperature, however need to first enumerate zeff
Rem TM = 2.4 * (10 ^ -4) * ((g - 1) / ((g + 1) ^ 2)) * (MW / zeff) * ZZR * (10 ^ 8)

680 ni = massf * N0 * ((g + 1) / (g - 1))
nimax = N0 * ((g + 1) / (g - 1))
Rem Write, on EXCEL Sheet, in convenient real units, the step-by-step data from numerical integration

771 ActiveSheet.Cells(rowj, 1) = TR
772 ActiveSheet.Cells(rowj, 2) = IR
773 ActiveSheet.Cells(rowj, 3) = VR
774 ActiveSheet.Cells(rowj, 4) = ZR
775 ActiveSheet.Cells(rowj, 5) = ZZR
ActiveSheet.Cells(rowj, 52) = TR
ActiveSheet.Cells(rowj, 53) = IR * CURRF
ActiveSheet.Cells(rowj, 61) = Lz * 10 ^ 9
ActiveSheet.Cells(rowj, 62) = 100 * Einductance / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 63) = 100 * EINP / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 64) = ni / (10 ^ 23)
ActiveSheet.Cells(rowj, 65) = TM / (10 ^ 6)
ActiveSheet.Cells(rowj, 67) = nimax / (10 ^ 23)
ActiveSheet.Cells(rowj, 69) = 100 * Wpiston / (0.5 * C0 * V0 * V0)
rowj = rowj + 1

If TAPER = 0 Then GoTo 780
If z < zTAPERSTART Then GoTo 780

Rem Compute tapered anode  for this axial position

w = f * tapergrad * (z - zTAPERSTART)
c1 = RADB / (RADA * (1 - w))
TA = Sqr(4 * Pi * Pi * (C * C - 1) / (MU * Log(c1))) * ((Z0 * Sqr(RHO)) / (I0 / RADA)) * ((Sqr(massf)) / CURRF)
AL1 = T0 / TA
BE = 2 * (10 ^ -7) * Log(C) * Z0 * CURRF / L0
tc1 = 1 + (w * (4 - 3 * w)) / (2 * (C * C - 1))
tc2 = w * (z - zTAPERSTART) * (2 - w) / (2 * (C * C - 1))
LOG1 = Log(1 / (1 - w))
tc3 = 1 + LOG1 / Log(C)
tc4 = z + ((1 / Log(C)) * (1 - ((1 - w) / w) * LOG1) * (z - zTAPERSTART))

V = (tc4) * II + ZZ * I * tc3
V = V * BE

778 AC = (AL1 * AL1 * I * I - ZZ * ZZ * tc1) / (z + tc2)
II = (1 - IO - BE * tc3 * ZZ * I - RESF * I) / (1 + BE * tc4)

GoTo 800

780 V = z * II + ZZ * I
V = V * BE
Rem Compute Generating Quantities (ie acceleration and IDOT) before loopback to continue step-by-step integration

AC = (AL * AL * I * I - ZZ * ZZ) / z
790 II = (1 - IO - BE * ZZ * I - RESF * I) / (1 + BE * z)

Rem Check if end of axial phase is reached, before loopback

800 If z < 1 Then GoTo 580
Laxial = ZR * 2 * Log(C)
Rem Leave Axial Phase integration, record last value of axial speed

815 ZG = ZZ
CFA = CURRF
Rem Introduce differential in current factors for axial and radial phases
CurrentFactorRatio = currfr / CURRF
CFR = CurrentFactorRatio

BE = BE * CFR
BF = BF * CFR
CURRF = CURRF * CFR
AAg = AA / Sqr(g + 1)

If TAPER = 0 Then GoTo 820
w1 = f * tapergrad * (1 - zTAPERSTART)
c2 = RADB / (RADA * (1 - w1))
AA1 = AA * (RADA / ENDRAD) * Sqr((Log(C) / Log(c2)))
LOG2 = Log(1 / (1 - w1))
tc5 = 1 + ((1 / Log(C)) * (1 - ((1 - w1) / w1) * LOG2) * (1 - zTAPERSTART))
AAg1 = AA1 / Sqr(g + 1)


820 Rem * Radial phase RI, distances are relative to radius a.
850 Rem * KS is shock position, KP is radial piston position, ZF is focus
860 Rem * pinch length, all normalized to inner radius a; VS and VP are
870 Rem * radial shock and piston speed,VZ is axial pinch length elongating rate
911 Rem * Distances, radius and speeds are relative to radius of anode.
912 Rem AS BEFORE QUANTITIES WITH AN R ATTACHED HAVE BEEN RE-COMPUTED AS REAL, i.e. UN-NORMALIZED QUANTITIES EXPRESSED IN USUAL LABORATORY UNITS.

Rem End of Axial Phase; Start of Radial Inward Shock Phase

Rem : FOR THIS PHASE Z=EFFECTIVE CHARGE NUMBER!!!

rowi = 20
FIRSTRADIALROW = rowi

Rem Set some initial values for Radial Inward Phase step-by-step integration
Rem Reset time increment to finer step-size

930 KS = 1: KP = 1: ZF = 1E-05
zFLAG = 0: gFLAG = 0
Rem SET TIME INCREMENT TO HAVE ABOUT 1500 (up to 3000 for high pressure) STEPS IN RADIAL INWARD SHOCK PHASE

If TAPER = 0 Then GoTo 950
TPINCHCH = TPINCHCH * (ENDRAD / RADA) * (ENDRAD / RADA)

950 DREAL = TPINCHCH / 700
d = DREAL / T0

Rem Set initial 'LookBack' values, for compensation of finite small disturbance speed

IDELAY = I: KPDELAY = KP: KSDELAY = KS: VSDELAY = -1

Rem Set initial value, approximately, for CHARGE NUMBER Z
Rem For H2,D2 and He, assume fully ionized with gamma=1.667 during all of radial phase
z = ZN
Rem Start Step-by-step integration of Radial Inward Shock Phase, in non-dimensional units
Rem First, compute Inward shock speed

trradialstart = T * T0
ActiveSheet.Cells(11, 8) = trradialstart * (10 ^ 6)

980 If TAPER = 0 Then GoTo 990
AA1 = AAg1 * Sqr(g + 1)
VS = -AL1 * AA1 * IDELAY / (KPDELAY)
VSR = VS * ENDRAD / T0

GoTo 1000

990 GCAP = (g + 1) / (g - 1)
AA = AAg * Sqr(g + 1)
VS = -AL * AA * IDELAY / (KPDELAY)
VSR = VS * RADA / T0
Rem Real temperature is needed to DETERMINE SMALL DISTURBANCE SPEED FOR COMMUNICATION TIME CORRECTION.
Rem Hence the shock speed is re-calculated in SI units, then Plasma Temp TM is calculated, based on shock theory

1000 TM = (MW / (8315)) * ((GCAP - 1) / (GCAP * GCAP)) * ((VSR * VSR) / ((1 + z) * dissociatenumber))
TeV = TM / (1.16 * 10 ^ 4)
Rem Select Table for G & Z; according to gas

1005 If ZN = 1 Then GoTo 1080
If ZN = 2 Then GoTo 1080

If ZN = 7 Then GoTo 1185
If ZN = 10 Then GoTo 1010
If ZN = 18 Then GoTo 1050
If ZN = 36 Then GoTo 1190
If ZN = 54 Then GoTo 1150

Rem Table for G, for Neon, pre-calculated from Corona Model

1010 If TM > 10 ^ 8! Then GoTo 1020
1012 If TM > 2 * 10 ^ 7! Then GoTo 1022
1014 If TM > 4.5 * 10 ^ 6! Then GoTo 1024
1016 If TM > 2.3 * 10 ^ 6! Then GoTo 1026
1018 If TM > 3.4 * 10 ^ 5! Then GoTo 1027
If TM > 2.4 * 10 ^ 4! Then GoTo 1028
If TM > 1.7 * 10 ^ 4! Then GoTo 1029
If TM > 10 ^ 4! Then GoTo 1030

g = 1.66667
GoTo 1035
1020 g = 1.66667
GoTo 1035
1022 g = 1.6 + 0.83 * (10 ^ -9) * (TM - 2 * 10 ^ 7)
GoTo 1035
1024 g = 1.47 + 0.84 * (10 ^ -8) * (TM - 4.5 * 10 ^ 6)
GoTo 1035
1026 g = 1.485
GoTo 1035
1027 g = 1.23 + 1.2 * (10 ^ -7) * (TM - 3.4 * 10 ^ 5)
GoTo 1035
1028 g = 1.15 + 2.22 * 10 ^ -7 * (TM - 2.4 * 10 ^ 4)
GoTo 1035
1029 g = 1.66667 - 7.67E-05 * (TM - 10000)
GoTo 1035
1030 g = 1.66667

Rem Table for Z for Neon, pre-calculated from Corona Model

1035 If TM > 7 * 10 ^ 6! Then GoTo 1040
 If TM > 2.3 * 10 ^ 6! Then GoTo 1043
 If TM > 4.5 * 10 ^ 5! Then GoTo 1046
 If TM > 4.5 * 10 ^ 4! Then GoTo 1047
If TM > 15000! Then GoTo 1048

z = 0
GoTo 1080

1040 z = 10
GoTo 1080
1043 z = 8 + 0.4255 * (10 ^ -6) * (TM - 2.3 * 10 ^ 6)
GoTo 1080
1046 z = 8
GoTo 1080
1047 z = 1.9 + 1.5 * (10 ^ -5) * (TM - 4.5 * 10 ^ 4)
GoTo 1080
1048 z = 6.3E-05 * (TM - 15000)
If FLAG = 10 Then GoTo 3030
GoTo 1080

Rem Table of G for ARGON; pre-calculated from Corona Model

1050 If TM > 1.5 * 10 ^ 8! Then GoTo 1060
If TM > 1.2 * 10 ^ 7! Then GoTo 1061
If TM > 1.9 * 10 ^ 6! Then GoTo 1062
If TM > 9.3 * 10 ^ 5! Then GoTo 1063
If TM > 5.7 * 10 ^ 5! Then GoTo 1064
If TM > 10 ^ 5! Then GoTo 1065
If TM > 1.3 * 10 ^ 4! Then GoTo 1066
If TM > 9000! Then GoTo 1068

1060 g = 1.66667
GoTo 1070
1061 g = 1.54 + 9 * (10 ^ -10) * (TM - 1.2 * 10 ^ 7)
GoTo 1070
1062 g = 1.31 + 2.6 * (10 ^ -8) * (TM - 1.9 * 10 ^ 6)
GoTo 1070
1063 g = 1.3
GoTo 1070
1064 g = 1.34 - 1.6 * (10 ^ -7) * (TM - 5.7 * 10 ^ 5)
GoTo 1070
1065 g = 1.17 + 3.8 * (10 ^ -7) * (TM - 10 ^ 5)
GoTo 1070
1066 g = 1.15 + 2.3 * (10 ^ -7) * (TM - 1.3 * 10 ^ 4)
GoTo 1070
1068 g = 1.66667 - 1.29 * (10 ^ -4) * (TM - 9000)

Rem Table for Z for Argon, pre-calculated from Corona Model

1070 If TM > 1.3 * 10 ^ 8! Then GoTo 1071
 If TM > 1.3 * 10 ^ 7! Then GoTo 1072
 If TM > 3.5 * 10 ^ 6! Then GoTo 1073
 If TM > 4.7 * 10 ^ 5! Then GoTo 1074
 If TM > 2 * 10 ^ 5! Then GoTo 1075
 If TM > 1.9 * 10 ^ 4! Then GoTo 1076
 If TM > 1.4 * 10 ^ 4! Then GoTo 1077
 If TM > 9000! Then GoTo 1078
GoTo 1079

1071 z = 18
GoTo 1080
1072 z = 16 + 1.8 * (10 ^ -8) * (TM - 1.3 * 10 ^ 7)
GoTo 1080
1073 z = 16
GoTo 1080
1074 z = 8 + 2.9 * (10 ^ -6) * (TM - 4.7 * 10 ^ 5)
GoTo 1080
1075 z = 8
GoTo 1080
1076 z = 1 + 3.7 * (10 ^ -5) * (TM - 1.9 * 10 ^ 4)
GoTo 1080
1077 z = 1
GoTo 1080
1078 z = 0.0002 * (TM - 9000)
GoTo 1080
1079 z = 0

1080 G1 = 2 / (g + 1)
G2 = (g - 1) / g
If FLAG = 10 Then GoTo 3030
GoTo 2000

Rem Table of G for Xenon; pre-calculated from Corona Model

1150 If TM > 9 * 10 ^ 10! Then GoTo 1160
If TM > 1.16 * 10 ^ 9! Then GoTo 1161
If TM > 1.01 * 10 ^ 8! Then GoTo 1162
If TM > 2.02 * 10 ^ 7! Then GoTo 1163
If TM > 6.23 * 10 ^ 6! Then GoTo 1164
If TM > 9.4 * 10 ^ 5! Then GoTo 1165
If TM > 3.3 * 10 ^ 5! Then GoTo 1166
If TM > 6 * 10 ^ 4! Then GoTo 1167
If TM > 1.2 * 10 ^ 4! Then GoTo 1168
If TM > 8 * 10 ^ 3! Then GoTo 1169

1160 g = 1.66667
GoTo 1170
1161 g = 0.0053 * Log(TeV) / Log(10) + 1.631
GoTo 1170
1162 g = 0.063 * Log(TeV) / Log(10) + 1.342
GoTo 1170
1163 g = 0.166 * Log(TeV) / Log(10) + 0.936
GoTo 1170
1164 g = 0.096 * Log(TeV) / Log(10) + 1.163
GoTo 1170
1165 g = 0.1775 * Log(TeV) / Log(10) + 0.9404
GoTo 1170
1166 g = 1.27
GoTo 1170
1167 g = 0.122 * Log(TeV) / Log(10) + 1.093
GoTo 1170
1168 g = 1.17
GoTo 1170
1169 g = -2.624 * Log(TeV) / Log(10) + 1.229

Rem Table for Z for Xenon, pre-calculated from Corona Model

1170 If TM > 9 * 10 ^ 10! Then GoTo 1171
 If TM > 2.85 * 10 ^ 8! Then GoTo 1172
 If TM > 8.8 * 10 ^ 7! Then GoTo 1173
 If TM > 2.11 * 10 ^ 7! Then GoTo 1174
 If TM > 5.68 * 10 ^ 6! Then GoTo 1175
 If TM > 3.35 * 10 ^ 6! Then GoTo 1176
 If TM > 2.37 * 10 ^ 5! Then GoTo 1177
 If TM > 10000! Then GoTo 1178
GoTo 1179

1171 z = 54
GoTo 1180
1172 z = 1.06 * Log(TeV) / Log(10) + 46.4
GoTo 1180
1173 z = 10.72 * Log(TeV) / Log(10) + 3.99
GoTo 1180
1174 z = 5.266 * Log(TeV) / Log(10) + 25.3
GoTo 1180
1175 z = 25.23 * Log(TeV) / Log(10) - 40
GoTo 1180
1176 z = 9.53 * Log(TeV) / Log(10) + 2.326
GoTo 1180
1177 z = 15.39 * Log(TeV) / Log(10) - 12.1
GoTo 1180
1178 z = 5.8 * Log(TeV) / Log(10) + 0.466
GoTo 1180
1179 z = 0

1180 G1 = 2 / (g + 1)
G2 = (g - 1) / g
If FLAG = 10 Then GoTo 3030

GoTo 2000

Rem For N2 compute specific heat ratio g and effective charge z using polynomials fitted from Corona model
1185 If zFLAG = 1 Then z = 7: GoTo 1186
z = -0.5681 * ((Log(TeV) / Log(10)) ^ 6) + 4.2149 * ((Log(TeV) / Log(10)) ^ 5) - 10.771 * ((Log(TeV) / Log(10)) ^ 4) + 10.307 * ((Log(TeV) / Log(10)) ^ 3) - 1.9463 * ((Log(TeV) / Log(10)) ^ 2) + 2.2765 * (Log(TeV) / Log(10)) + 0.2025
If z > 7 Then z = 7: zFLAG = 1
1186 If gFLAG = 1 Then g = 1.6667: GoTo 1187
If g > 1.6667 Then g = 1.6667: gFLAG = 1
g = 0.0869 * ((Log(TeV) / Log(10)) ^ 6) - 0.7726 * ((Log(TeV) / Log(10)) ^ 5) + 2.6889 * ((Log(TeV) / Log(10)) ^ 4) - 4.6815 * ((Log(TeV) / Log(10)) ^ 3) + 4.3215 * ((Log(TeV) / Log(10)) ^ 2) - 1.8471 * ((Log(TeV) / Log(10))) + 1.4399
1187 G1 = 2 / (g + 1)
G2 = (g - 1) / g
If FLAG = 10 Then GoTo 3030

GoTo 2000

Rem For Krypton compute specific heat ratio g and effective charge z using polynomials fitted from Corona model
1190 If zFLAG = 1 Then z = 36: GoTo 1191
z = -0.0347 * ((Log(TeV) / Log(10)) ^ 6) + 0.6605 * ((Log(TeV) / Log(10)) ^ 5) - 4.5854 * ((Log(TeV) / Log(10)) ^ 4) + 13.565 * ((Log(TeV) / Log(10)) ^ 3) - 14.619 * ((Log(TeV) / Log(10)) ^ 2) + 9.9659 * (Log(TeV) / Log(10)) - 0.2588
If z > 36 Then z = 36: zFLAG = 1
1191 If gFLAG = 1 Then g = 1.6667: GoTo 1192
g = 0.0014 * ((Log(TeV) / Log(10)) ^ 6) - 0.0249 * ((Log(TeV) / Log(10)) ^ 5) + 0.1751 * ((Log(TeV) / Log(10)) ^ 4) - 0.6051 * ((Log(TeV) / Log(10)) ^ 3) + 1.0754 * ((Log(TeV) / Log(10)) ^ 2) - 0.7905 * ((Log(TeV) / Log(10))) + 1.3541
If g > 1.6667 Then g = 1.6667: gFLAG = 1

1192 G1 = 2 / (g + 1)
G2 = (g - 1) / g
If FLAG = 10 Then GoTo 3030

GoTo 2000
Rem Next compute Axial elongation speed and Piston speed, using 'lookback' values to correct for finite small disturbance speed effect

2000 VZ = -G1 * VS
2010 K1 = KS / KP

2020 E1 = G1 * K1 * VSDELAY

2030 E2 = (1 / g) * (KP / I) * (1 - K1 * K1) * II
2032 E3 = (G1 / 2) * (KP / ZF) * (1 - K1 * K1) * VZ
2036 E4 = G2 + (1 / g) * K1 * K1
2038 VP = (E1 - E2 - E3) / E4

If TAPER = 0 Then GoTo 2080

V = (BE * tc5 - BF * (Log(KP / c2)) * ZF) * II - I * (BF * (ZF / KP) * VP + (BF * (Log(KP / c2))) * VZ)
II = (1 - IO + BF * I * (ZF / KP) * VP + BF * (Log(KP / c2)) * I * VZ - RESF * I) / (1 + BE * tc5 - BF * (Log(KP / c2)) * ZF)

GoTo 2090
2080 V = (BE - BF * (Log(KP / C)) * ZF) * II - I * (BF * (ZF / KP) * VP + (BF * (Log(KP / C))) * VZ)
II = (1 - IO + BF * I * (ZF / KP) * VP + BF * (Log(KP / C)) * I * VZ - RESF * I) / (1 + BE - BF * (Log(KP / C)) * ZF)

Rem Increment time and Integrate, by linear approx, for I, flowed charge I0, KS, KP and ZF

2090 T = T + d
2120 I = I + II * d
2125 IO = IO + I * d
2130 KS = KS + VS * d
2140 KP = KP + VP * d
2150 ZF = ZF + VZ * d

2190 Rem * Re-scales speeds, distances and time to real, convenient units

If TAPER = 0 Then GoTo 2210
 SSR = VS * (ENDRAD / T0) * 10 ^ -4
 SPR = VP * (ENDRAD / T0) * 10 ^ -4
 SZR = VZ * (ENDRAD / T0) * 10 ^ -4

 KSR = KS * ENDRAD * 1000
 kpr = KP * ENDRAD * 1000
 zfr = ZF * ENDRAD * 1000
GoTo 2250

2210 SSR = VS * (RADA / T0) * 10 ^ -4
2220 SPR = VP * (RADA / T0) * 10 ^ -4
2230 SZR = VZ * (RADA / T0) * 10 ^ -4
2238 KSR = KS * RADA * 1000
2239 kpr = KP * RADA * 1000
2240 zfr = ZF * RADA * 1000

2250 TR = T * T0 * 10 ^ 6
 VR = V * V0 * 10 ^ -3
 IR = I * I0 * 10 ^ -3
 IIR = (II * I0 / T0) * 10 ^ -9
Rem DR is time increment in secs, DKPR is piston position increment & DZFR length position increment, both in SI units
DR = d * T0
DKPR = SPR * DR * 10 ^ 4
DZFR = SZR * DR * 10 ^ 4
If IR > Ipeak Then Ipeak = IR

Rem Obtain Max induced voltage
If VR > VRMAX Then VRMAX = VR
TRRadial = TR * (10 ^ 3) - trradialstart * (10 ^ 9)

If SSR < peakvs Then peakvs = SSR
If SPR < peakvp Then peakvp = SPR

Rem Integrate to find EINP, energy dissipated by dynamic resistance effect, which is 0.5 (Ldot) I^2, considering current taking part in the motion
EINP = EINP + (10 ^ 3) * (SZR * Log(1000 * RADB / kpr) - (SPR * (zfr / kpr))) * IR * IR * CURRF * CURRF * DR
Rem Also integrate for piston work
Wpiston = Wpiston + 0.1 * (DZFR * Log(1000 * RADB / kpr) - DKPR * (zfr / kpr)) * IR * IR * CURRF * CURRF
Lplasma = Laxial + (zfr * 2 * (10 ^ -1) * Log(1000 * RADB / kpr))
Einductance = 0.5 * 10 ^ 6 * IR * IR * (CURRF * CURRF * Lplasma * (10 ^ -9) + L0)
ni = massfr * N0 * ((g + 1) / (g - 1))
nimax = N0 * ((g + 1) / (g - 1))
Rem Write, in EXCEL Sheet, the data for the step-by-step integration

ActiveSheet.Cells(rowj, 1) = TR
ActiveSheet.Cells(rowj, 2) = IR
ActiveSheet.Cells(rowj, 3) = VR
ActiveSheet.Cells(rowj, 52) = TR
ActiveSheet.Cells(rowj, 53) = IR * CURRF
ActiveSheet.Cells(rowj, 54) = KSR
ActiveSheet.Cells(rowj, 55) = kpr
ActiveSheet.Cells(rowj, 56) = zfr
ActiveSheet.Cells(rowj, 57) = SSR
ActiveSheet.Cells(rowj, 58) = SPR
ActiveSheet.Cells(rowj, 59) = SZR
ActiveSheet.Cells(rowj, 61) = Lplasma
ActiveSheet.Cells(rowj, 62) = 100 * Einductance / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 63) = 100 * EINP / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 64) = ni / (10 ^ 23)
ActiveSheet.Cells(rowj, 65) = TM / (10 ^ 6)
ActiveSheet.Cells(rowj, 67) = nimax / (10 ^ 23)
ActiveSheet.Cells(rowj, 69) = 100 * Wpiston / (0.5 * C0 * V0 * V0)
Rem testing
ActiveSheet.Cells(rowj, 70) = SZR
ActiveSheet.Cells(rowj, 71) = DR
ActiveSheet.Cells(rowj, 72) = DZFR
ActiveSheet.Cells(rowj, 74) = -SPR * DR
ActiveSheet.Cells(rowj, 75) = DKPR

ActiveSheet.Cells(rowi, 6) = TR
ActiveSheet.Cells(rowi, 7) = TRRadial
ActiveSheet.Cells(rowi, 8) = IR
ActiveSheet.Cells(rowi, 9) = VR
ActiveSheet.Cells(rowi, 10) = KSR
ActiveSheet.Cells(rowi, 11) = kpr
ActiveSheet.Cells(rowi, 12) = zfr
ActiveSheet.Cells(rowi, 13) = SSR
ActiveSheet.Cells(rowi, 14) = SPR
ActiveSheet.Cells(rowi, 15) = SZR
ActiveSheet.Cells(rowi, 17) = TM
ActiveSheet.Cells(rowi, 32) = g
ActiveSheet.Cells(rowi, 33) = z
ActiveSheet.Cells(rowi, 41) = EINP

rowi = rowi + 1
rowj = rowj + 1

Rem To apply finite small disturbance speed correction. Compute propagation time and the 'lookback' row number

If KSR > kpr Then GoTo 2300
SDSPEED = Sqr(g * dissociatenumber * (1 + z) * bc * TM / (MW * mi))
SDDELAYTIME = ((kpr - KSR) / 1000) / SDSPEED
backhowmanyrows = SDDELAYTIME / DR
BACKROWNUMBER = rowi - backhowmanyrows
If BACKROWNUMBER < FIRSTRADIALROW Then BACKROWNUMBER = FIRSTRADIALROW + 1
delayrow = BACKROWNUMBER - 1
If delayrow < 20 Then delayrow = 20

Rem Look back to appropriate row to obtain 'lookback' quantities; also non-dimensionalize these quantities

IDELAY = ActiveSheet.Cells(delayrow, 8) / (I0 * 10 ^ -3)
KPDELAY = ActiveSheet.Cells(delayrow, 11) / (RADA * 1000)
VSDELAY = ActiveSheet.Cells(delayrow, 13) / ((RADA / T0) * 10 ^ -4)
KSDELAY = ActiveSheet.Cells(delayrow, 10) / (RADA * 1000)

GoTo 2314

Rem In case 'lookback' row number falls outside range of radial phase data table

2300 IDELAY = I
KPDELAY = KP
VSDELAY = VS
KSDELAY = KS

Rem Check whether inward shock front has reached axia

2314 If KS > 0 Then GoTo 980

Rem Inward shock front has reached axis, we have exited from Radial Inward Phase and now go on to the Reflected Shock Phase
Rem Put ni1 as the last average ion density on axis before reflected shock starts; nimax1 as last shocked density before RS starts
ni1 = ni
nimax1 = nimax
PLN = 0
2350 Rem "Part 3 starts : Radial reflected shock phase"

2360 Debug.Print "Part 3 starts : Radial reflected shock phase"

ActiveSheet.Cells(11, 10) = (TRRadial * 10 ^ -3 - trradialstart) * 10 ^ 3

Rem Reflected Shock Phase is computed in SI units.
Rem Convert initial values of RS Phase into SI units

If TAPER = 0 Then GoTo 2500

 VS = VS * ENDRAD / T0
 RS = KS * ENDRAD
 rp = KP * ENDRAD
 ZF = ZF * ENDRAD
 VZ = VZ * ENDRAD / T0
 VP = VP * ENDRAD / T0
GoTo 2510

2500 VS = VS * RADA / T0
 RS = KS * RADA
 rp = KP * RADA
 ZF = ZF * RADA
 VZ = VZ * RADA / T0
 VP = VP * RADA / T0

2510 T = T * T0
 d = d * T0
 I = I * I0
 CH = IO * I0 * T0
 IDOT = II * I0 / T0

2800 Rem VRF is reflected shock speed taken as a constant value at 0.3 of on-axis forward shock speed
Rem Take strong planar shock approximation (Ref: Robert Gross: The Physics of Strong Shock Waves in Gases 1969, manuscript for Procs of International School of Physics "Enrico Fermi" Course XLVIII, High Energy Density, Varenna, Italy; Academic Press.)
Rem However we take RS speed as 0.3 of incident shock speed instead of 0.5 [for planar strong shock]as in R Gross; in order to account for diverging radial geometry
gratio = (g + 1) / (g - 1)
Pratio = 2 + gratio
Tratio = Pratio * ((gratio + Pratio) / (1 + gratio * Pratio))
Dratio = Pratio / Tratio
TMRS = TM * Tratio
TMmax = TMRS
TeV = TMRS / (1.16 * 10 ^ 4)
Rem FLAG=10 indicates computation is in RS phase; allows routing to earlier tables for g and z; but after getting g and z routes back to RS phase.
FLAG = 10
GoTo 1005
3030 RRF = 0
FRF = 0.33
3040 VSV = VS

3050 VRF = -FRF * VS
3055 G1 = 2 / (g + 1)
3056 G2 = (g - 1) / g
3057 MUP = MU / (2 * Pi)
3060 VZ = -G1 * VS
Rem Introduce differential in current factors for axial and radial phases; already introduced earlier around 815
Rem CURRF = CURRF * CFR

3080 T = T + d

3100 RRF = RRF + VRF * d
3105 VRFCMUS = VRF * 10 ^ -4

3110 K1 = 0
3120 E1 = G1 * K1 * VSV
3130 E2 = (1 / g) * (rp / I) * (1 - K1 * K1) * IDOT
3140 E3 = (G1 / 2) * (rp / ZF) * (1 - K1 * K1) * VZ
3150 E4 = G2 + (1 / g) * K1 * K1

3170 VP = (E1 - E2 - E3) / E4
3180 IDOT = (V0 - (CH / C0) - I * R0 - I * CURRF * MUP * ((Log(RADB / rp)) * VZ - (ZF / rp) * VP)) / (L0 + MUP * CURRF * ((Log(C)) * Z0 * tc5 + (Log(RADB / rp)) * ZF))

3185 V = MUP * I * ((Log(RADB / rp)) * VZ - (ZF / rp) * VP) + MUP * ((Log(RADB / rp)) * ZF + (Log(C)) * Z0 * tc5) * IDOT
3186 V = V * CURRF
3210 I = I + IDOT * d
3220 CH = CH + I * d
3230 rp = rp + VP * d
3240 ZF = ZF + VZ * d

Rem D is time increment in secs, DKPR is piston position increment & DZFR length position increment, both in SI units

DKPR = SPR * d * 10 ^ 4
DZFR = SZR * d * 10 ^ 4
If IR > Ipeak Then Ipeak = IR

Rem Obtain Max induced voltage
If VR > VRMAX Then VRMAX = VR
TRRadial = TR * (10 ^ 3) - trradialstart * (10 ^ 9)

If SSR < peakvs Then peakvs = SSR
If SPR < peakvp Then peakvp = SPR


Rem Convert to Real convenient units for print out
3470 TR = T * 10 ^ 6
3472 VR = V * 10 ^ -3
3474 IR = I * 10 ^ -3
3476 kpr = rp * 10 ^ 3
3478 zfr = ZF * 10 ^ 3
3480 SPR = VP * 10 ^ -4
3482 SZR = VZ * 10 ^ -4
3484 IDOTKAUS = IDOT * 10 ^ -9
3486 RRFMM = RRF * 10 ^ 3
TRRadial = TR * 10 ^ 3 - trradialstart * (10 ^ 9)
Rem Integrate to find EINP, energy dissipated by dynamic resistance effect, which is 0.5 (Ldot) I^2, considering current taking part in the motion
EINP = EINP + (10 ^ -7) * (SZR * (10 ^ 4) * Log(1000 * RADB / kpr) - (SPR * (10 ^ 4) * (1000 / kpr) * (zfr / 1000))) * IR * IR * (10 ^ 6) * CURRF * CURRF * d
Rem Also integrate for piston work
Wpiston = Wpiston + 0.1 * (DZFR * Log(1000 * RADB / kpr) - DKPR * (zfr / kpr)) * IR * IR * CURRF * CURRF
If IR > Ipeak Then Ipeak = IR
Rem Determine max induced voltage for beam-gas neutron yield computation
If VR > VRMAX Then VRMAX = VR
Lplasma = Laxial + (zfr * 2 * (10 ^ -1) * Log(1000 * RADB / kpr))
Einductance = 0.5 * 10 ^ 6 * IR * IR * (CURRF * CURRF * Lplasma * (10 ^ -9) + L0)
Rem use Dratio from RS of strong shocks as described above
ni = ni1 * Dratio
nimax = nimax1 * Dratio
ActiveSheet.Cells(rowj, 1) = TR
ActiveSheet.Cells(rowj, 2) = IR
ActiveSheet.Cells(rowj, 3) = VR
ActiveSheet.Cells(rowj, 52) = TR
ActiveSheet.Cells(rowj, 53) = IR * CURRF
ActiveSheet.Cells(rowj, 55) = kpr
ActiveSheet.Cells(rowj, 56) = zfr
ActiveSheet.Cells(rowj, 58) = SPR
ActiveSheet.Cells(rowj, 59) = SZR
ActiveSheet.Cells(rowj, 60) = RRFMM
ActiveSheet.Cells(rowj, 61) = Lplasma
ActiveSheet.Cells(rowj, 62) = 100 * Einductance / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 63) = 100 * EINP / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 64) = ni / (10 ^ 23)
ActiveSheet.Cells(rowj, 65) = TMRS / (10 ^ 6)
ActiveSheet.Cells(rowj, 66) = -PLN
ActiveSheet.Cells(rowj, 67) = nimax / (10 ^ 23)
ActiveSheet.Cells(rowj, 68) = TMmax / (10 ^ 6)
ActiveSheet.Cells(rowj, 69) = 100 * Wpiston / (0.5 * C0 * V0 * V0)

ActiveSheet.Cells(rowi, 6) = TR
ActiveSheet.Cells(rowi, 7) = TRRadial
ActiveSheet.Cells(rowi, 8) = IR
ActiveSheet.Cells(rowi, 9) = VR
ActiveSheet.Cells(rowi, 11) = kpr
ActiveSheet.Cells(rowi, 12) = zfr
ActiveSheet.Cells(rowi, 14) = SPR
ActiveSheet.Cells(rowi, 15) = SZR
ActiveSheet.Cells(rowi, 16) = RRFMM
ActiveSheet.Cells(rowi, 17) = TMRS
ActiveSheet.Cells(rowi, 32) = g
ActiveSheet.Cells(rowi, 33) = z

ActiveSheet.Cells(rowi, 41) = EINP

rowi = rowi + 1
rowj = rowj + 1

3500 If RRF > rp Then GoTo 3990

3600 GoTo 3080

3990 Rem "RS HAS HIT PISTON. RS PHASE ENDS"
FLAG = 0
NBN = 0
NTN = 0
NN = 0
PLN = 0
3995 Debug.Print "RS HAS HIT PISTON. RS PHASE ENDS"
3998 Debug.Print "Part 4 starts: Radiative Phase"

4000 Rem "Part 4 starts: Radiative Phase"
Rem Radiative Phase is integrated in real quantities

Rem As RS hits piston, the pressure exerted by the doubly shocked column on the piston shoots up by a factor of Pratio; this will slow the piston down further or even push it back. Thie effect is included in the following section.
Rem However, in reality, due to 2-D effect, the over-pressure may not be significant.
sflag1 = 0
sflag2 = 0
sflag3 = 0
RPSTART = rp
TeVSTART = TeV
SDSPEEDSTART = ((g * dissociatenumber * (1 + z) * bc * TM / (MW * mi))) ^ 0.5
TRAD1 = 0.5 * RPSTART / SDSPEEDSTART
TRAD1 = 2 * TRAD1
d = DREAL / 10 ^ 8

4002 TStart = T
Ipinch = I * CURRF / 1000

amin = kpr
zmax = 0
Tpinch = 0
nipinch = 0
Tpinchmin = 10 ^ 9


Rem Select Table for G & Z; according to which gas is used

4100 If ZN = 1 Then GoTo 4300
If ZN = 2 Then GoTo 4300

If ZN = 7 Then GoTo 4210
If ZN = 10 Then GoTo 4110
If ZN = 18 Then GoTo 4150
If ZN = 36 Then GoTo 4250
If ZN = 54 Then GoTo 4180

Rem Table for G for Neon
4110 If TM > 10 ^ 8! Then GoTo 4120
4112 If TM > 2 * 10 ^ 7! Then GoTo 4122
4114 If TM > 4.5 * 10 ^ 6! Then GoTo 4124
4116 If TM > 2.3 * 10 ^ 6! Then GoTo 4126
4118 If TM > 3.4 * 10 ^ 5! Then GoTo 4127
If TM > 2.4 * 10 ^ 4! Then GoTo 4128
If TM > 1.5 * 10 ^ 4! Then GoTo 4129

g = 1.6667
GoTo 4135
4120 g = 1.66667
GoTo 4135
4122 g = 1.6 + 0.83 * (10 ^ -9) * (TM - 2 * 10 ^ 7)
GoTo 4135
4124 g = 1.47 + 0.84 * (10 ^ -8) * (TM - 4.5 * 10 ^ 6)
GoTo 4135
4126 g = 1.485
GoTo 4135
4127 g = 1.23 + 1.2 * (10 ^ -7) * (TM - 3.4 * 10 ^ 5)
GoTo 4135
4128 g = 1.18
GoTo 4135
4129 g = 1.667 - 5.4E-05 * (TM - 15000)

Rem Table for Z for Neon
4135 If TM > 7 * 10 ^ 6! Then GoTo 4140
 If TM > 2.3 * 10 ^ 6! Then GoTo 4143
 If TM > 4.5 * 10 ^ 5! Then GoTo 4146
 If TM > 4.5 * 10 ^ 4! Then GoTo 4147
If TM > 15000! Then GoTo 4148

z = 0
GoTo 4300

4140 z = 10
GoTo 4300
4143 z = 8 + 0.4255 * (10 ^ -6) * (TM - 2.3 * 10 ^ 6)
GoTo 4300
4146 z = 8
GoTo 4300
4147 z = 1.9 + 1.5 * (10 ^ -5) * (TM - 4.5 * 10 ^ 4)
GoTo 4300
4148 z = 6.3E-05 * (TM - 15000)
GoTo 4300

Rem Table of G for ARGON
4150 If TM > 1.5 * 10 ^ 8! Then GoTo 4160
If TM > 1.2 * 10 ^ 7! Then GoTo 4161
If TM > 1.9 * 10 ^ 6! Then GoTo 4162
If TM > 9.3 * 10 ^ 5! Then GoTo 4163
If TM > 5.7 * 10 ^ 5! Then GoTo 4164
If TM > 10 ^ 5! Then GoTo 4165

4160 g = 1.66667
GoTo 4170
4161 g = 1.54 + 9 * (10 ^ -10) * (TM - 1.2 * 10 ^ 7)
GoTo 4170
4162 g = 1.31 + 2.6 * (10 ^ -8) * (TM - 1.9 * 10 ^ 6)
GoTo 4170
4163 g = 1.3
GoTo 4170
4164 g = 1.34 - 1.6 * (10 ^ -7) * (TM - 5.7 * 10 ^ 5)
GoTo 4170
4165 g = 1.17 + 3.8 * (10 ^ -7) * (TM - 10 ^ 5)

Rem Table for Z for Argon
4170 If TM > 1.3 * 10 ^ 8! Then GoTo 4171
 If TM > 1.3 * 10 ^ 7! Then GoTo 4172
 If TM > 3.5 * 10 ^ 6! Then GoTo 4174
 If TM > 4.7 * 10 ^ 5! Then GoTo 4175
 If TM > 2 * 10 ^ 5! Then GoTo 4176
 If TM > 3.5 * 10 ^ 4! Then GoTo 4177

z = 0
GoTo 4300

4171 z = 18
GoTo 4300
4172 z = 16 + 1.8 * (10 ^ -8) * (TM - 1.3 * 10 ^ 7)
GoTo 4300
4174 z = 16
GoTo 4300
4175 z = 8 + 2.9 * (10 ^ -6) * (TM - 4.7 * 10 ^ 5)
GoTo 4300
4176 z = 8
GoTo 4300
4177 z = 2.2 + 3.5 * (10 ^ -5) * (TM - 3.5 * 10 ^ 4)
GoTo 4300

Rem Table of G for Xenon; pre-calculated from Corona Model
4180 If TM > 9 * 10 ^ 10! Then GoTo 4181
If TM > 1.16 * 10 ^ 9! Then GoTo 4182
If TM > 1.01 * 10 ^ 8! Then GoTo 4183
If TM > 2.02 * 10 ^ 7! Then GoTo 4184
If TM > 6.23 * 10 ^ 6! Then GoTo 4185
If TM > 9.4 * 10 ^ 5! Then GoTo 4186
If TM > 3.3 * 10 ^ 5! Then GoTo 4187
If TM > 6 * 10 ^ 4! Then GoTo 4188
If TM > 1.2 * 10 ^ 4! Then GoTo 4189
If TM > 8 * 10 ^ 3! Then GoTo 4190

4181 g = 1.66667
GoTo 4191
4182 g = 0.0053 * Log(TeV) / Log(10) + 1.631
GoTo 4191
4183 g = 0.063 * Log(TeV) / Log(10) + 1.342
GoTo 4191
4184 g = 0.166 * Log(TeV) / Log(10) + 0.936
GoTo 4191
4185 g = 0.096 * Log(TeV) / Log(10) + 1.163
GoTo 4191
4186 g = 0.1775 * Log(TeV) / Log(10) + 0.9404
GoTo 4191
4187 g = 1.27
GoTo 4191
4188 g = 0.122 * Log(TeV) / Log(10) + 1.093
GoTo 4191
4189 g = 1.17
GoTo 4191
4190 g = -2.624 * Log(TeV) / Log(10) + 1.229

Rem Table for Z for Xenon, pre-calculated from Corona Model

4191 If TM > 9 * 10 ^ 10! Then GoTo 4192
 If TM > 2.85 * 10 ^ 8! Then GoTo 4193
 If TM > 8.8 * 10 ^ 7! Then GoTo 4194
 If TM > 2.11 * 10 ^ 7! Then GoTo 4195
 If TM > 5.68 * 10 ^ 6! Then GoTo 4196
 If TM > 3.35 * 10 ^ 6! Then GoTo 4197
 If TM > 2.37 * 10 ^ 5! Then GoTo 4198
 If TM > 10000! Then GoTo 4199

z = 0
GoTo 4300

4192 z = 54
GoTo 4300
4193 z = 1.06 * Log(TeV) / Log(10) + 46.4
GoTo 4300
4194 z = 10.72 * Log(TeV) / Log(10) + 3.99
GoTo 4300
4195 z = 5.266 * Log(TeV) / Log(10) + 25.3
GoTo 4300
4196 z = 25.23 * Log(TeV) / Log(10) - 40
GoTo 4300
4197 z = 9.53 * Log(TeV) / Log(10) + 2.326
GoTo 4300
4198 z = 15.39 * Log(TeV) / Log(10) - 12.1
GoTo 4300
4199 z = 5.8 * Log(TeV) / Log(10) + 0.466
GoTo 4300
4200 z = 0
GoTo 4300

Rem For N2 Compute specific heat ratio g and effective charge z using polynomials fitted from Corona model
4210 If zFLAG = 1 Then z = 7: GoTo 4211
z = -0.5681 * ((Log(TeV) / Log(10)) ^ 6) + 4.2149 * ((Log(TeV) / Log(10)) ^ 5) - 10.771 * ((Log(TeV) / Log(10)) ^ 4) + 10.307 * ((Log(TeV) / Log(10)) ^ 3) - 1.9463 * ((Log(TeV) / Log(10)) ^ 2) + 2.2765 * (Log(TeV) / Log(10)) + 0.2025
If z > 7 Then z = 7: zFLAG = 1
4211 If gFLAG = 1 Then g = 1.6667: GoTo 4212
g = 0.0869 * ((Log(TeV) / Log(10)) ^ 6) - 0.7726 * ((Log(TeV) / Log(10)) ^ 5) + 2.6889 * ((Log(TeV) / Log(10)) ^ 4) - 4.6815 * ((Log(TeV) / Log(10)) ^ 3) + 4.3215 * ((Log(TeV) / Log(10)) ^ 2) - 1.8471 * ((Log(TeV) / Log(10))) + 1.4399
If g > 1.6667 Then g = 1.6667: gFLAG = 1
4212 GoTo 4300

Rem For Krypton compute specific heat ratio g and effective charge z using polynomials fitted from Corona model
4250 If zFLAG = 1 Then z = 36: GoTo 4251
z = -0.0347 * ((Log(TeV) / Log(10)) ^ 6) + 0.6605 * ((Log(TeV) / Log(10)) ^ 5) - 4.5854 * ((Log(TeV) / Log(10)) ^ 4) + 13.565 * ((Log(TeV) / Log(10)) ^ 3) - 14.619 * ((Log(TeV) / Log(10)) ^ 2) + 9.9659 * (Log(TeV) / Log(10)) - 0.2588
If z > 36 Then z = 36: zFLAG = 1
4251 If gFLAG = 1 Then g = 1.6667: GoTo 4252
g = 0.0014 * ((Log(TeV) / Log(10)) ^ 6) - 0.0249 * ((Log(TeV) / Log(10)) ^ 5) + 0.1751 * ((Log(TeV) / Log(10)) ^ 4) - 0.6051 * ((Log(TeV) / Log(10)) ^ 3) + 1.0754 * ((Log(TeV) / Log(10)) ^ 2) - 0.7905 * ((Log(TeV) / Log(10))) + 1.3541
If g > 1.6667 Then g = 1.6667: gFLAG = 1
4252 GoTo 4300

4300 G1 = 2 / (g + 1)
G2 = (g - 1) / g

Rem Compute Joule heating and radiation terms
If TAPER = 0 Then GoTo 4400
 ni = N0 * fe * massfr * (ENDRAD / rp) * (RADA / rp)
Rem DNchange
 TM = MUK * I * I * CURRF * CURRF / ((1 + z) * N0 * ENDRAD * ENDRAD * fe * massfr)
GoTo 4560
4400 ni = N0 * fe * massfr * (RADA / rp) * (RADA / rp)
Rem DNchange
4550 TM = MUK * I * I * CURRF * CURRF / ((1 + z) * N0 * RADA * RADA * fe * massfr)

4560 TeV = TM / (1.16 * 10 ^ 4)
4570 R = 1290 * z * ZF / (Pi * rp * rp * (TM ^ 1.5))

4600 PJ = R * I * I * CURRF * CURRF
 PBR = -(CON11 * ni) * (TM ^ 0.5) * (CON12 * ni) * Pi * (rp * rp) * ZF * (z ^ 3)
 PREC = -5.92 * (10 ^ -35) * ni * ni * (z ^ 5) * Pi * (rp * rp) * ZF / (TM ^ 0.5)
 PLN = -(CON2 * ni) * ni * z * (ZN ^ 4) * Pi * (rp * rp) * ZF / TM

Rem Apply Plasma Self Absorption correction to PBR PREC and PLN:
Rem PM is photonic excitation number; AB is absorption corrected factor
Rem If AB<1/2.7183, Radiation goes from volume-like PRAD to surface-like PRADS; PRADS has a limit being Blackbody Rad PBB
Rem We consider only volume (absorption corrected) radiation for PBR PREC and PLINE and PSXR; not including any contribution from surface radiation.
PM = 1.66 * (10 ^ -11) * (rp * 100) * (ZN ^ 0.5) * (ni * (10 ^ -6)) / (z * (TeV ^ 1.5))

AB = 1 + (((10 ^ -14) * (ni * (10 ^ -6)) * z) / (TeV ^ 3.5))
AB = 1 / AB
AB = AB ^ (1 + PM)

Rem PBR = AB * PBR
Rem PREC = AB * PREC
Rem PLN = AB * PLN

PRADS = -2.3 * (10 ^ -15) * (ZN ^ 3.5) * (z ^ 0.5) * (TM ^ 4) * 3.142 * rp * (2 * ZF)
Rem calibration factor for neon (NX2); got to check for other machines and gases that at cross-over point from volume to surface emission there is a smooth transition in power.
PRADS = 0.032 * PRADS
PBB = -5.7 * (10 ^ -8) * (TM ^ 4) * (3.142 * rp * (2 * ZF + rp))

4615 If ZN = 1 Then GoTo 4621
If ZN = 2 Then GoTo 4700

If ZN = 7 Then GoTo 4700
If ZN = 10 Then GoTo 4700
If ZN = 18 Then GoTo 4700
If ZN = 36 Then GoTo 4700
If ZN = 54 Then GoTo 4700

4621 If MW = 2 Then GoTo 4700
If MW = 5 Then GoTo 4650
Rem For deuterium, compute 1. thermonuclear neutron yield component: SIGV computed in m3sec-1
If TeV < 100 Then GoTo 4623
If TeV = 100 Then GoTo 4623
If TeV > 10 ^ 4 Then GoTo 4624
If TeV > 10 ^ 3 Then GoTo 4625
If TeV > 500 Then GoTo 4626
If TeV > 100 Then GoTo 4627

4623 SIGV = 0: GoTo 4700
4624 SIGV = 2.4 * (10 ^ -26) * (TeV / 1000) ^ 1.55: GoTo 4660
4625 SIGV = 2 * (10 ^ -28) * (TeV / 1000) ^ 3.63: GoTo 4660
4626 SIGV = 2 * (10 ^ -28) * (TeV / 1000) ^ 7.7: GoTo 4660
4627 SIGV = (10 ^ -27) * (TeV / 1000) ^ 10: GoTo 4660
GoTo 4660

Rem for D-T (50:50), compute 1. thermonuclear neutron yield component; SIGV computed in m3sec-1
4650 SIGV = 3.68 * (10 ^ -18) * (Exp(-19.94 * (TeV / 1000) ^ -(1 / 3))) * (TeV / 1000) ^ -(2 / 3)


4660 NTNDOT = 0.5 * ni * ni * 3.142 * (rp * rp) * ZF * SIGV
NTN = NTN + NTNDOT * d

Rem Calculate rate of net power emission, absorption-corrected
4700 PRAD = (PBR + PLN + PREC) * AB

ActiveSheet.Cells(rowi, 38) = PRAD
If sflag1 = 1 Then GoTo 4720
sflag1 = 1
If AB > 1 / 2.7183 Then GoTo 4750
sfactor = 1
sflag2 = 1
GoTo 4740
4720 If sflag2 = 1 Then GoTo 4740
4730 If sflag3 = 1 Then GoTo 4740

If AB > 1 / 2.7183 Then GoTo 4750
sfactor = PRAD / PRADS
sflag3 = 1

4740 PRADS = sfactor * PRADS
PRAD = PRADS

4745 If -PRAD > -PBB Then PRAD = PBB

4750 QDOT = PJ + PRAD

Rem Compute slow piston speed

4800 E2 = (1 / g) * (rp / I) * IDOT
4810 E3 = (1 / (g + 1)) * (rp / ZF) * VZ

Rem E5 term in VP (related to dQ/dt) not corrected.

correctfactor = (1 + z) * ni * bc
correctfactor = 1
4820 E5 = (4 * Pi * (g - 1) / (MU * g * ZF)) * ((rp * correctfactor) / (I * I * CURRF * CURRF)) * QDOT
4830 E4 = (g - 1) / g
4850 VP = (-E2 - E3 + E5) / E4

4860 IDOT1 = V0 - CH / C0
4870 IDOT2 = -MUP * (Log(RADB / rp)) * VZ * I * CURRF
4890 IDOT3 = MUP * I * ZF * VP * CURRF / rp
4900 IDOT4 = -I * (R * CURRF + R0)

If TAPER = 0 Then GoTo 4920
4910 IDOT5 = L0 + MUP * (Log(C)) * Z0 * CURRF * tc5 + MUP * (Log(RADB / rp)) * ZF * CURRF
GoTo 4925

4920 IDOT5 = L0 + MUP * (Log(C)) * Z0 * CURRF + MUP * (Log(RADB / rp)) * ZF * CURRF

4925 IDOT = (IDOT1 + IDOT2 + IDOT3 + IDOT4) / IDOT5
4950 ZFDOT = (((MU * (g + 1)) / (16 * Pi * Pi * RHO)) ^ 0.5) * I * CURRF / rp
If TAPER = 0 Then GoTo 4970
 V = MUP * I * ((Log(RADB / rp)) * VZ - (ZF / rp) * VP) + MUP * (((Log(RADB / rp)) * ZF) + (Logc) * Z0 * tc5) * IDOT + R * I
GoTo 4980

4970 V = MUP * I * ((Log(RADB / rp)) * VZ - (ZF / rp) * VP) + MUP * (((Log(RADB / rp)) * ZF) + (Logc) * Z0) * IDOT + R * I

4980 V = V * CURRF
5010 T = T + d
5030 I = I + IDOT * d
5035 CH = CH + I * d
rpOLD = rp
rp = rp + VP * d
SPR = -VP * 10 ^ -4
Rem Set Variable time increment to suit both slow and fast piston
If SPR < 10 ^ 2 Then d = DREAL / 5
If SPR = 10 ^ 2 Then d = DREAL / 10
If SPR > 10 ^ 2 Then d = DREAL / 100
If SPR > 10 ^ 3 Then d = DREAL / 10 ^ 4
If SPR > 10 ^ 4 Then d = DREAL / 10 ^ 5
If SPR > 10 ^ 5 Then d = DREAL / 10 ^ 6

If SPR > 10 ^ 6 Then d = DREAL / 10 ^ 7
If SPR > 10 ^ 7 Then d = DREAL / 10 ^ 8
If SPR > 10 ^ 8 Then d = DREAL / 10 ^ 9

Rem Set limit for piston position
Rem DNchange
If TAPER = 0 Then GoTo 5047
Rem DNchange
If rp < 1E-07 * ENDRAD Then ENDFLAG = 1
If ENDFLAG = 1 Then GoTo 7000
GoTo 5050
Rem DNchange
5047 If rp < 1E-08 * RADA Then ENDFLAG = 1
If ENDFLAG = 1 Then GoTo 7000

5050 ZF = ZF + ZFDOT * d

Rem uncorrected for absorption
QJ = QJ + PJ * d
5051 QBR = QBR + PBR * d
QLN1 = QLN
5052 QLN = QLN + PLN * d

Rem for N2 find line radiation within temp range 0.86-2x10^6K; and put as SXR yield
Rem for Neon find line radiation within temp range 2.3-5x10^6K; and put as SXR yield

If ZN = 7 Then GoTo 5053
If ZN = 10 Then GoTo 5060

5053 If TM < 0.86 * 10 ^ 6 Then GoTo 5054
Rem uncorrected for absorption
QSXR = QLN1 + PLN * d
5054 QREC = QREC + PREC * d
Rem Corrected for absorption
5055 Q = Q + QDOT * d
5056 QRAD = (QRAD + PRAD * d)
GoTo 5065

5060 If TM < 2.3 * 10 ^ 6 Then GoTo 5061
Rem uncorrected for absorption
QSXR = QLN1 + PLN * d
5061 QREC = QREC + PREC * d
 Rem Corrected for absorption
 Q = Q + QDOT * d
 QRAD = (QRAD + PRAD * d)
GoTo 5065
Rem estimate proportion of each radiation component using their unabsorbed values:  hence estimate absorption corrected QBR, QLN, QREC; including contribution from surface radiation
Rem uncorrected for absorption
5065 QTOTAL = (QBR + QLN + QREC)
 If -QTOTAL < 1E-06 Then GoTo 5070
rbr = QBR / QTOTAL
rln = QLN / QTOTAL
rrec = QREC / QTOTAL
rsxr = QSXR / QTOTAL
Rem corrected for absorption
QBR = rbr * QRAD
QLN = rln * QRAD
QREC = rrec * QRAD

If ZN = 7 Then GoTo 5066
If ZN = 10 Then GoTo 5067
5066 If TM < 0.86 * 10 ^ 6 Then GoTo 5070
5067 If TM < 2.3 * 10 ^ 6 Then GoTo 5070
QSXR = rsxr * QRAD

5070 TR = T * 10 ^ 6
5072 VR = V * 10 ^ -3
5074 IR = I * 10 ^ -3
5076 kpr = rp * 10 ^ 3
5078 zfr = ZF * 10 ^ 3
5080 SPR = VP * 10 ^ -4
5082 SZR = ZFDOT * 10 ^ -4
5084 IDOTKAUS = IDOT * 10 ^ -9
5110 TMB = TM
TRRadial = TR * 10 ^ 3 - trradialstart * (10 ^ 9)

If IR > Ipeak Then Ipeak = IR
Rem Determine max induced voltage for beam-gas neutron yield computation
If VR > VRMAX Then VRMAX = VR
If kpr < amin Then amin = kpr
If zfr > zmax Then zmax = zfr
If TM > Tpinch Then Tpinch = TM
If ni > nipinch Then nipinch = ni
If TM < Tpinchmin Then Tpinchmin = TM
Rem D is time increment in secs, DKPR is piston position increment & DZFR length position increment, both in SI units
DKPR = SPR * d * 10 ^ 4
DZFR = SZR * d * 10 ^ 4

Rem Integrate to find EINP, energy dissipated by dynamic resistance effect, which is 0.5 (Ldot) I^2, considering current taking part in the motion
EINP = EINP + (10 ^ -7) * (SZR * (10 ^ 4) * Log(1000 * RADB / kpr) - (SPR * (10 ^ 4) * (1000 / kpr) * (zfr / 1000))) * IR * IR * (10 ^ 6) * CURRF * CURRF * d
Rem Also integrate for piston work
Wpiston = Wpiston + 0.1 * (DZFR * Log(1000 * RADB / kpr) - DKPR * (zfr / kpr)) * IR * IR * CURRF * CURRF
Lplasma = Laxial + (zfr * 2 * (10 ^ -1) * Log(1000 * RADB / kpr))
Einductance = 0.5 * 10 ^ 6 * IR * IR * (CURRF * CURRF * Lplasma * (10 ^ -9) + L0)

5120 ActiveSheet.Cells(rowj, 1) = TR
ActiveSheet.Cells(rowj, 2) = IR
ActiveSheet.Cells(rowj, 3) = VR
ActiveSheet.Cells(rowj, 52) = TR
ActiveSheet.Cells(rowj, 53) = IR * CURRF
ActiveSheet.Cells(rowj, 55) = kpr
ActiveSheet.Cells(rowj, 56) = zfr
ActiveSheet.Cells(rowj, 58) = SPR
ActiveSheet.Cells(rowj, 59) = SZR
ActiveSheet.Cells(rowj, 61) = Lplasma
ActiveSheet.Cells(rowj, 62) = 100 * Einductance / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 63) = 100 * EINP / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 64) = ni / (10 ^ 23)
ActiveSheet.Cells(rowj, 65) = TM / (10 ^ 6)
ActiveSheet.Cells(rowj, 66) = -PLN / (10 ^ 9)
ActiveSheet.Cells(rowj, 68) = TMmax / (10 ^ 6)
ActiveSheet.Cells(rowj, 67) = nimax / (10 ^ 23)
ActiveSheet.Cells(rowj, 69) = 100 * Wpiston / (0.5 * C0 * V0 * V0)

ActiveSheet.Cells(rowi, 6) = TR
ActiveSheet.Cells(rowi, 7) = TRRadial
ActiveSheet.Cells(rowi, 8) = IR
ActiveSheet.Cells(rowi, 9) = VR
ActiveSheet.Cells(rowi, 11) = kpr
ActiveSheet.Cells(rowi, 12) = zfr
ActiveSheet.Cells(rowi, 14) = SPR
ActiveSheet.Cells(rowi, 15) = SZR

ActiveSheet.Cells(rowi, 17) = TM
ActiveSheet.Cells(rowi, 18) = PJ
ActiveSheet.Cells(rowi, 19) = PBR
ActiveSheet.Cells(rowi, 20) = PREC
ActiveSheet.Cells(rowi, 21) = PLN
ActiveSheet.Cells(rowi, 22) = PRAD
ActiveSheet.Cells(rowi, 23) = QDOT
ActiveSheet.Cells(rowi, 24) = QJ
ActiveSheet.Cells(rowi, 25) = QBR
ActiveSheet.Cells(rowi, 26) = QREC
ActiveSheet.Cells(rowi, 27) = QLN
ActiveSheet.Cells(rowi, 28) = QRAD
ActiveSheet.Cells(rowi, 29) = Q
ActiveSheet.Cells(rowi, 30) = AB
ActiveSheet.Cells(rowi, 31) = PBB
ActiveSheet.Cells(rowi, 32) = g
ActiveSheet.Cells(rowi, 33) = z
ActiveSheet.Cells(rowi, 34) = NTN
ActiveSheet.Cells(rowi, 35) = NBN
ActiveSheet.Cells(rowi, 36) = NN
ActiveSheet.Cells(rowi, 37) = ni
ActiveSheet.Cells(rowi, 39) = PRADS
ActiveSheet.Cells(rowi, 40) = AB
ActiveSheet.Cells(rowi, 41) = EINP
ActiveSheet.Cells(rowi, 42) = QSXR
ActiveSheet.Cells(rowi, 45) = rbr
ActiveSheet.Cells(rowi, 47) = rln
ActiveSheet.Cells(rowi, 46) = rrec
ActiveSheet.Cells(rowi, 48) = rsxr
ActiveSheet.Cells(rowi, 51) = QTOTAL

rowi = rowi + 1
rowj = rowj + 1


Rem Set limit for duration of radiative phase (1 ns for every mm radius)
Rem TRAD = 1000 * RADA * 10 ^ -9
Rem TRAD2 = (16 * (10 ^ -7)) * (RPSTART * 100) / (TeVSTART ^ 0.5)
Rem Set limit for duration of radiative phase using transit time of small disturbance across pinch radius
TRAD = TRAD1
If T > (TStart + TRAD) Then ENDFLAG = 2

If ENDFLAG = 2 Then GoTo 7000

5350 GoTo 4100

7000 Debug.Print "Slow compression phase stopped either on preset time or on RP limit"

ActiveSheet.Cells(7, 14) = -QLN
EINP1 = EINP
Rem Slow compression Phase Stopped: Time limit or RP limit.
ActiveSheet.Cells(7, 15) = ENDFLAG
TSlowcompressionphase = (T - TStart) * 10 ^ 9
ActiveSheet.Cells(11, 12) = TSlowcompressionphase
ActiveSheet.Cells(11, 10) = (TRRadial * 10 ^ -3)
ActiveSheet.Cells(11, 14) = (TRRadial * 10 ^ -3) + trradialstart * (10 ^ 6)
Rem Calculate energy in inductances

Ecap = 0.5 * C0 * V0 * V0
EL0 = 0.5 * L0 * I * I
ELt = 0.5 * (MU / (2 * Pi)) * (Log(C)) * Z0 * I * I * CURRF * CURRF
ELp = 0.5 * (MU / (2 * Pi)) * (Log(RADB / rp)) * ZF * I * I * CURRF * CURRF
MAG = MU * I * CURRF / (2 * Pi * rp)
EMAGp = (MAG * MAG / (2 * MU)) * Pi * rp * rp * ZF
EL0 = (EL0 / Ecap) * 100
ELt = (ELt / Ecap) * 100
ELp = (ELp / Ecap) * 100
EMAGp = (EMAGp / Ecap) * 100
SFI0 = (I0 * 10 ^ -3) / (RADA * 100) / (Sqr(P0))
SFIpeak = (Ipeak) / (RADA * 100) / (Sqr(P0))
SFIdip = (IR) / (RADA * 100) / (Sqr(P0))
If TAPER = 0 Then GoTo 7010
Kmin = kpr / (ENDRAD * 1000)
GoTo 7020
7010 Kmin = kpr / (RADA * 1000)
ID = (Ipeak) / (RADA * 100)

7020 Ec = 0.5 * C0 * (V0 - (CH / C0)) * (V0 - (CH / C0))
Ec = (Ec / Ecap) * 100
Excircuit = 100 - (EL0 + ELt + ELp + EMAGp + Ec)
EINP = (EINP / Ecap) * 100
Rem calculate loss of energy from inductances during current dip; ignoring capacitative energy change
L0t = L0 + (MU / (2 * Pi)) * (Log(C)) * Z0
Lp = (MU / (2 * Pi)) * (Log(RADB / rp)) * ZF
Edip = 0.5 * L0t * CURRF * CURRF * (Ipeak * Ipeak * 10 ^ 6 - I * I) - 0.5 * Lp * CURRF * CURRF * I * I
Edip = (Edip / Ecap) * 100

SFIpinch = (Ipinch) / (RADA * 100) / (Sqr(P0))

Rem ActiveSheet.Cells(9, 8) = Ipeak
Rem ActiveSheet.Cells(9, 10) = Ipinch
Rem ActiveSheet.Cells(9, 11) = SFIpeak
Rem ActiveSheet.Cells(9, 12) = SFIpinch
Rem ActiveSheet.Cells(9, 13) = VRMAX
Rem ActiveSheet.Cells(9, 14) = Kmin

Rem ActiveSheet.Cells(11, 9) = Ecap / 1000
Rem ActiveSheet.Cells(11, 10) = EINP
Rem Calculate  neutron yield in D2; 2 components viz 1. thermonuclear, 2. Beam-gas :

ActiveSheet.Cells(17, 22) = VRMAX

If ZN = 1 Then GoTo 7050
If ZN = 2 Then GoTo 7300
If ZN = 7 Then GoTo 7300
If ZN = 18 Then GoTo 7300
If ZN = 10 Then GoTo 7300
If ZN = 36 Then GoTo 7300
If ZN = 54 Then GoTo 7300

7050 If MW = 2 Then GoTo 7300

Rem Computed VRMAX varies typically in range of 30-60kV for small to big devices; too low compared to expt observations;
Rem Multiplying by factor 2 will get the range closer to 50-100kV; the range generally observed to be reponsible for beam-target neutrons in PF
Rem Multiply VRMAX by factor to get closer to experimental observations; fine tuned to fit the optimum pressure for Yn for the UNU/ICTP PFF (around 3-3.5 torr at 15 kV)

VRMAX = VRMAX * 3

If MW = 5 Then GoTo 7100

Rem For deuterium, compute 2. Beam-gas neutron yield component (ref: NRL Formulary 2006 pg 43)
 sig = ((((1.177 - (3.08 * (10 ^ -4)) * (VRMAX)) ^ 2) + 1) ^ -1) * 482 / (VRMAX * (Exp(47.88 * VRMAX ^ -0.5) - 1))
 sig = sig * 10 ^ -28
GoTo 7150

Rem For D-T (50:50), compute 2. Beam-gas neutron yield component (ref: NRL Formulary 2006 pg 43)
7100  sig = (409 + ((((1.076 - 0.01368 * (VRMAX)) ^ 2) + 1) ^ -1) * 50200) / (VRMAX * (Exp(45.95 * VRMAX ^ -0.5) - 1))
 sig = sig * 10 ^ -28


Rem Calibrate for UNU/ICTP PFF for max neutron yield at optimum pressure as 10^8
7150 sig = sig * 6.34 * 10 ^ 8
Rem Change Calibration to NESSI-like, at expt point of 0.5MA pinch current
sig = sig / 23.23
Rem correct for dissociation number change in June 2016
Rem DNchange
sig = sig / dissociatenumber
Rem Use model Ni I^2 zf^2 LOG(b/rp) VRMAX^-0.5 sig
7200 NBN = ni * ((Ipinch * 1000) ^ 2) * (ZF ^ 2) * (Log(RADB / rp)) * (VRMAX ^ -0.5) * sig

NN = NBN + NTN
7300 ActiveSheet.Cells(7, 11) = NTN
ActiveSheet.Cells(7, 12) = NBN
ActiveSheet.Cells(7, 13) = NN

ActiveSheet.Cells(17, 1) = Ecap / 1000
ActiveSheet.Cells(17, 2) = RESF
ActiveSheet.Cells(17, 3) = C
ActiveSheet.Cells(17, 4) = L0 * 10 ^ 9
ActiveSheet.Cells(17, 5) = C0 * 10 ^ 6
ActiveSheet.Cells(17, 6) = R0 * 10 ^ 3
ActiveSheet.Cells(17, 7) = RADB * 100
ActiveSheet.Cells(17, 8) = RADA * 100
ActiveSheet.Cells(17, 9) = Z0 * 100
ActiveSheet.Cells(17, 10) = V0 / 1000
ActiveSheet.Cells(17, 11) = P0
ActiveSheet.Cells(17, 12) = Ipeak
ActiveSheet.Cells(17, 13) = Ipinch
ActiveSheet.Cells(17, 14) = Tpinchmin / 10 ^ 6
ActiveSheet.Cells(17, 15) = Tpinch / 10 ^ 6
ActiveSheet.Cells(17, 16) = ZZR
ActiveSheet.Cells(17, 17) = -peakvs
ActiveSheet.Cells(17, 18) = -peakvp
ActiveSheet.Cells(17, 19) = amin / 10
ActiveSheet.Cells(17, 20) = zmax / 10
ActiveSheet.Cells(17, 21) = TSlowcompressionphase
Rem ActiveSheet.Cells(17, 22) = VRMAX (before x3 for effective beam energy)
ActiveSheet.Cells(17, 23) = nipinch / 10 ^ 23
ActiveSheet.Cells(17, 24) = NN / 10 ^ 10
ActiveSheet.Cells(17, 25) = -QSXR
ActiveSheet.Cells(17, 26) = -100 * QSXR / Ecap
ActiveSheet.Cells(17, 27) = massf
ActiveSheet.Cells(17, 28) = CFA
ActiveSheet.Cells(17, 29) = massfr
ActiveSheet.Cells(17, 30) = currfr
ActiveSheet.Cells(17, 31) = EINP
ActiveSheet.Cells(17, 32) = trradialstart * (10 ^ 6)
ActiveSheet.Cells(17, 33) = SFIpeak
ActiveSheet.Cells(17, 34) = ID
ActiveSheet.Cells(17, 35) = -QLN
Rem Expanded axial phase starts; integrated in normalised quantities

7380 d = 0.005
BE = BE / CFR
EINP = EINP1
7385 T = T / T0
 I = I / I0
 IO = CH / (I0 * T0)
 ZS = ZF / Z0
 ZZ = ZG
 z = 1 + ZS
 L = (Log(C) + 0.25) / Log(C)
 H = C * C / (C * C - 1)
 H = Sqr(H)
 L1 = (Log(C) + 0.5) / Log(C)

7480 T = T + d
If TAPER = 0 Then GoTo 7490
GoTo 7500

7490 tc5 = 1
7500 AC = (AL * AL * I * I * L - H * H * ZZ * ZZ) / (1 + H * H * (z - 1))
II = (1 - IO - BE * I * ZZ * L1 - RESF * I) / (1 + BE * tc5 + BE * L1 * (z - 1))
ZZ = ZZ + AC * d
7520 z = z + ZZ * d
 I = I + II * d
7540 IO = IO + I * d

 M = (1 + (1 / (2 * Log(C)))) * (z - 1)
7560 V = BE * ((1 * tc5 + M) * II + I * ZZ * (1 + (1 / (2 * Log(C)))))

 TR = T * T0 * 10 ^ 6
 VR = V * V0 * 10 ^ -3
 IR = I * I0 * 10 ^ -3
 ZZR = (ZZCHAR / AL) * ZZ * 10 ^ -4
 ZR = z * Z0 * 100
Rem DR is time increment in sec
DR = d * T0
Rem Integrate to find EINP, energy dissipated by dynamic resistance effect, which is 0.5 (Ldot) I^2, considering current taking part in the motionEINP = EINP + (1000 * Log(C) * ZZR * IR * IR * CURRF * CURRF) * DR
EINP = EINP + (1000 * Log(C) * ZZR * IR * IR * CURRF * CURRF) * DR
Rem DZR is z increment in m
DZR = DR * ZZR * 10 ^ 4
Rem Also integrate for piston work
Wpiston = Wpiston + (10 ^ -7) * (Log(C)) * IR * IR * (10 ^ 6) * CURRF * CURRF * DZR
Lz = (10 ^ -9) * ZR * 2 * Log(C)
Einductance = 0.5 * 10 ^ 6 * IR * IR * (CURRF * CURRF * (Lz + Laxial * (10 ^ -9)) + L0)
PLN = 0
ActiveSheet.Cells(rowj, 1) = TR
ActiveSheet.Cells(rowj, 2) = IR
ActiveSheet.Cells(rowj, 3) = VR
ActiveSheet.Cells(rowj, 4) = ZR
ActiveSheet.Cells(rowj, 5) = ZZR
ActiveSheet.Cells(rowj, 53) = IR * CURRF
ActiveSheet.Cells(rowj, 52) = TR
Rem following statement calculates & print out axial phase 2 inductance, need correction factor
ActiveSheet.Cells(rowj, 61) = ZR * 2 * Log(C)
ActiveSheet.Cells(rowj, 62) = 100 * Einductance / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 63) = 100 * EINP / (0.5 * C0 * V0 * V0)
ActiveSheet.Cells(rowj, 66) = -PLN / (10 ^ 9)
ActiveSheet.Cells(rowj, 69) = 100 * Wpiston / (0.5 * C0 * V0 * V0)
rowj = rowj + 1

Rem Set limit for integration to just over half cycle

If T > 3.5 Then GoTo 9888
GoTo 7480

7665 Rem "INTEGRATION COMPLETED UP TO DESIRED TIME"

9888

End Sub
