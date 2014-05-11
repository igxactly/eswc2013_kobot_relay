'*******************************************
'******** 메탈파이터 프로그램 **************
'******** MF2-AI2-19관절********************
'*******************************************

DIM I AS BYTE
DIM J AS BYTE
DIM 자세 AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM D AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM DELAY_TIME AS BYTE
DIM DELAY_TIME2 AS BYTE
DIM TEMP AS BYTE
DIM 물건집은상태 AS BYTE
DIM 기울기확인횟수 AS BYTE

DIM 넘어진확인 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE

DIM S4 AS BYTE
DIM S22 AS BYTE

DIM 리모콘동작모드 AS BYTE


'**** 기울기센서포트 설정

CONST 앞뒤기울기AD포트 = 2
CONST 좌우기울기AD포트 = 3
CONST 기울기확인시간 = 10'10  'ms


CONST min = 95			'뒤로넘어졌을때
CONST max = 160			'앞으로넘어졌을때
CONST COUNT_MAX = 3
CONST 하한전압 = 106	'154 '약6V전압

PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

'***** 19 MOTOR *********
DIR G6A,1,0,0,1,1,1			'모터0~5번
DIR G6D,0,1,1,0,0,0			'모터18~23번
DIR G6B,1,0,0,1,1,1			'모터6~11번
DIR G6C,0,1,1,0,0,0			'모터12~17번

'***** 초기선언 *********************************
모터ONOFF = 0
보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
물건집은상태 = 0

리모콘동작모드 = 0 ' 임베디드전용=33 리모콘전용 = 0,



GOSUB 자이로INIT
GOSUB 자이로MID

'****초기위치 피드백*****************************
GOSUB MOTOR_ON



SPEED 5
GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로ON

GOSUB All_motor_mode2

GOTO MAIN
'************************************************
'************************************************
'************************************************

시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
엔터테이먼트음:
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
게임음:
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
파이트음:
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
경고음:
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
싸이렌음:
    TEMPO 180
    MUSIC "O22FC"
    DELAY 10
    RETURN
    '************************************************
모드1:
    TEMPO 200
    MUSIC "O18A>#CE#G#F#D#FB"
    RETURN
축구게임음:
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN


태권도음:
    TEMPO 190
    MUSIC "O28#C#D#F#G#A#G#F"
    RETURN

모드4:
    TEMPO 220
    MUSIC "O33C6D3C<6$B3A"
    RETURN


장애물게임음:
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN

    '************************************************
MOTOR_FAST_ON:

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    모터ONOFF = 0

    RETURN

    '************************************************
    '************************************************
MOTOR_ON:

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2,1
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3,1
    MOTORMODE G6D,3,2,2,1,3,1
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,2,2,2,1,1,2
    MOTORMODE G6D,2,2,2,1,1,2
    RETURN
    '************************************************
    '************************************************
HEAD_motor_mode3:
    MOTORMODE G6B,,,, ,,3
    RETURN

HEAD_motor_mode1:
    MOTORMODE G6B,,,, ,,1
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3
    RETURN
    '************************************************
전원초기자세:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,45,  60,  110, 100, 100, 100
    MOVE G6C,45,  60,  110, 100, 100, 100
    WAIT
    자세 = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT
    자세 = 0

    RETURN
    '******************************************	
초기100자세:
    MOVE G6A,100,  100, 100,  100, 100, 100
    MOVE G6D,100,  100, 100,  100, 100, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT
    자세 = 0
    RETURN
    '************************************************
기본자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT
    자세 = 0
    물건집은상태 = 0
    RETURN
    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,45, 52, 110, 100, 100, 100
    MOVE G6C,45, 52, 110, 100, 100, 100
    WAIT
    자세 = 2
    RETURN
    '******************************************
앉은자세:

    MOVE G6A,100, 143,  28, 145, 100, 100
    MOVE G6D,100, 143,  28, 145, 100, 100
    MOVE G6B,45,  55,  110
    MOVE G6C,45,  55,  110
    WAIT
    자세 = 1

    RETURN

    '**********************************************
    '**********************************************
    '***********************************************
    '**** 자이로감도 설정 ****
    '***********************************************

자이로INIT:
    GYRODIR G6A, 0, 0, 0, 0,1
    GYRODIR G6D, 1, 0, 0, 0,0

    RETURN
    '***********************************************
