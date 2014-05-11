/*
 * 2013 ESWC Intelligence Humanoid Competition
 *
 *	Title:	Misson <Relay> - Client
 *
 *	Author:	Kobot (Kookmin Univ. CS)
 *
 */

//#define SERVERMODE
#ifndef SERVERMODE
	#define CLIENTMODE
#endif

#define WITHOUT_NETWORK

#define COMMAND_DELAY 300000

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <time.h>
#include <termios.h>
#include <pthread.h> 
#include <fcntl.h>

#include <sys/signal.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/types.h>

// networking libraries
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <ctype.h>

// Front Board, Camera Library
#include <pxa_lib.h>
#include <pxa_camera_zl.h>

// Core Functions Header
#include "moduls/threePoint.h"

// 
#define BAUDRATE B4800
#define MODEDEVICE "/dev/ttyS2"

// 3axis
#define MMA_SLEEP_MODE_ON 0x1001
#define MMA_SLEEP_MODE_OFF 0x1002
#define MMA_VIN_ON 0x1003
#define MMA_VIN_OFF 0x1004
#define MMA_SENS_15G 0x1005
#define MMA_SENS_20G 0x1006
#define MMA_SENS_40G 0x1007
#define MMA_SENS_60G 0x1008

int FoundFlag = 0; // infrared flag variable

char response;

VideoCopy bufCopy;
// 백보드, 3축 센서
int fdBackBoard;
int fdThreeAxis;

// 카메라, 오버레이
int fdCamera;
int fdOverlay2;
int fdInfra;

struct pxa_video_buf* vidbuf;
struct pxa_video_buf vidbuf_overlay;
int len_vidbuf;

// 네트워크 소켓
int fdPeerSock;
char peerBuf[10];
// static unsigned char rxbuf[3];

int stopflag = 0; // client stop?

//3axis 관련
static unsigned char rxbuf[3];
int tmprx;
int count1 = 0;

// Backboard Command 관련
int command = -1; // 시작할 때 무조건 전진
int oldcommand = -1;	
int count = -1;

// Fuction Prototypes
void initDevices(void); // Initialize Camera and Sensors
void initPeerSocket(void); // Initialize Networking Sockets
int openSerial(void);
void endProgram(void);

void *traceLine(void); // Caculate direction and produce command value
void *writeCommand(void); // Write command to backboard uart port

#ifdef SERVERMODE
int acceptClient(void);
void waitThreeAxisChange(void); // Wait for the change of 3-Axis sensor value
void sendStopSignal(void); // Send stop signal to client robot
#endif

#ifdef CLIENTMODE
int connectServer(void);
void *recieveStopSignal(void);
void *infraredDetecting(void);
#endif

void *read_func(void);
int manipulatemove(void);

void confirm_Response();
void* videoFrame(void);

void alertSound() {
	system("/usr/bin/aplay /root/MP3/BONK.WAV &");
}

int main(int argc, char* argv[]) {
/*    int write_buf;
    char read_buf;*/

	// Initialization
    initDevices();
    #ifndef WITHOUT_NETWORK
	initPeerSocket();
	#endif

	usleep(3000000); // delay 3sec

	#ifdef SERVERMODE
	#ifndef WITHOUT_NETWORK
	// Wait for arrival
	waitThreeAxisChange();
	sendStopSignal();
	#endif
	#endif

	// Strart linetracing
	int thr_id[4];
	pthread_t p_threads[4];

	thr_id[0] = pthread_create(&p_threads[0], NULL, traceLine, (void *)NULL);     
	if (thr_id[0] < 0)     
	{    
		perror("thread1 create error : ");  
		exit(0);    
	}

	thr_id[3] = pthread_create(&p_threads[3], NULL, videoFrame, (void *)NULL);     
	if (thr_id[3] < 0)     
	{    
		perror("thread1 create error : ");  
		exit(0);    
	}
	
	
	thr_id[1] = pthread_create(&p_threads[1], NULL, writeCommand, (void *)NULL);     
	if (thr_id[1] < 0) {    
		perror("command thread create error : ");  
		exit(0);    
	}
	
	/*
	thr_id[3] = pthread_create(&p_threads[3], NULL, infraredDetecting, (void*) NULL);
	if (thr_id[3] < 0) {    
		perror("command thread create error : ");  
		exit(0);    
	}
	*/
/*	
	
	#ifdef CLIENTMODE
	#ifndef WITHOUT_NETWORK
	thr_id[2] = pthread_create(&p_threads[2], NULL, recieveStopSignal, (void *)NULL);     
	if (thr_id[2] < 0) {    
		perror("command thread create error : ");  
		exit(0);    
	}
	
	
	#endif
	#endif
*/

	int status;
	#ifdef CLIENTMODE
//	pthread_join(p_threads[2], (void **)&status);
	#endif
	pthread_join(p_threads[0], (void **)&status);


	pthread_join(p_threads[1], (void **)&status);
	pthread_join(p_threads[3], (void **)&status);
	
	endProgram();

	return 0;
}  

