# RUN: llvm-mc -show-encoding -triple=mips-unknown-unknown -mattr=dsp %s | FileCheck %s
#
# CHECK:   .text
  .set noat
  absq_s.ph         $1, $2          # CHECK: absq_s.ph          $1, $2          # encoding: [0x7c,0x02,0x0a,0x52]
  absq_s.w          $5, $6          # CHECK: absq_s.w           $5, $6          # encoding: [0x7c,0x06,0x2c,0x52]
  addq.ph           $7, $8, $9      # CHECK: addq.ph            $7, $8, $9      # encoding: [0x7d,0x09,0x3a,0x90]
  addq_s.ph         $10, $11, $12   # CHECK: addq_s.ph          $10, $11, $12   # encoding: [0x7d,0x6c,0x53,0x90]
  addq_s.w          $13, $14, $15   # CHECK: addq_s.w           $13, $14, $15   # encoding: [0x7d,0xcf,0x6d,0x90]
  addsc             $gp, $sp, $fp   # CHECK: addsc              $gp, $sp, $fp   # encoding: [0x7f,0xbe,0xe4,0x10]
  addu.qb           $6, $7, $8      # CHECK: addu.qb            $6, $7, $8      # encoding: [0x7c,0xe8,0x30,0x10]
  addu_s.qb         $9, $10, $11    # CHECK: addu_s.qb          $9, $10, $11    # encoding: [0x7d,0x4b,0x49,0x10]
  addwc             $12, $13, $14   # CHECK: addwc              $12, $13, $14   # encoding: [0x7d,0xae,0x64,0x50]
  bitrev            $25, $26        # CHECK: bitrev             $25, $26        # encoding: [0x7c,0x1a,0xce,0xd2]
  bposge32          21100           # CHECK: bposge32           21100           # encoding: [0x04,0x1c,0x14,0x9b]
  cmp.eq.ph         $27, $gp        # CHECK: cmp.eq.ph          $27, $gp        # encoding: [0x7f,0x7c,0x02,0x11]
  cmp.lt.ph         $sp, $fp        # CHECK: cmp.lt.ph          $sp, $fp        # encoding: [0x7f,0xbe,0x02,0x51]
  cmp.le.ph         $ra, $1         # CHECK: cmp.le.ph          $ra, $1         # encoding: [0x7f,0xe1,0x02,0x91]
  cmpgu.eq.qb       $11, $12, $13   # CHECK: cmpgu.eq.qb        $11, $12, $13   # encoding: [0x7d,0x8d,0x59,0x11]
  cmpgu.lt.qb       $14, $15, $16   # CHECK: cmpgu.lt.qb        $14, $15, $16   # encoding: [0x7d,0xf0,0x71,0x51]
  cmpgu.le.qb       $17, $18, $19   # CHECK: cmpgu.le.qb        $17, $18, $19   # encoding: [0x7e,0x53,0x89,0x91]
  cmpu.eq.qb        $20, $21        # CHECK: cmpu.eq.qb         $20, $21        # encoding: [0x7e,0x95,0x00,0x11]
  cmpu.lt.qb        $22, $23        # CHECK: cmpu.lt.qb         $22, $23        # encoding: [0x7e,0xd7,0x00,0x51]
  cmpu.le.qb        $24, $25        # CHECK: cmpu.le.qb         $24, $25        # encoding: [0x7f,0x19,0x00,0x91]
  dpaq_s.w.ph       $ac1, $1, $2    # CHECK: dpaq_s.w.ph        $ac1, $1, $2    # encoding: [0x7c,0x22,0x09,0x30]
  dpaq_sa.l.w       $ac2, $3, $4    # CHECK: dpaq_sa.l.w        $ac2, $3, $4    # encoding: [0x7c,0x64,0x13,0x30]
  dpau.h.qbl        $ac1, $9, $10   # CHECK: dpau.h.qbl         $ac1, $9, $10   # encoding: [0x7d,0x2a,0x08,0xf0]
  dpau.h.qbr        $ac1, $11, $12  # CHECK: dpau.h.qbr         $ac1, $11, $12  # encoding: [0x7d,0x6c,0x09,0xf0]
  dpsq_s.w.ph       $ac0, $17, $18  # CHECK: dpsq_s.w.ph        $ac0, $17, $18  # encoding: [0x7e,0x32,0x01,0x70]
  dpsq_sa.l.w       $ac1, $19, $20  # CHECK: dpsq_sa.l.w        $ac1, $19, $20  # encoding: [0x7e,0x74,0x0b,0x70]
  dpsu.h.qbl        $ac0, $5, $6    # CHECK: dpsu.h.qbl         $ac0, $5, $6    # encoding: [0x7c,0xa6,0x02,0xf0]
  dpsu.h.qbr        $ac1, $7, $8    # CHECK: dpsu.h.qbr         $ac1, $7, $8    # encoding: [0x7c,0xe8,0x0b,0xf0]
  extp              $1, $ac0, 31    # CHECK: extp               $1, $ac0, 31    # encoding: [0x7f,0xe1,0x00,0xb8]
  extpdp            $2, $ac1, 0     # CHECK: extpdp             $2, $ac1, 0     # encoding: [0x7c,0x02,0x0a,0xb8]
  extpdpv           $3, $ac2, $4    # CHECK: extpdpv            $3, $ac2, $4    # encoding: [0x7c,0x83,0x12,0xf8]
  extpv             $5, $ac3, $6    # CHECK: extpv              $5, $ac3, $6    # encoding: [0x7c,0xc5,0x18,0xf8]
  extr.w            $7, $ac0, 31    # CHECK: extr.w             $7, $ac0, 31    # encoding: [0x7f,0xe7,0x00,0x38]
  extr_r.w          $8, $ac1, 15    # CHECK: extr_r.w           $8, $ac1, 15    # encoding: [0x7d,0xe8,0x09,0x38]
  extr_rs.w         $9, $ac2, 7     # CHECK: extr_rs.w          $9, $ac2, 7     # encoding: [0x7c,0xe9,0x11,0xb8]
  extr_s.h          $10, $ac3, 3    # CHECK: extr_s.h           $10, $ac3, 3    # encoding: [0x7c,0x6a,0x1b,0xb8]
  extrv.w           $11, $ac0, $12  # CHECK: extrv.w            $11, $ac0, $12  # encoding: [0x7d,0x8b,0x00,0x78]
  extrv_r.w         $13, $ac1, $14  # CHECK: extrv_r.w          $13, $ac1, $14  # encoding: [0x7d,0xcd,0x09,0x78]
  extrv_rs.w        $15, $ac2, $16  # CHECK: extrv_rs.w         $15, $ac2, $16  # encoding: [0x7e,0x0f,0x11,0xf8]
  extrv_s.h         $17, $ac3, $18  # CHECK: extrv_s.h          $17, $ac3, $18  # encoding: [0x7e,0x51,0x1b,0xf8]
  insv              $19, $20        # CHECK: insv               $19, $20        # encoding: [0x7e,0x93,0x00,0x0c]
  lbux              $10, $20($26)   # CHECK: lbux               $10, $20($26)   # encoding: [0x7f,0x54,0x51,0x8a]
  lhx               $11, $21($27)   # CHECK: lhx                $11, $21($27)   # encoding: [0x7f,0x75,0x59,0x0a]
  lwx               $12, $22($gp)   # CHECK: lwx                $12, $22($gp)   # encoding: [0x7f,0x96,0x60,0x0a]
  madd              $ac1, $6, $7    # CHECK: madd               $ac1, $6, $7    # encoding: [0x70,0xc7,0x08,0x00]
  maddu             $ac0, $8, $9    # CHECK: maddu              $ac0, $8, $9    # encoding: [0x71,0x09,0x00,0x01]
  madd              $6, $7          # CHECK: madd               $6, $7          # encoding: [0x70,0xc7,0x00,0x00]
  maddu             $8, $9          # CHECK: maddu              $8, $9          # encoding: [0x71,0x09,0x00,0x01]
  maq_s.w.phl       $ac2, $3, $4    # CHECK: maq_s.w.phl        $ac2, $3, $4    # encoding: [0x7c,0x64,0x15,0x30]
  maq_sa.w.phl      $ac3, $5, $6    # CHECK: maq_sa.w.phl       $ac3, $5, $6    # encoding: [0x7c,0xa6,0x1c,0x30]
  maq_s.w.phr       $ac0, $7, $8    # CHECK: maq_s.w.phr        $ac0, $7, $8    # encoding: [0x7c,0xe8,0x05,0xb0]
  maq_sa.w.phr      $ac1, $9, $10   # CHECK: maq_sa.w.phr       $ac1, $9, $10   # encoding: [0x7d,0x2a,0x0c,0xb0]
  mfhi              $14, $ac1       # CHECK: mfhi               $14, $ac1       # encoding: [0x00,0x20,0x70,0x10]
  mflo              $15, $ac0       # CHECK: mflo               $15, $ac0       # encoding: [0x00,0x00,0x78,0x12]
  mfhi              $14             # CHECK: mfhi               $14             # encoding: [0x00,0x00,0x70,0x10]
  mflo              $15             # CHECK: mflo               $15             # encoding: [0x00,0x00,0x78,0x12]
  modsub            $11, $12, $13   # CHECK: modsub             $11, $12, $13   # encoding: [0x7d,0x8d,0x5c,0x90]
  msub              $ac3, $10, $11  # CHECK: msub               $ac3, $10, $11  # encoding: [0x71,0x4b,0x18,0x04]
  msubu             $ac2, $12, $13  # CHECK: msubu              $ac2, $12, $13  # encoding: [0x71,0x8d,0x10,0x05]
  msub              $10, $11        # CHECK: msub               $10, $11        # encoding: [0x71,0x4b,0x00,0x04]
  msubu             $12, $13        # CHECK: msubu              $12, $13        # encoding: [0x71,0x8d,0x00,0x05]
  mthi              $16, $ac3       # CHECK: mthi               $16, $ac3       # encoding: [0x02,0x00,0x18,0x11]
  mthi              $16             # CHECK: mthi               $16             # encoding: [0x02,0x00,0x00,0x11]
  mthlip            $14, $ac2       # CHECK: mthlip             $14, $ac2       # encoding: [0x7d,0xc0,0x17,0xf8]
  mtlo              $17, $ac2       # CHECK: mtlo               $17, $ac2       # encoding: [0x02,0x20,0x10,0x13]
  mtlo              $17             # CHECK: mtlo               $17             # encoding: [0x02,0x20,0x00,0x13]
  muleq_s.w.phl     $21, $22, $23   # CHECK: muleq_s.w.phl      $21, $22, $23   # encoding: [0x7e,0xd7,0xaf,0x10]
  muleq_s.w.phr     $24, $25, $26   # CHECK: muleq_s.w.phr      $24, $25, $26   # encoding: [0x7f,0x3a,0xc7,0x50]
  muleu_s.ph.qbl    $27, $gp, $sp   # CHECK: muleu_s.ph.qbl     $27, $gp, $sp   # encoding: [0x7f,0x9d,0xd9,0x90]
  muleu_s.ph.qbr    $fp, $ra, $1    # CHECK: muleu_s.ph.qbr     $fp, $ra, $1    # encoding: [0x7f,0xe1,0xf1,0xd0]
  mulq_rs.ph        $2, $3, $4      # CHECK: mulq_rs.ph         $2, $3, $4      # encoding: [0x7c,0x64,0x17,0xd0]
  mulsaq_s.w.ph     $ac0, $16, $17  # CHECK: mulsaq_s.w.ph      $ac0, $16, $17  # encoding: [0x7e,0x11,0x01,0xb0]
  mult              $ac3, $2, $3    # CHECK: mult               $ac3, $2, $3    # encoding: [0x00,0x43,0x18,0x18]
  multu             $ac2, $4, $5    # CHECK: multu              $ac2, $4, $5    # encoding: [0x00,0x85,0x10,0x19]
  mult              $2, $3          # CHECK: mult               $2, $3          # encoding: [0x00,0x43,0x00,0x18]
  multu             $4, $5          # CHECK: multu              $4, $5          # encoding: [0x00,0x85,0x00,0x19]
  packrl.ph         $18, $19, $20   # CHECK: packrl.ph          $18, $19, $20   # encoding: [0x7e,0x74,0x93,0x91]
  pick.ph           $7, $15, $3     # CHECK: pick.ph            $7, $15, $3     # encoding: [0x7d,0xe3,0x3a,0xd1]
  pick.qb           $2, $4, $8      # CHECK: pick.qb            $2, $4, $8      # encoding: [0x7c,0x88,0x10,0xd1]
  preceq.w.phl      $20, $21        # CHECK: preceq.w.phl       $20, $21        # encoding: [0x7c,0x15,0xa3,0x12]
  preceq.w.phr      $21, $22        # CHECK: preceq.w.phr       $21, $22        # encoding: [0x7c,0x16,0xab,0x52]
  precequ.ph.qbl    $22, $23        # CHECK: precequ.ph.qbl     $22, $23        # encoding: [0x7c,0x17,0xb1,0x12]
  precequ.ph.qbla   $24, $25        # CHECK: precequ.ph.qbla    $24, $25        # encoding: [0x7c,0x19,0xc1,0x92]
  precequ.ph.qbr    $23, $24        # CHECK: precequ.ph.qbr     $23, $24        # encoding: [0x7c,0x18,0xb9,0x52]
  precequ.ph.qbra   $25, $26        # CHECK: precequ.ph.qbra    $25, $26        # encoding: [0x7c,0x1a,0xc9,0xd2]
  preceu.ph.qbl     $26, $27        # CHECK: preceu.ph.qbl      $26, $27        # encoding: [0x7c,0x1b,0xd7,0x12]
  preceu.ph.qbla    $gp, $sp        # CHECK: preceu.ph.qbla     $gp, $sp        # encoding: [0x7c,0x1d,0xe7,0x92]
  preceu.ph.qbr     $27, $gp        # CHECK: preceu.ph.qbr      $27, $gp        # encoding: [0x7c,0x1c,0xdf,0x52]
  preceu.ph.qbra    $sp, $fp        # CHECK: preceu.ph.qbra     $sp, $fp        # encoding: [0x7c,0x1e,0xef,0xd2]
  precrq.ph.w       $17, $18, $19   # CHECK: precrq.ph.w        $17, $18, $19   # encoding: [0x7e,0x53,0x8d,0x11]
  precrq.qb.ph      $16, $17, $18   # CHECK: precrq.qb.ph       $16, $17, $18   # encoding: [0x7e,0x32,0x83,0x11]
  precrqu_s.qb.ph   $19, $20, $21   # CHECK: precrqu_s.qb.ph    $19, $20, $21   # encoding: [0x7e,0x95,0x9b,0xd1]
  precrq_rs.ph.w    $18, $19, $20   # CHECK: precrq_rs.ph.w     $18, $19, $20   # encoding: [0x7e,0x74,0x95,0x51]
  raddu.w.qb        $1, $2          # CHECK: raddu.w.qb         $1, $2          # encoding: [0x7c,0x40,0x0d,0x10]
  rddsp             $5, 256         # CHECK: rddsp              $5, 256         # encoding: [0x7d,0x00,0x2c,0xb8]
  repl.ph           $2, 12          # CHECK: repl.ph            $2, 12          # encoding: [0x7c,0x0c,0x12,0x92]
  repl.qb           $1, 85          # CHECK: repl.qb            $1, 85          # encoding: [0x7c,0x55,0x08,0x92]
  replv.ph          $1, $2          # CHECK: replv.ph           $1, $2          # encoding: [0x7c,0x02,0x0a,0xd2]
  replv.qb          $1, $2          # CHECK: replv.qb           $1, $2          # encoding: [0x7c,0x02,0x08,0xd2]
  shilo             $ac1, 16        # CHECK: shilo              $ac1, 16        # encoding: [0x7d,0x00,0x0e,0xb8]
  shilov            $ac1, $2        # CHECK: shilov             $ac1, $2        # encoding: [0x7c,0x40,0x0e,0xf8]
  shll.ph           $1, $2, 3       # CHECK: shll.ph            $1, $2, 3       # encoding: [0x7c,0x62,0x0a,0x13]
  shll_s.ph         $1, $2, 3       # CHECK: shll_s.ph          $1, $2, 3       # encoding: [0x7c,0x62,0x0b,0x13]
  shll.qb           $1, $2, 3       # CHECK: shll.qb            $1, $2, 3       # encoding: [0x7c,0x62,0x08,0x13]
  shllv.ph          $1, $2, $3      # CHECK: shllv.ph           $1, $2, $3      # encoding: [0x7c,0x62,0x0a,0x93]
  shllv_s.ph        $1, $2, $3      # CHECK: shllv_s.ph         $1, $2, $3      # encoding: [0x7c,0x62,0x0b,0x93]
  shllv.qb          $1, $2, $3      # CHECK: shllv.qb           $1, $2, $3      # encoding: [0x7c,0x62,0x08,0x93]
  shllv_s.w         $1, $2, $3      # CHECK: shllv_s.w          $1, $2, $3      # encoding: [0x7c,0x62,0x0d,0x93]
  shll_s.w          $1, $2, 3       # CHECK: shll_s.w           $1, $2, 3       # encoding: [0x7c,0x62,0x0d,0x13]
  shra.ph           $5, $2, 1       # CHECK: shra.ph            $5, $2, 1       # encoding: [0x7c,0x22,0x2a,0x53]
  shra_r.ph         $5, $2, 1       # CHECK: shra_r.ph          $5, $2, 1       # encoding: [0x7c,0x22,0x2b,0x53]
  shrav.ph          $1, $2, $3      # CHECK: shrav.ph           $1, $2, $3      # encoding: [0x7c,0x62,0x0a,0xd3]
  shrav_r.ph        $1, $2, $3      # CHECK: shrav_r.ph         $1, $2, $3      # encoding: [0x7c,0x62,0x0b,0xd3]
  shrav_r.w         $1, $2, $3      # CHECK: shrav_r.w          $1, $2, $3      # encoding: [0x7c,0x62,0x0d,0xd3]
  shra_r.w          $1, $2, 1       # CHECK: shra_r.w           $1, $2, 1       # encoding: [0x7c,0x22,0x0d,0x53]
  shrl.qb           $1, $2, 2       # CHECK: shrl.qb            $1, $2, 2       # encoding: [0x7c,0x42,0x08,0x53]
  shrlv.qb          $1, $2, $3      # CHECK: shrlv.qb           $1, $2, $3      # encoding: [0x7c,0x62,0x08,0xd3]
  subq.ph           $1, $2, $3      # CHECK: subq.ph            $1, $2, $3      # encoding: [0x7c,0x43,0x0a,0xd0]
  subq_s.ph         $1, $2, $3      # CHECK: subq_s.ph          $1, $2, $3      # encoding: [0x7c,0x43,0x0b,0xd0]
  subq_s.w          $1, $2, $3      # CHECK: subq_s.w           $1, $2, $3      # encoding: [0x7c,0x43,0x0d,0xd0]
  subu.qb           $1, $2, $3      # CHECK: subu.qb            $1, $2, $3      # encoding: [0x7c,0x43,0x08,0x50]
  subu_s.qb         $1, $2, $3      # CHECK: subu_s.qb          $1, $2, $3      # encoding: [0x7c,0x43,0x09,0x50]
  wrdsp             $1, 0           # CHECK: wrdsp              $1, 0           # encoding: [0x7c,0x20,0x04,0xf8]