자이로MAX:

    GYROSENSE G6A,255 , 255,255,255
    GYROSENSE G6D,255 , 255,255,255

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A, 255, 100,100,100
    GYROSENSE G6D, 255, 100,100,100

    RETURN
    '***********************************************
자이로MID3:

    GYROSENSE G6A, 255, 200,200,200
    GYROSENSE G6D, 255, 200,200,200

    RETURN
    '***********************************************
자이로MID2:

    GYROSENSE G6A, 255, 150,150,150
    GYROSENSE G6D, 255, 150,150,150

    RETURN
    '***********************************************
    '***********************************************
자이로MIN:

    GYROSENSE G6A, 50, 50,50,50
    GYROSENSE G6D, 50, 50,50,50

    RETURN
    '***********************************************
자이로ST:


    GYROSENSE G6A,200,70,70,70,
    GYROSENSE G6D,200,70,70,70,


    RETURN

    '***********************************************
자이로ON:


    GYROSET G6A, 2, 1, 1, 1,
    GYROSET G6D, 2, 1, 1, 1,

    자이로ONOFF = 1
    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0

    자이로ONOFF = 0
    RETURN

    '************************************************
    '**********************************************
RX_EXIT:
    IF 리모콘동작모드 = 0 THEN
        ERX 4800, A, MAIN

        GOTO RX_EXIT
    ENDIF
    GOTO MAIN
    '**********************************************
GOSUB_RX_EXIT:
    IF 리모콘동작모드 = 0 THEN
        ERX 4800, A, GOSUB_RX_EXIT2

        GOTO GOSUB_RX_EXIT
    ENDIF
GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
GOSUB_RX_EXIT_REMOCON:

    ERX 4800, A, GOSUB_RX_EXIT_REMOCON2

    GOTO GOSUB_RX_EXIT_REMOCON

GOSUB_RX_EXIT_REMOCON2:
    RETURN
    '**********************************************
    '**********************************************

    '******************************************
전진달리기50:
    J = 0
    넘어진확인 = 0
    SPEED 12
    HIGHSPEED SETON
    'GOSUB Leg_motor_mode4
    MOTORMODE G6A,3,2,2,1,2,1
    MOTORMODE G6D,3,2,2,1,2,1
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_4
    ENDIF


    '**********************

전진달리기50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  78, 146,  91,  102
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  89,  100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_3:
    MOVE G6A,103,  70, 145, 103,  100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진달리기50_4
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤

    '*********************************

전진달리기50_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  78, 146,  91,  102
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  89,  100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_6:
    MOVE G6D,103,  70, 145, 103,  100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진달리기50_1
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤


    GOTO 전진달리기50_1


전진달리기50_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************

    '******************************************
전진달리기50곡선:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON
    'GOSUB Leg_motor_mode4
    MOTORMODE G6A,3,2,2,1,2,3
    MOTORMODE G6D,3,2,2,1,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101, 100
        MOVE G6D,101,  78, 145,  93, 98  , 100
        WAIT

        GOTO 전진달리기50곡선_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101 , 100
        MOVE G6A,101,  78, 145,  93, 98 , 100
        WAIT

        GOTO 전진달리기50곡선_4
    ENDIF


    '**********************