// Initialize Camera and Sensors
void initDevices(void) {
	struct pxacam_setting camset;
	
	// Backboard uart init
	fdBackBoard = openSerial();

	// 3-axis sensor init 
	fdThreeAxis = open("/dev/MMA_ADC", O_RDONLY);
	ASSERT(fdThreeAxis);
	
	fdInfra = open("/dev/FOUR_ADC", O_RDWR | O_NOCTTY);
	ASSERT(fdInfra);

	ioctl(fdThreeAxis,MMA_VIN_ON, 0);
	ioctl(fdThreeAxis,MMA_SLEEP_MODE_ON, 0);
	ioctl(fdThreeAxis,MMA_SENS_60G, 0);

	// Camera init
	fdCamera = camera_open(NULL,0);
	ASSERT(fdCamera);
	
	system("echo b > /proc/invert/tb"); //LCD DriverIC top-bottom invert ctrl

	memset(&camset,0,sizeof(camset));
	camset.mode = CAM_MODE_VIDEO;
	camset.format = pxavid_ycbcr422;

	camset.width = 320;
	camset.height = 240;

	camera_config(fdCamera,&camset);
	camera_start(fdCamera);

	fdOverlay2 = overlay2_open(NULL,pxavid_ycbcr422,NULL, 320, 240, 0 , 0);

	overlay2_getbuf(fdOverlay2, &vidbuf_overlay);
	len_vidbuf = vidbuf_overlay.width * vidbuf_overlay.height;

	// init finish
	printf("Initializing Device Finished\n");	
}

// Initialize Networking Sockets
void initPeerSocket(void) {
	#ifdef SERVERMODE
	fdPeerSock = acceptClient();
	#endif

	#ifdef CLIENTMODE
	fdPeerSock = connectServer();
	#endif
}

void endProgram(void) {
	int i, cntdown = 3;
	
	// 정지
	command =26;
	for (i = 0; i < cntdown; i++) {
		usleep(COMMAND_DELAY); // delay
		write(fdBackBoard, &command, 1);
		printf("command: %d\n", command);
	}

	// 옆으로 피하는 코드 추가 필요

	camera_stop(fdCamera);
	camera_close(fdCamera);
}

// Caculate direction and produce command value
void *traceLine(void) {
	int notFoundCnt = 0;
	int idleCnt = 0;
	
	double delay_Time = 11.0;
	
	int must_Right = 1;
	
	response = -1;
	
	
	// 11 초를 B, 0.2 줄이고 0.1 씩 늘린다
	confirm_Response();
	if(response == 20)
	    delay_Time = 11;
	else if(response == 21)
	    delay_Time = 10.8;
	else if(response == 15)
	    delay_Time = 10.6;
	else if(response == 28)
	    delay_Time = 11.1;
	else if(response == 29)
	    delay_Time = 11.2;
	else if(response == 30)
	    delay_Time = 11.3;
	
//	command = 2;
	
	clock_t start = clock();
	
	while(stopflag == 0){
		//get frame from cam
		
		int direction = -1;	// 회전 방향 0이면 왼쪽, 1이면 오른쪽
		count = kdong(&bufCopy, &direction);
		
		/*
		if(count == -1) {
			notFoundCnt++;
		} else {
			notFoundCnt = 0;
		}
	
		if(notFoundCnt > 2) {
			direction = 0;
			count = 1;
			notFoundCnt--;
		}	
		*/
		
		
		double time = ((double)(clock() - start)) / CLOCKS_PER_SEC;
		/*
		if(must_Right == 1 && time > 5)
		{
		    direction = 1;
		    command = 6;
		    must_Right = 0;
		}
		*/
		//if(time < 11.5)
		//{
		    if (direction == 0) {
			    switch(count)
			    {		
				    case 0 : command = 2; break;
				    case 1 : command = 1; break;
				    case 2 : command = 1; break;
				    case 3 : command = 4; break;
			    }
		    }
		    else if (direction == 1) {
			    switch(count)
			    {		
				    case 0 : command = 2; break;
				    case 1 : command = 3; break;
				    case 2 : command = 3; break;
				    case 3 : command = 6; break;
			    }
		    }
		    else {
			    command = 2;
		    }
		  
		//}
		/*
		else
		{
		    if (direction == 0) {
			    switch(count)
			    {		
				    case 0 : command = 8; break;
				    case 1 : command = 7; break;
				    case 2 : command = 7; break;
				    case 3 : command = 22; break;
			    }
		    }
		    else if (direction == 1) {
			    switch(count)
			    {		
				    case 0 : command = 8; break;
				    case 1 : command = 9; break;
				    case 2 : command = 9; break;
				    case 3 : command = 24; break;
			    }
		    }
		    else {
			    command = 8;
		    }
		}
		*/
		
		// FoundFlag 
		if(time > 11.5)
		  stopflag = 1;
		///if(time > 12.5)
		//    stopflag = 1;
		
		// !!essential!!
		// put image to screen & clean buffer 
		idleCnt++;
		
	}	
}

