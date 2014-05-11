#ifndef    _THREE_POINT_H_

#define    _THREE_POINT_H_

#include <math.h>

#include <stdio.h>
#include <pxa_lib.h>
#include <pxa_camera_zl.h>

#define MAX_X	320
#define MAX_Y	240
#define max(a,b) (((a)>(b))? (a):(b))
#define min(a,b) (((a)<(b))? (a):(b))

#define MAX_3(a, b, c)	( ((a)>(b)) ? ( (((a)>(c)) ? (a) : (c)) ) : ( (((b)>(c)) ? (b) : (c)) ) )
#define MIN_3(a, b, c)	( ((a)>(b)) ? ( (((b)>(c)) ? (c) : (b)) ) : ( (((a)>(c)) ? (c) : (a)) ) )

typedef struct{
  struct{
    unsigned char y[MAX_X*MAX_Y]; 
    unsigned char cb[MAX_X*MAX_Y/2];
    unsigned char cr[MAX_X*MAX_Y/2];
  }ycbcr;
} VideoCopy;

typedef struct{

    int hmin;

    int hmax;

    int smin;

    int smax;

    int vmin;

    int vmax;

}ColorBoundary;

typedef struct{

    float h;

    float s;

    float v;

}HSV;

int kdong(VideoCopy* buf,int * direction);

void getPoint(VideoCopy* buf,int* pR,int* pB,int* pY);

int getMidPoint(VideoCopy* buf,int* order, ColorBoundary);

int InAreaPoint(VideoCopy* buf,int area,int* found,ColorBoundary);

int positioning(int pR,int pB,int pY);

int getCount(int p);

int isColor(HSV hsv, ColorBoundary color_B);

int  noiseFiltering(VideoCopy* buf, int x, int y, ColorBoundary color_B);

HSV ycbcr2HSV(VideoCopy* buf,int x, int y);

void ycbcr2rgb(VideoCopy* buf, int cx, int cy, int* r, int* g, int* b);

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v );

int checkBufBoundary(int x, int y);

#endif