전진달리기50곡선_GOTO:
    ERX 4800,A, 전진달리기50곡선_1
    IF A = 21 THEN  ' △
        GOTO 전진달리기50곡선_1
    ELSEIF A = 28 THEN  ' ◁
        SPEED 보행속도
        MOVE G6A,95,  95, 100, 120, 104  , 108
        MOVE G6D,104,  78, 146,  91,  102 , 108
        MOVE G6B, 25
        MOVE G6C,65
        WAIT
        GOTO 전진달리기50곡선_2
    ELSEIF A = 17 THEN  ' C
        SPEED 보행속도
        MOVE G6A,95,  95, 100, 120, 104  , 112
        MOVE G6D,104,  78, 146,  91,  102 , 112
        MOVE G6B, 25
        MOVE G6C,65
        WAIT
        GOTO 전진달리기50곡선_2


    ELSEIF A = 30 THEN  ' ▷
        SPEED 보행속도
        MOVE G6A,95,  95, 100, 120, 104  , 98
        MOVE G6D,104,  78, 146,  91,  102 , 100
        MOVE G6B, 25
        MOVE G6C,65
        WAIT
        GOTO 전진달리기50곡선_2
    ELSEIF A = 27 THEN  ' D
        SPEED 보행속도
        MOVE G6A,95,  95, 100, 120, 104  , 96
        MOVE G6D,104,  78, 146,  91,  102 , 98
        MOVE G6B, 25
        MOVE G6C,65
        WAIT
        GOTO 전진달리기50곡선_2



    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50곡선_1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  91,  102 , 100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50곡선_2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  89,  100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50곡선_3:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 103,  100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50곡선_4
    IF A = 21 THEN  ' △
        GOTO 전진달리기50곡선_4
    ELSEIF A = 28 THEN  ' ◁
        SPEED 보행속도
        MOVE G6D,95,  95, 100, 120, 104  , 98
        MOVE G6A,104,  78, 146,  91,  102 , 100
        MOVE G6C, 25
        MOVE G6B,65
        WAIT
        GOTO 전진달리기50곡선_5
    ELSEIF A = 17 THEN  ' C
        SPEED 보행속도
        MOVE G6D,95,  95, 100, 120, 104  , 96
        MOVE G6A,104,  78, 146,  91,  102 , 98
        MOVE G6C, 25
        MOVE G6B,65
        WAIT
        GOTO 전진달리기50곡선_5

    ELSEIF A = 30 THEN  ' ▷
        SPEED 보행속도
        MOVE G6D,95,  95, 100, 120, 104  , 108
        MOVE G6A,104,  78, 146,  91,  102 , 108
        MOVE G6C, 25
        MOVE G6B,65
        WAIT
        GOTO 전진달리기50곡선_5
    ELSEIF A = 27 THEN  ' D
        SPEED 보행속도
        MOVE G6D,95,  95, 100, 120, 104  , 112
        MOVE G6A,104,  78, 146,  91,  102 , 112
        MOVE G6C, 25
        MOVE G6B,65
        WAIT
        GOTO 전진달리기50곡선_5

    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50곡선_4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  91,  102  , 100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50곡선_5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  89,  100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50곡선_6:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 103,  100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50곡선_GOTO

    '*****************************************************************
    ' 전진달리기50
    '*****************************************************************


전진달리기50_직진:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_직진1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 101
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_직진4
    ENDIF


    '**********************
전진달리기50_직진_GOTO:
    ERX 4800,A, 전진달리기50_직진1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_직진1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  89,  102 , 100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_직진2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  87,  100,100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_직진3:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100,100
    MOVE G6D, 95, 88, 160,  66, 102,100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_직진4

    IF A = 2 THEN
        GOTO 전진달리기50_직진4
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_직진4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  89,  102  , 100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_직진5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  87,  100,100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_직진6:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100,100
    MOVE G6A, 95, 88, 160,  66, 102,100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_직진_GOTO


전진달리기50_좌회전A:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_좌회전A1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_좌회전A4
    ENDIF


    '**********************
전진달리기50_좌회전A_GOTO:
    ERX 4800,A, 전진달리기50_좌회전A1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_좌회전A1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  91,  102 , 100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_좌회전A2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  87,  100,100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_좌회전A3:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100,108
    MOVE G6D, 95, 88, 160,  66, 102,106
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    '*********************************
    ERX 4800,A, 전진달리기50_좌회전A4

    IF A = 2 THEN
        GOTO 전진달리기50_직진4
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_좌회전A4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  89,  102  , 100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_좌회전A5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  87,  100,100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_좌회전A6:
    SPEED 보행속도
    MOVE G6D,103,  70, 144, 101,  100,92
    MOVE G6A, 95, 88, 159,  66, 102,94
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_좌회전A_GOTO

    ''''''''''''''''''''

전진달리기50_좌회전B:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_좌회전B1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_좌회전B4
    ENDIF


    '**********************