// Write command to backboard uart port
void *writeCommand(void) {
	while (stopflag == 0) {
		usleep(COMMAND_DELAY); // delay

		if(oldcommand != command) {
//			printf("command: %d / oldcommand: %d\n", command, oldcommand);
			write(fdBackBoard, &command, 1);
			oldcommand = command;
		}
	}
}



#ifdef SERVERMODE
// Wait for the change of 3-Axis sensor value
int acceptClient(void) {

	printf("\n\n----in acceptClient-----\n");

	struct sockaddr_in srvAddr;	
	socklen_t addrlen;

	int fdListenSock;
	int fdPeerSock = -1;

	fdListenSock = socket(PF_INET, SOCK_STREAM, 0);  //IPPROTO_TCP);
	
	memset((void *)&srvAddr, 0,sizeof(srvAddr));
	srvAddr.sin_family = AF_INET;
	srvAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	srvAddr.sin_port = htons((u_short)10000);
	addrlen = sizeof(srvAddr);	
	
	printf("1 : %d\n", fdListenSock);	

	if(bind(fdListenSock, (struct sockaddr*)&srvAddr, sizeof(srvAddr)) >= 0){
		printf("2 : bind complete\n");
	}
	
	if(listen(fdListenSock, SOMAXCONN) >= 0 ){
		printf("3 : listen complete\n");
	}

	if(fdPeerSock == -1){
		printf("in?\n");
		fdPeerSock = accept(fdListenSock, (struct sockaddr*)&srvAddr, &addrlen);	
	} 

	if(fdPeerSock >= 0){
		printf("4 : fdPeerSock = %d\n", fdPeerSock);
	}
	
	printf("5 : all complete\n");
	
	close(fdListenSock);

	return fdPeerSock;
}

void waitThreeAxisChange(void) {
	count1 = 0;
	tmprx = 0;
	while(1)
	{
		read(fdThreeAxis, rxbuf, sizeof(rxbuf));
		usleep(100000);
//		printf("%d %d\n", rxbuf[0], rxbuf[1]);
//		printf("%d\n", count1);
		if(count1 == 0)
		{
			count1=1;
			tmprx = rxbuf[0];
		}
		else if(abs(tmprx-rxbuf[0])>=3)
		{
//			printf("in this area\n");
			//command = 29;
			//write(fdBackBoard,&command,1);
			break;
		}
		else if(count1 == 1)
		{
			count1++;
			tmprx = rxbuf[0];
		}	
	}
}

// Send stop signal to client robot
void sendStopSignal(void) {
	strcpy(peerBuf, "move");
	write(fdPeerSock, peerBuf, strlen(peerBuf)+1);
}
#endif

#ifdef CLIENTMODE
int connectServer(void) {
	struct sockaddr_in remoteAddr;
	struct hostent *hostInfo;
	int fdPeerSock;
	
	
	hostInfo = gethostbyname("192.168.0.40");
	
	
	fdPeerSock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	memset((void *) &remoteAddr, 0, sizeof(remoteAddr));
	remoteAddr.sin_family = AF_INET;
	memcpy((void *)&remoteAddr.sin_addr, hostInfo->h_addr, hostInfo->h_length);
	remoteAddr.sin_port=htons((u_short)10000);
	
	if(connect(fdPeerSock, (struct sockaddr*)&remoteAddr, sizeof(remoteAddr)) < 0) {
		ASSERT(fdPeerSock);
	}
	
	return fdPeerSock;
}

