#include "threePoint.h"


//#define START_Y 135	// 빨갱이
#define START_Y 150	// 노랭이, 변경

#define END_Y 70	

#define START_LEFT_X 1

#define START_MID_X 107

#define START_RIGHT_X 213

#define END_X 319

#define MAX_X 320

#define MAX_Y 240

#define WIDTH 320

#define HEIGHT 240

#define _TRUE_ 1

#define _FALSE_ 0

int FOUND_RED = 0;

int FOUND_BLUE = 0;

int FOUND_YELLOW = 0;

const int BM_SIZE = 5;
const int BM_MID = 2;

  // 코봇 동방
const ColorBoundary blue_B = {190, 250, 40, 100, 40, 100};

const ColorBoundary red_B = {345, 15, 45, 100, 56, 100};
const ColorBoundary yellow_B = {50, 76, 50, 100, 81, 100};

  // 7호관 2층
//const ColorBoundary blue_B = {190, 250, 40, 100, 20, 100};

//const ColorBoundary red_B = {345, 15, 45, 100, 30, 100};

//const ColorBoundary yellow_B = {43, 76, 40, 100, 40, 100};

extern int command;


int flag = 0;
    

int kdong(VideoCopy* buf,int * direction){



    int pR,pB,pY; // pointRed, pointBlue, pointYellow

    int p;

    pR=pB=pY=-1;

    FOUND_RED = FOUND_BLUE = FOUND_YELLOW = 0;

   

    getPoint(buf,&pR,&pB,&pY);

    p = positioning(pR,pB,pY);

	
	
    if(p < MAX_X/2) *direction = 1;	// 우 회전

    else if(p >= MAX_X/2) *direction = 0;	// 좌 회전


//	printf("p : %d, direction : %d\n", p, *direction);

    int count = getCount(p);

    return count;

}

/* 색깔의 중점을 찾아주는 함수 */

void getPoint(VideoCopy* buf,int* pR,int* pB,int* pY){

    int order_r[3] = {1,2,3}; // 색깔별 search 구역 순서

    int order_b[3] = {2,1,3};

    int order_y[3] = {3,2,1};

    *pR = getMidPoint(buf,order_r, red_B);
    
    *pB = getMidPoint(buf,order_b, blue_B);

    *pY = getMidPoint(buf,order_y, yellow_B);

    if(*pR != -1) FOUND_RED = 1; // 각 색깔별로 찾았는지 검사

    if(*pB != -1) FOUND_BLUE = 1;

    if(*pY != -1) FOUND_YELLOW = 1;

}

/* 주어진 구역에서 점을 잡아 반한하는 함수 */

int getMidPoint(VideoCopy* buf,int* order, ColorBoundary color_B){

    int found,areaPoint;
    int i;
found = areaPoint = 0;

    for(i=0;i<3;i++){
	if(!found)    areaPoint = InAreaPoint(buf,order[i],&found, color_B);
	else break;
	}

    if(found) return areaPoint;

    return -1;

}

/* 구역 별 점을 찾아 주는 함수 */