전진달리기50_좌회전B_GOTO:
    ERX 4800,A, 전진달리기50_좌회전B1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_좌회전B1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 112
    MOVE G6D,104,  78, 146,  89,  102 , 112
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_좌회전B2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  87,  100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_좌회전B3:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100,108
    MOVE G6D, 95, 88, 160,  66, 102,106
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    '*********************************
    ERX 4800,A, 전진달리기50_좌회전B4

    IF A = 2 THEN
        GOTO 전진달리기50_직진4
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_좌회전B4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 96
    MOVE G6A,104,  78, 146,  89,  102  , 98
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_좌회전B5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  87,  100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_좌회전B6: '''''''''''''''''
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100
    MOVE G6A, 95, 88, 160,  66, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_좌회전B_GOTO


    '''''''''''''''''''

전진달리기50_우회전A:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101,100
        MOVE G6D,101,  78, 145,  91, 98 ,100
        WAIT

        GOTO 전진달리기50_우회전A1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_우회전A4
    ENDIF


    '**********************
전진달리기50_우회전A_GOTO:
    ERX 4800,A, 전진달리기50_우회전A1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_우회전A1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  89,  102 , 100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_우회전A2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  87,  100,100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_우회전A3:
    SPEED 보행속도
    MOVE G6A,103,  70, 144, 101,  100,94
    MOVE G6D, 95, 88, 159,  66, 102,96
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_우회전A4

    IF A = 2 THEN
        GOTO 전진달리기50_직진4
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_우회전A4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  89,  102  , 100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_우회전A5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  87,  100,100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_우회전A6:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100,106
    MOVE G6A, 95, 88, 160,  66, 102,104
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_우회전A_GOTO

    ''''''''''''''''''

전진달리기50_우회전B:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_우회전B1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_우회전B4
    ENDIF


    '**********************
전진달리기50_우회전B_GOTO:
    ERX 4800,A, 전진달리기50_우회전B1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_우회전B1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 96
    MOVE G6D,104,  78, 146,  89,  102 , 98
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_우회전B2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  87,  100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_우회전B3:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100
    MOVE G6D, 95, 88, 160,  66, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_우회전B4

    IF A = 2 THEN
        GOTO 전진달리기50_직진4
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_우회전B4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 112
    MOVE G6A,104,  78, 146,  89,  102  , 112
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_우회전B5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  87,  100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_우회전B6:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100
    MOVE G6A, 95, 88, 160,  66, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_우회전B_GOTO

    '*****************************************************************
    ' 전진달리기50_끝
    '*****************************************************************
    '******************************************
안정화멈춤:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 안정화자세
    SPEED 15
    GOSUB 기본자세
    RETURN

    '******************************************
    '*****************************************************************
    ' 전진달리기_팔뻗어50
    '*****************************************************************


전진달리기50_직진_팔뻗어:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_직진1_팔뻗어
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 101
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_직진4_팔뻗어
    ENDIF


    '**********************
전진달리기50_직진_GOTO_팔뻗어:
    ERX 4800,A, 전진달리기50_직진1_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진1_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_직진1_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  89,  102 , 100
    MOVE G6B, 25
    MOVE G6C,125,  65,  120
    WAIT


전진달리기50_직진2_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  87,  100,100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_직진3_팔뻗어:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100,100
    MOVE G6D, 95, 88, 160,  66, 102,100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_직진4_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진4_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_직진4_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  89,  102  , 100
    MOVE G6C,125,  65,  120
    MOVE G6B,65
    WAIT


전진달리기50_직진5_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  87,  100,100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_직진6_팔뻗어:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100,100
    MOVE G6A, 95, 88, 160,  66, 102,100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_직진_GOTO_팔뻗어


전진달리기50_좌회전A_팔뻗어:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_좌회전A1_팔뻗어
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_좌회전A4_팔뻗어
    ENDIF


    '**********************
전진달리기50_좌회전A_GOTO_팔뻗어:
    ERX 4800,A, 전진달리기50_좌회전A1_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진1_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_좌회전A1_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  91,  102 , 100
    MOVE G6B, 25
    MOVE G6C,125,  65,  120
    WAIT


전진달리기50_좌회전A2_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  87,  100,100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_좌회전A3_팔뻗어:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100,108
    MOVE G6D, 95, 88, 160,  66, 102,106
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    '*********************************
    ERX 4800,A, 전진달리기50_좌회전A4_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진4_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_좌회전A4_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  89,  102  , 100
    MOVE G6C,125,  65,  120
    MOVE G6B,65
    WAIT


전진달리기50_좌회전A5_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  87,  100,100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_좌회전A6_팔뻗어:
    SPEED 보행속도
    MOVE G6D,103,  70, 144, 101,  100,92
    MOVE G6A, 95, 88, 159,  66, 102,94
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_좌회전A_GOTO_팔뻗어


    ''''''''''''''''''''


전진달리기50_좌회전B_팔뻗어:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_좌회전B1_팔뻗어
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_좌회전B4_팔뻗어
    ENDIF


    '**********************
전진달리기50_좌회전B_GOTO_팔뻗어:
    ERX 4800,A, 전진달리기50_좌회전B1_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진1_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_좌회전B1_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 112
    MOVE G6D,104,  78, 146,  89,  102 , 112
    MOVE G6B, 25
    MOVE G6C,125,  65,  120
    WAIT


전진달리기50_좌회전B2_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  87,  100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_좌회전B3_팔뻗어:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100,108
    MOVE G6D, 95, 88, 160,  66, 102,106
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_좌회전B4_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진4_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_좌회전B4_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 96
    MOVE G6A,104,  78, 146,  89,  102  , 98
    MOVE G6C,125,  65,  120
    MOVE G6B,65
    WAIT


전진달리기50_좌회전B5_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  87,  100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_좌회전B6_팔뻗어: '''''''''''''''''
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100
    MOVE G6A, 95, 88, 160,  66, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_좌회전B_GOTO_팔뻗어



    '''''''''''''''''''