void *recieveStopSignal(void) {
	int bytesread = 0;
	while(bytesread == 0) {
		bytesread = read(fdPeerSock, peerBuf, sizeof(peerBuf));
		peerBuf[bytesread] = '\0';
	}
	printf("received something\n");

	stopflag = 1;
}

void *infraredDetecting(void){
	int i, flag;

	while(1){
		flag = 0;
		
		rxbuf[0]=0;
		rxbuf[1]=0;
		read(fdInfra, rxbuf, sizeof(rxbuf));
		//printf("not found yet\n");
		//printf("ch1 : %d, ch1 : %d\n", rxbuf[0], rxbuf[1]);
		if(rxbuf[0]>400 || rxbuf[1]>400){
			for(i=0; i<15; i++){
				rxbuf[0]=0;
				rxbuf[1]=0;
				//sleep(1);
				read(fdInfra, rxbuf, sizeof(rxbuf));
				//printf("found!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
				//printf("ch1 : %d, ch1 : %d\n", rxbuf[0], rxbuf[1]);

				if(rxbuf[0]<200 && rxbuf[1]<200){
					flag = 1;
					break;
				}
			}
			if(flag == 0)
				FoundFlag = 1;
		}
		else
			FoundFlag = 0;	
	}
}

#endif

int openSerial(void){
	char fd_serial[20];
    int fd;
    struct termios oldtio, newtio;

    strcpy(fd_serial, MODEDEVICE); //FFUART
    
    fd = open(fd_serial, O_RDWR | O_NOCTTY );
    if (fd <0) {
        printf("Serial %s  Device Err\n", fd_serial );
        exit(1);
    }
	printf("robot uart ctrl %s\n", MODEDEVICE);
    
    tcgetattr(fd,&oldtio); /* save current port settings */
    bzero(&newtio, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;
    newtio.c_lflag = 0;
    newtio.c_cc[VTIME]    = 0;   /* inter-character timer unused */
    newtio.c_cc[VMIN]     = 1;   /* blocking read until 8 chars received */
    
    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);
    
    return fd;
}

void *read_func(void ) {     
    char read_buf = 0;
 
	while(1)     
	{         
		//printf("in read thread\n");

	        read(fdBackBoard, &read_buf, 1);

	        if( read_buf != 0 ){
			//printf("Robot->Embedded [%d]\n", read_buf);
			read_buf = 0;
		}
	} 
}

int manipulatemove(void) {
	fdBackBoard = open("/dev/ttyS2", O_RDWR | O_NOCTTY);
	if(fdBackBoard <0)
	{
		return -1;
	}
	command = 5;
	write(fdBackBoard, &command, 1);
	int tmp =0;
	while(1)
	{
		if((command) != -1)
		{
			write(fdBackBoard, &command, 1);
			read(fdBackBoard, &tmp, 1);
		}
	}
}

void confirm_Response(){
	
	
	while(1)     
	{         
		if(read(fdBackBoard, &response, 1) > 0)	// 읽는데 성공하면 루프 탈출
		{
		//	printf("response message : %d\n", response);
			break;
		}
	} 
}

void* videoFrame(void){
	int cnt = 0;
	
	VideoCopy black;
		
	
	while(1){
		vidbuf = camera_get_frame(fdCamera);
		
		memcpy(vidbuf_overlay.ycbcr.y,vidbuf->ycbcr.y,len_vidbuf);
		memcpy(vidbuf_overlay.ycbcr.cb,vidbuf->ycbcr.cb,len_vidbuf/2);
		memcpy(vidbuf_overlay.ycbcr.cr,vidbuf->ycbcr.cr,len_vidbuf/2);
		
		memcpy(bufCopy.ycbcr.y,vidbuf->ycbcr.y,len_vidbuf);
		memcpy(bufCopy.ycbcr.cb,vidbuf->ycbcr.cb,len_vidbuf/2);
		memcpy(bufCopy.ycbcr.cr,vidbuf->ycbcr.cr,len_vidbuf/2);
		
		camera_release_frame(fdCamera,vidbuf);
			
		if(stopflag == 1)
			break;
	}
	
	camera_stop(fdCamera);
	camera_close(fdCamera);
}