int InAreaPoint(VideoCopy* buf,int area,int* found,ColorBoundary color_B){

    int start,end;

    int temp;

    switch(area){

    case 1: start = START_LEFT_X;

        end = START_MID_X; break;

    case 2: start = START_MID_X;

        end = START_RIGHT_X; break;

    case 3: start = START_RIGHT_X;

        end = END_X; break;

    }

	int x, y;
	for(x=start; x<end; x++){
		y = START_Y;		
		
		HSV hsv = ycbcr2HSV(buf, x, y);
			
 	  if(!(*found) && isColor(hsv, color_B) && noiseFiltering(buf, x, y, color_B))
	  { 		// 색깔을 만나면
	
                *found = 1;

                temp = x;

 //              printf("Fitst Found = x : %d, y : %d\n",x,y);

            } else{

  //              x+=3;

            }

            if(*found && !isColor(hsv, color_B)){ // 색깔이 끝나면

  //              printf("Last Found = x : %d, y : %d\n",x,y);

                return (temp+x)/2;

            }
	}

if(*found) return (temp+end)/2;

	for(x=start; x<end; x++){
		y = END_Y;		
		HSV hsv = ycbcr2HSV(buf, x, y);
			

 	  if(!(*found) && isColor(hsv, color_B) && noiseFiltering(buf, x, y, color_B))
	  { 		// 색깔을 만나면
	
                *found = 1;

                temp = x;

 //              printf("Fitst Found = x : %d, y : %d\n",x,y);

            } else{

  //              x+=3;

            }

            if(*found && !isColor(hsv, color_B)){ // 색깔이 끝나면

  //              printf("Last Found = x : %d, y : %d\n",x,y);

                return (temp+x)/2;

            }


	}

	if(*found) return (temp+end)/2;

	

	for(y = START_Y; y>END_Y; y--){
		x = end;
HSV hsv = ycbcr2HSV(buf, x, y);
			

 	  if(!(*found) && isColor(hsv, color_B) && noiseFiltering(buf, x, y, color_B))
	  { 		// 색깔을 만나면
	
                *found = 1;

                temp = x;

 //              printf("Fitst Found = x : %d, y : %d\n",x,y);

            } else{

  //              x+=3;

            }

            if(*found && !isColor(hsv, color_B)){ // 색깔이 끝나면

  //              printf("Last Found = x : %d, y : %d\n",x,y);

                return (temp+x)/2;

            }
	}

if(*found) return (temp+end)/2;

for(y = START_Y; y>END_Y; y--){
		x = start;
		HSV hsv = ycbcr2HSV(buf, x, y);
			

 	  if(!(*found) && isColor(hsv, color_B) && noiseFiltering(buf, x, y, color_B))
	  { 		// 색깔을 만나면
	
                *found = 1;

                temp = x;

 //              printf("Fitst Found = x : %d, y : %d\n",x,y);

            } else{

  //              x+=3;

            }

            if(*found && !isColor(hsv, color_B)){ // 색깔이 끝나면

  //              printf("Last Found = x : %d, y : %d\n",x,y);

                return (temp+x)/2;

            }
	}

if(*found) return (temp+end)/2;
/*
	int x, y;
    for(y=START_Y; y>END_Y; y--){

        for(x=start; x<end; x++){

            

            HSV hsv = ycbcr2HSV(buf, x, y);
			

 	  if(!(*found) && isColor(hsv, color_B) && noiseFiltering(buf, x, y, color_B))
	  { 		// 색깔을 만나면
	
                *found = 1;

                temp = x;

 //              printf("Fitst Found = x : %d, y : %d\n",x,y);

            } else{

  //              x+=3;

            }

            if(*found && !isColor(hsv, color_B)){ // 색깔이 끝나면

  //              printf("Last Found = x : %d, y : %d\n",x,y);

                return (temp+x)/2;

            }

        }

    }

    if(*found) return (temp+end)/2;
*/
}