전진달리기50_우회전A_팔뻗어:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101,100
        MOVE G6D,101,  78, 145,  91, 98 ,100
        WAIT

        GOTO 전진달리기50_우회전A1_팔뻗어
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_우회전A4_팔뻗어
    ENDIF


    '**********************
전진달리기50_우회전A_GOTO_팔뻗어:
    ERX 4800,A, 전진달리기50_우회전A1_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진1_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_우회전A1_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  89,  102 , 100
    MOVE G6B, 25
    MOVE G6C,125,  65,  120
    WAIT


전진달리기50_우회전A2_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  87,  100,100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_우회전A3_팔뻗어:
    SPEED 보행속도
    MOVE G6A,103,  70, 144, 101,  100,94
    MOVE G6D, 95, 88, 159,  66, 102,96
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_우회전A4_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진4_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_우회전A4_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  89,  102  , 100
    MOVE G6C,125,  65,  120
    MOVE G6B,65
    WAIT


전진달리기50_우회전A5_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  87,  100,100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_우회전A6_팔뻗어:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100,106
    MOVE G6A, 95, 88, 160,  66, 102,104
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_우회전A_GOTO_팔뻗어

    ''''''''''''''''''

전진달리기50_우회전B_팔뻗어:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  91, 101, 100
        MOVE G6D,101,  78, 145,  91, 98  , 100
        WAIT

        GOTO 전진달리기50_우회전B1_팔뻗어
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  91, 101 , 100
        MOVE G6A,101,  78, 145,  91, 98 , 100
        WAIT

        GOTO 전진달리기50_우회전B4_팔뻗어
    ENDIF


    '**********************
전진달리기50_우회전B_GOTO_팔뻗어:
    ERX 4800,A, 전진달리기50_우회전B1_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진1_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B1_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B1_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF


전진달리기50_우회전B1_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 96
    MOVE G6D,104,  78, 146,  89,  102 , 98
    MOVE G6B, 25
    MOVE G6C,125,  65,  120
    WAIT


전진달리기50_우회전B2_팔뻗어:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  80, 146,  87,  100
    WAIT
    J = J + 1
    ETX 4800,J

전진달리기50_우회전B3_팔뻗어:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 101,  100
    MOVE G6D, 95, 88, 160,  66, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_우회전B4_팔뻗어

    IF A = 2 THEN
        GOTO 전진달리기50_직진4_팔뻗어
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4_팔뻗어
    ELSEIF A = 4 THEN
        GOTO 전진달리기50_좌회전B4_팔뻗어
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4_팔뻗어
    ELSEIF A = 6 THEN
        GOTO 전진달리기50_우회전B4_팔뻗어
    ELSE
        GOTO 전진달리기50_멈춤
    ENDIF

전진달리기50_우회전B4_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 112
    MOVE G6A,104,  78, 146,  89,  102  , 112
    MOVE G6C,125,  65,  120
    MOVE G6B,65
    WAIT


전진달리기50_우회전B5_팔뻗어:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  80, 146,  87,  100
    WAIT

    J = J + 1
    ETX 4800,J

전진달리기50_우회전B6_팔뻗어:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 101,  100
    MOVE G6A, 95, 88, 160,  66, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    GOTO 전진달리기50_우회전B_GOTO_팔뻗어


    '*****************************************************************
    ' 전진달리기50_팔뻗어_끝
    '*****************************************************************
    ''************************************************

뒤로일어나기:
    GOSUB 자이로OFF
    GOSUB All_motor_Reset
    HIGHSPEED SETOFF
    PTP SETON
    PTP ALLON


    SPEED 15
    MOVE G6B,45,  60,  140
    MOVE G6C,45,  60,  140
    WAIT

    SPEED 15
    MOVE G6B,120,  130,  140
    MOVE G6C,120,  130,  140
    WAIT

    SPEED 15
    MOVE G6B, 185, 110,  55
    MOVE G6C, 185, 110,  55
    WAIT


    SPEED 15
    MOVE G6A,  70, 150,  27, 150, 190,120
    MOVE G6D,  70, 150,  27, 150, 190,120
    MOVE G6B, 185, 60,  55
    MOVE G6C, 185, 60,  55
    WAIT



    SPEED 15	
    MOVE G6B,  100, 40, 120
    MOVE G6C,  100, 40, 120
    WAIT


    SPEED 10	
    MOVE G6A,  100, 150,  25, 140, 98,100
    MOVE G6D,  100, 150,  25, 140, 98,100
    MOVE G6B,  100, 45, 120
    MOVE G6C,  100, 45, 120
    WAIT

    DELAY 200
뒤로일어나기_NO:
    S4 = MOTORIN(4)
    S22 = MOTORIN(22)

    IF S4 < 102 AND S22 < 102 THEN GOTO 뒤로일어나기_GOGO
    SPEED 8	
    MOVE G6A,  100, 150,  25, 140, 98,100
    MOVE G6D,  100, 150,  25, 140, 98,100
    WAIT

    SPEED 8	
    MOVE G6A,  100, 135,  57, 125, 98,100
    MOVE G6D,  100, 135,  57, 125, 98,100
    WAIT

    GOTO 뒤로일어나기_NO

뒤로일어나기_GOGO:

    GOSUB Leg_motor_mode2
    SPEED 8
    GOSUB 기본자세
    DELAY 500
    'GOSUB All_motor_mode2
    GOSUB 자이로ON
    'GOSUB All_motor_Reset
    넘어진확인 = 1
    RETURN
    '************************************************
앞뒤기울기측정:

    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN GOSUB 기울기앞
    IF A > MAX THEN GOSUB 기울기뒤

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN  GOSUB 뒤로일어나기
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN GOSUB 앞으로일어나기
    RETURN
    '**************************************************
좌우기울기측정:

    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
        RETURN

    ENDIF
    RETURN
    '**************************************************

앞뒤기울기값_TX:
    A = AD(앞뒤기울기AD포트)	'기울기 앞뒤

    ETX 4800, A
    DELAY 20

    RETURN

    '**************************************************
좌우기울기값_TX:
    A = AD(좌우기울기AD포트)	'기울기 앞뒤

    ETX 4800, A
    DELAY 20

    RETURN

    '**********************************************
앞으로일어나기:
    GOSUB 자이로OFF
    GOSUB All_motor_Reset
    HIGHSPEED SETOFF
    PTP SETON
    PTP ALLON

    SPEED 15
    MOVE G6A,100, 20,  70, 140, 100,
    MOVE G6D,100, 20,  70, 140, 100,
    MOVE G6B,  165,  130,  55, , , 100
    MOVE G6C,  165,  130,  55, , ,
    WAIT


    SPEED 12
    MOVE G6A,100, 136,  35, 90, 100,
    MOVE G6D,100, 136,  35, 90, 100,
    MOVE G6B,  165,  155,  130, , , 100
    MOVE G6C,  165,  155,  130, , ,
    WAIT

    SPEED 12
    MOVE G6A,100, 150,  80, 30, 100,
    MOVE G6D,100, 150,  80, 30, 100,
    MOVE G6B,  170,  155,  130, , , 100
    MOVE G6C,  170,  155,  130, , ,
    WAIT


    SPEED 6
    MOVE G6A,100, 150,  90, 15, 100,
    MOVE G6D,100, 150,  90, 15, 100,
    WAIT


    SPEED 6
    MOVE G6A,100, 120,  90, 100, 100,
    MOVE G6D,100, 120,  90, 100, 100,
    MOVE G6B,80,  60,  70
    MOVE G6C,80,  60,  70
    WAIT

    DELAY 100
    GOSUB Leg_motor_mode2
    SPEED 8
    GOSUB 기본자세
    넘어진확인 = 1
    DELAY 500
    'GOSUB All_motor_mode2
    GOSUB 자이로ON
    RETURN

    '******************************************