int isColor(HSV hsv, ColorBoundary color_B){

    if(color_B.hmax < color_B.hmin){    // 색이 Red 일 경우

        if(hsv.h >= color_B.hmin && hsv.h <= 360 &&

            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&

             hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

           

            return _TRUE_;

        else if(hsv.h >= 0 && hsv.h <= color_B.hmax &&

            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&

            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

           

            return _TRUE_;

        else

            return _FALSE_;

    }

    else{    // 그 외 보통 경우

        if(hsv.h >= color_B.hmin && hsv.h <= color_B.hmax &&

            hsv.s >= color_B.smin && hsv.s <= color_B.smax &&

            hsv.v >= color_B.vmin && hsv.v <= color_B.vmax)

            return _TRUE_;

        else

            return _FALSE_;

    }

}


int  noiseFiltering(VideoCopy* buf, int x, int y, ColorBoundary color_B) {

    HSV val;

   

    int cnt = 0;

   

    int i, j;

    int s, t;

   

    for (i = 0; i < BM_SIZE; ++i) {

        for (j = 0; j < BM_SIZE; ++j) {

            s = x - BM_MID + i;

            t = y - BM_MID + j;

            if (checkBufBoundary(s, t)) {

                val = ycbcr2HSV(buf, s, t);

                if (isColor(val, color_B)) {

                    cnt++;

                    if (cnt > 3) {

                        break;

                    }

                }

            }

        }

    }

    return (cnt > 3) ? _TRUE_ : _FALSE_;

}

HSV ycbcr2HSV(VideoCopy* buf,int x, int y){
	int r, g, b;
	float h, s, v;


	
	ycbcr2rgb(buf, x, y, &r, &g, &b);	// ycbcr422 -> rgb

	RGBtoHSV(r, g, b, &h, &s, &v);		// rgb -> HSV

	HSV hsv = {h, s, v};
	return hsv;
}

void ycbcr2rgb(VideoCopy* buf, int cx, int cy, int* r, int* g, int* b){

	int y, cb, cr;
	int index = cy * MAX_X + cx;
	
	*r = *g = *b = 0;
	
	// set ycbcr val
	y = buf->ycbcr.y[index];
	cb = buf->ycbcr.cb[index/2];
	cr = buf->ycbcr.cr[index/2];


	*r = min( max( ((y-16))*255.0/219.0 + 1.402*((cr-128)*255.0)/224.0 + 0.5 ,  0 ) ,  255);
	*g = min( max( ((y-16))*255.0/219.0 - 0.344*((cb-128)*255.0)/224.0 - 0.714*((cr-128)*255.0)/224.0 + 0.5 ,  0 ) ,  255);
	*b = min( max( ((y-16))*255.0/219.0 + 1.772*((cb-128)*255.0)/224.0 + 0.5 , 0 ) ,  255);

}

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
	float min, max, delta;
	
	min = MIN_3(r, g, b);
	max = MAX_3(r, g, b);
	*v = max; // v
	
	delta = max - min;

	if(delta == 0){

		*s = 0;
		*h = 0;
		*v = *v / 255.0;
		return;
	}

	if( max != 0 )
		*s = delta / max; // s
	else {
		// r = g = b = 0 // s = 0, v is undefined
		*s = 0;
		*h = -1;
		return;
	}

	if( r == max )
		*h = ( g - b ) / delta; // between yellow & magenta

	else if( g == max )
		*h = 2 + ( b - r ) / delta; // between cyan & yellow

	else
		*h = 4 + ( r - g ) / delta; // between magenta & cyan
	
	*h *= 60; // degrees
	if( *h < 0 )
		*h += 360;

	*s *= 100;
	*v = *v / 255 * 100;
}

int checkBufBoundary(int x, int y){

    return (x >= 0) && (x < MAX_X) && (y >= 0) && (y < MAX_Y);

}

/* 구한 색깔 별 중점을 통해 이동할 방향을 결정해주는 함수 */

/* 앞으로 구현 */

int positioning(int pR,int pB,int pY){
	int p = MAX_X/2; //X값의 정 중앙으로 초기화
  
    if(FOUND_RED && FOUND_BLUE && FOUND_YELLOW){

        p = pB;
//	flag = !flag;
        // RED & YELLOW 추가

    }

       

    else if(FOUND_RED && FOUND_BLUE){
	p = pB;
	
	if(pB<=80){ 
	    p = 280; // 약회전 하도록 임의값 삽입
	    return p;
	}

//	flag = !flag;
    }

    else if(FOUND_BLUE && FOUND_YELLOW){

        p = (pB*2/3+pY*1/3);
	if(pB>=240)  // 약회전 하도록 임의값 삽입
        {
	    p = 40;
	    return p;
	}
	return p;
//	flag = !flag;
    }

    else if(FOUND_RED){
	
        p = 301;
	
	return p;
    }

    else if(FOUND_BLUE){

        p = pB;
	
//	flag = !flag;
    }

   

    else if(FOUND_YELLOW){

        p = 19;
	
//	command = 26;
//	usleep(5000000);
	
	return p;
    }

    else{

        // ELSE 추가
//	command = 26;
//	usleep(2000000);
    }

   
//   if(flag != 0)
//   {
	p = p + 30; // 이전 30
	
	if(p > 319)
	p = 319;
//   }
   
   return p;

}

int getCount(int p){

    int distance = abs(MAX_X/2 - p);

 
    if(distance < 80) { // 이전 80

//    printf("직진, dist : \t%d\n", distance);

    return 0;     // 직진

    }

   

//    else if(distance < 20){

//    printf("약하게 회전, dist : %d\n", distance);

//     return 0;     // 약하게 회전

//    }

       

//    else if(distance < 120){

//    printf("중간 회전, dist : %d\n", distance);

//     return 1;     // 중간세기로 회전

//    }   

   

    else if(distance < 140){ // 이전 140

//    printf("강 회전, dist : \t\t%d\n", distance);

    return 2;     // 회전

    }

       

    else{

//    printf("최강 회전, dist : \t\t\t%d\n", distance);

        return 3;            // 매우 강하게 회전

    }


    return -1;
}