전진종종걸음:
    J = 0
    넘어진확인 = 0
    GOSUB 자이로MID
    GOSUB 자이로ON
    SPEED 10
    HIGHSPEED SETON
    'GOSUB All_motor_mode3
    MOTORMODE G6A,3,2,2,2,2,1
    MOTORMODE G6D,3,2,2,2,2,1
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B, 45,  55
        MOVE G6C,45,  55
        WAIT

        GOTO 전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B, 45,  55
        MOVE G6C,45,  55
        WAIT

        GOTO 전진종종걸음_4
    ENDIF


    '**********************

전진종종걸음_1:
    SPEED 10
    MOVE G6A,95,  95, 120, 100, 104,100
    MOVE G6D,104,  77, 146,  91,  102,100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT
    J = J + 1
    ETX 4800,J

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF
    ERX 4800,A, 전진종종걸음_3
    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤


전진종종걸음_3:
    SPEED 10
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  89, 146,  80, 102
    WAIT


    '*********************************

전진종종걸음_4:
    SPEED 10
    MOVE G6D,95,  95, 120, 100, 104,100
    MOVE G6A,104,  77, 146,  91,  102,100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT
    J = J + 1
    ETX 4800,J



전진종종걸음_6:
    SPEED 10
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  89, 146,  80, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진종종걸음_1
    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤


    GOTO 전진종종걸음_1


전진종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
머리모터제어:

    ERX 4800,A ,머리모터제어
    IF A >= 10 AND A <= 190 THEN
        GOSUB HEAD_motor_mode3
        SPEED 15
        SERVO 11, A
        DELAY 500
        GOSUB HEAD_motor_mode1
        GOTO MAIN
    ELSE
        GOSUB 경고음
    ENDIF

    RETURN
    '**********************************************	

MAIN: '라벨설정

    ETX 4800,48
    GOSUB 앞뒤기울기측정

MAIN1:


MAIN2:

    ERX 4800, A, MAIN2


    ETX  4800,A '받은 동일한 코드값을 확인차원으로 보낸다.
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

    '******************
    '******************

KEY1:

    GOTO 전진달리기50_좌회전A
    GOTO MAIN
    '******************
KEY2:

    GOTO 전진달리기50_직진
    GOTO MAIN
    '******************
KEY3:

    GOTO 전진달리기50_우회전A'적게 돌기
    GOTO MAIN
    '******************
KEY4:

    GOTO 전진달리기50_좌회전B'많이 돌기
    GOTO MAIN
    '******************
KEY5:
    MUSIC "G"
    GOTO MAIN
    '******************
KEY6:

    GOTO 전진달리기50_우회전B
    GOTO MAIN
    '******************
KEY7:


    GOTO MAIN
    '******************
KEY8:


    MUSIC ">C<"
    GOTO MAIN
    '******************
KEY9:


    GOTO MAIN
    '******************
KEY10: '0

    GOSUB 머리모터제어
    GOTO MAIN
    '******************
KEY11: ' ▲

    GOTO 전진종종걸음


    GOTO MAIN
    '******************
KEY12: ' ▼



    GOTO MAIN
    '******************
KEY13: '▶


    GOTO MAIN
    '******************
KEY14: ' ◀




    GOTO MAIN
    '******************
KEY15: ' A


    GOTO MAIN
    '******************
KEY16: ' POWER



    GOTO MAIN
    '******************
KEY17: ' C



    GOTO MAIN
    '******************
KEY18: ' E


    GOTO MAIN
    '******************


KEY19: ' P2


    GOTO MAIN
    '******************
KEY20: ' B	


    GOTO MAIN
    '******************
KEY21: ' △

    ' GOTO 전진달리기50곡선

    GOTO MAIN
    '******************
KEY22: ' *	


    GOTO MAIN
    '******************
KEY23: ' G


    GOTO MAIN
    '******************
KEY24: ' #


    GOTO MAIN
    '******************
KEY25: ' P1


    GOTO MAIN
    '******************
KEY26: ' ■

    GOTO MAIN
    '******************
KEY27: ' D

    GOTO MAIN
    '******************
KEY28: ' ◁


    GOTO MAIN
    '******************
KEY29: ' □


    GOTO MAIN
    '******************
KEY30: ' ▷


    GOTO MAIN
    '******************
KEY31: ' ▽


    GOTO MAIN
    '******************

KEY32: ' F


    GOTO MAIN
    '******************

