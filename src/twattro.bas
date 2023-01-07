'
'                         UNLEASHED VECTOR SCROLL INTRO
'
'===============================================================================

        option explicit
        option static

'-------------------------------------
' Includes
'-------------------------------------

    #include "GL/gl.bi"
    #include "GL/glu.bi"
    #include "windows.bi"
    '#include "tinysid.bi"
    '#include "storm.bas"
    #INCLUDE "upppal.bas"
    #INCLUDE "uppraw.bas"  
    
    '--------------
    '--Image size--
    '--------------
    
    Const imgX = 512
    Const imgY = 128

    
    Declare Sub DrawImage(byval imxpos as integer,byval imypos as integer)
    Declare Sub LoadDataImage()    
    'Picture buffer
    Dim Shared img_buffer( imgx * imgy ) as integer    
    'RGB color palette buffer
    Dim Shared img_r(256), img_g(256), img_b(256) as short    
    LoadDataImage()



    DIM SHARED AS BYTE W_FULLSCREEN =1 : ' 1 = FULLSCREEN
    DIM SHARED AS INTEGER W_XO =0      : ' X pos of window
    DIM SHARED AS INTEGER W_YO =0      : ' Y pos of window    
    DIM SHARED AS INTEGER W_XW =1024    : ' Width.
    DIM SHARED AS INTEGER W_YH =768    : ' Height.

    DIM SHARED pfd as PIXELFORMATDESCRIPTOR
    DIM SHARED hdc as hDC
    DECLARE SUB InitOGL()


    DIM SHARED AS INTEGER STARS=1000
    DIM SHARED AS DOUBLE VVX(STARS)
    DIM SHARED AS DOUBLE VVY(STARS)
    DIM SHARED AS DOUBLE VVZ(STARS)

    DIM SHARED AS INTEGER CUBES=400
    DIM SHARED AS DOUBLE CCX(CUBES)
    DIM SHARED AS DOUBLE CCY(CUBES)
    DIM SHARED AS DOUBLE CCZ(CUBES)


    dim shared as integer SRX=300
    dim shared as integer SRY=8
    
    DIM SHARED AS DOUBLE  SSX(SRX,SRY)
    DIM SHARED AS DOUBLE  SSY(SRX,SRY)
    DIM SHARED AS DOUBLE  SSZ(SRX,SRY)
    DIM SHARED AS INTEGER SSF(SRX,SRY)
    
    DECLARE SUB SCROLLINIT()
    DECLARE SUB STARINIT()
    DECLARE SUB QUADBARS()
    DECLARE SUB STARFIELD()
    DECLARE SUB CUBEFIELD()
    DECLARE SUB DRAW_SCROLLER()
    DECLARE SUB UPDATE_SCROLLER()
    DECLARE SUB UTMATRIX(BYVAL CH  AS INTEGER)        
    DECLARE SUB PRECALC()
    DECLARE SUB LETTERNEW(BYVAL CH  AS INTEGER, BYVAL XX AS DOUBLE,BYVAL YY AS DOUBLE,BYVAL ZZ AS DOUBLE)
    DECLARE SUB WRITER()
    
    STARINIT()
    SCROLLINIT()

	DIM SHARED XR AS SINGLE : ' X ROTATION
	DIM SHARED YR AS SINGLE : ' Y ROTATION
	DIM SHARED ZR AS SINGLE : ' Z ROTATION
    

DIM D AS INTEGER
DIM SHARED AS DOUBLE GX,GY,GZ,TW,ZRR,XRR,YRR,RRR,delta,mm,fr,scoffz

mm=timer
        'SID_init()
        'sleep 200
        'sid_loadsong(@storm(0),4052,SID_TYPE_MEMORY)
        'SID_play(0)  
        'sleep 200

    dim SHARED LightAmbient(0 to 3) as single =>  {.4, .4, .4,1.0}   '' Ambient Light is 20% white
    dim SHARED LightPosition(0 to 2) as single => {0.0, 0.0 ,0.0   }  '' Position is somewhat in front of screen


InitOGL()

'===============================================================================
' LOGO XOR TEXTURE GENERATION;
'===============================================================================
    DIM SHARED AS UINTEGER LOGOBUFFER ( 512 * 128 )
    DIM SHARED tex1 AS GLUINT 
	DIM AS UINTEGER X,Y,PIXEL
	    
    DRAWIMAGE(0,0)
    
	glGenTextures 1, @tex1
	glBindTexture(GL_TEXTURE_2D, tex1)
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR)
	gluBuild2DMipmaps (GL_TEXTURE_2D, 3, 512, 128,GL_RGBA, GL_UNSIGNED_BYTE, @LOGOBUFFER(0))  



    DIM SHARED FACE1(0 to 3) AS SINGLE => {0.4, .0, .0,0.05}  :' bar face
    DIM SHARED FACE2(0 to 3) AS SINGLE => {0.7, .0, .0,0.05}  :' bar face
    DIM SHARED FACE3(0 to 3) AS SINGLE => {1.0, 1.0, 1.0,1.0 }  :' LOGO

    DIM SHARED FACE4(0 to 3) AS SINGLE => {.9,  .4,  .1,0.5 }  :' scroller
    DIM SHARED FACE5(0 to 3) AS SINGLE => {.6,  .1,  .1,0.5 }  :' scroller    
    
    DIM SHARED FACE6(0 to 3) AS SINGLE => {0.6,  .0,  .0,0.5 }  :' scube1    
    DIM SHARED FACE7(0 to 3) AS SINGLE => {0.4,  .4,  .0,0.5 }  :' scube2
    DIM SHARED FACE8(0 to 3) AS SINGLE => {0.1,  .1,  .1,0.5 }  :' scube3
    
    DIM SHARED FACE9(0 to 3) AS SINGLE => {0.3,  .0,  .0,0.6 }  :' scube3
    DIM SHARED FACEA(0 to 3) AS SINGLE => {0.1, 0.1, 0.1,1.0 }  :' LOGO
    
        
    
    
    DIM SHARED AS STRING MESS
        MESS=""
        mess=mess+"PREPARE TO BE UNLEASHED!!!!        "
        mess=mess+"YES WE ARE BACK WITH A NEW GIFT FOR YOU.     GREETINGS TO...........  "
        mess=mess+"INTRO CREATED BY     --ELECTRIC DRUGGIES--      "    
        mess=mess+"CODE BY WIDOWMAKER     "    
        mess=mess+"MUSIC BY NOISEMAKER     "    
        mess=mess+"LOGO BY ILLUSIONMAKER      "            
        mess=mess+"       SEE YOU NEXT TIME           "   



    DIM SHARED AS STRING NFO(10)
    NFO(1)="UNLEASHED CRACKED"
    NFO(2)="================="
    NFO(3)=""
    NFO(4)="GAME NAME"
    NFO(5)="FROM SOFTWARE COMPANY"
    NFO(6)=""
    NFO(7)="RELEASED ON THE"
    NFO(8)="00-00-2008"
    NFO(9)=""
    NFO(10)="PREPARE TO BE UNLEASHED!"



    DIM SHARED AS INTEGER LATRIX ( 9 , 8)
    DIM SHARED AS INTEGER P=1
    DIM SHARED AS INTEGER MLINE=1
    
    DIM SHARED FONT (64 * 64) as Uinteger : ' FONT BUFFER
    PRECALC()
    
'===============================================================================
' MAIN LOOP
'===============================================================================
WHILE((GetAsyncKeyState(VK_ESCAPE)<>-32767))
'-------------------------------------------------------------------------    
'       OPENGL STUFF;
'-------------------------------------------------------------------------

        GLLOADIDENTITY
        GLCLEAR(GL_DEPTH_BUFFER_BIT + GL_COLOR_BUFFER_BIT )    
        GLFLUSH()             
        STARFIELD()
        CUBEFIELD()
        DRAW_SCROLLER()        
        GLENABLE GL_BLEND
        WRITER()
        GLDISABLE GL_BLEND

        GLDISABLE GL_DEPTH_TEST
        QUADBARS()    
        GLENABLE GL_DEPTH_TEST

'-------------------------------------------------------------------------
'       DELTA TIMING;
'-------------------------------------------------------------------------    
        TW=TIMER
        FR=FR+1
        XR = XR + DELTA
		YR = 90 + 15*SIN(TIMER/2)
		ZR = ZR + DELTA*13
'-------------------------------------------------------------------------        
        IF TIMER-MM>=0.03 THEN
                                DELTA=.35/FR
                                MM=TIMER
                                FR=0
        END IF
'-------------------------------------------------------------------------
'       DOUBLE BUFFERING;
'-------------------------------------------------------------------------
        UPDATE_SCROLLER()
        SWAPBUFFERS(hDC)    
        SLEEP 1
WEND

'==========================================================================
' END OF MAIN LOOP
'==========================================================================

        'SID_STOP()
        'SID_SHUTDOWN()
        
END


SUB WRITER()



DIM AS DOUBLE XXP,YYP,TV
TV=(.1*SIN(TIMER*2))-2

    
DIM AS INTEGER A,B

    YYP=.5


    FOR A=1 TO 10
            YYP=(-A*.12)+.125
            XXP=(-((LEN(NFO(A))*.11)/2))+.125
            FOR B=1 TO LEN(NFO(A))
            LETTERNEW ( ASC(MID(NFO(A),B,1))-31,XXP,YYP,TV)
            XXP=XXP+.11
            NEXT
            
            
    NEXT

END SUB


'--------------------------------------------------------------------------
' PUT THE SMALL CUBES INTO THE STARFIELD
'--------------------------------------------------------------------------

SUB CUBEFIELD
    
    
    DIM SS AS DOUBLE
    SS=DELTA*1.5
    DIM A AS INTEGER
    GLVIEWPORT 0, 0, w_xw, w_yh    
    GLPUSHMATRIX        
    GLENABLE GL_FOG
    GLENABLE GL_LIGHTING
    

    glRotatef(0,  1.0, 0.0, 0.0)    
    glRotatef(0,  0.0, 1.0, 0.0)    
    glRotatef(yr, 0.0, 0.0, 1.0)    

    glTranslatef(0, 0, -8)         
    FOR A=0 TO CUBES

    
    
    

    GLBEGIN GL_QUADS
            GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE8(0))
            GLNORMAL3F 0,0,1
            GLVERTEX3F CCX(A)-.5,CCY(A)-.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)-.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)+.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)-.5,CCY(A)+.5,(CCZ(A)+.25)

            GLNORMAL3F 0,0,-1
            GLVERTEX3F CCX(A)-.5,CCY(A)+.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)+.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)-.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)-.5,CCY(A)-.5,(CCZ(A)-.25)
            
            GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE7(0))
            GLNORMAL3F 0,1,0
            GLVERTEX3F CCX(A)-.5,CCY(A)+.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)+.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)+.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)-.5,CCY(A)+.5,(CCZ(A)-.25)
            
            GLNORMAL3F 0,-1,0
            GLVERTEX3F CCX(A)-.5,CCY(A)-.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)-.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)-.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)-.5,CCY(A)-.5,(CCZ(A)+.25)

            GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE6(0))
            GLNORMAL3F -1,0,0
            GLVERTEX3F CCX(A)-.5,CCY(A)-.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)-.5,CCY(A)+.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)-.5,CCY(A)+.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)-.5,CCY(A)-.5,(CCZ(A)-.25)

            GLNORMAL3F 1,0,0
            GLVERTEX3F CCX(A)+.5,CCY(A)-.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)+.5,(CCZ(A)-.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)+.5,(CCZ(A)+.25)
            GLVERTEX3F CCX(A)+.5,CCY(A)-.5,(CCZ(A)+.25)

    GLEND
    
    CCz(a)=CCz(a)+SS
    if CCz(a)>=40 then 
        CCz(a)=CCz(a)-80

    END IF
    NEXT
    GLDISABLE GL_LIGHTING
    GLDISABLE GL_FOG
    GLPOPMATRIX

END SUB





'--------------------------------------------------------------------------
' READ THE FONT;
'--------------------------------------------------------------------------

SUB PRECALC()
            dim lp
        FOR LP=1 TO (64*64)
                READ FONT(LP)
        NEXT
 
END SUB


'--------------------------------------------------------------------------
' THIS WORKS ON THE ARRAY ELEMENTS OF THE SCROLL TO ADVANCE IT AND SET
' NEW LETTERS ETC.
'--------------------------------------------------------------------------

SUB UPDATE_SCROLLER()
    DIM AS INTEGER X,Y
    '---------------------
    ' SCROLL VALUE;
    '---------------------    
    SCOFFZ=SCOFFZ-(DELTA*3)    
    IF SCOFFZ<-1 THEN 

    '---------------------
    ' MOVE ON/OFF VALUES ONE PLACE TO THE LEFT;
    '---------------------    
        FOR Y=1 TO SRY    
        FOR X=2 TO SRX
                SSF(X-1,Y)=SSF(X,Y)
        NEXT
        NEXT

    '---------------------
    ' GRAB SOME NEW VALUES FOR THE END LINE;
    '---------------------    

        FOR Y=1 TO SRY                
    IF MLINE<9 THEN        
                SSF(SRX,Y)=LATRIX(MLINE,Y)
    ELSE
                SSF(SRX,Y)=0
    END IF

        NEXT
    '---------------------
    ' GET A NEW LETTER IF WE'VE SROLLED OVER BY ONE!
    '---------------------   

    MLINE=MLINE+1
    IF MLINE>9 THEN
        UTMATRIX(ASC(MID(MESS,P,1))-31)
        P=P+1
        IF P>LEN(MESS) THEN P=1
    END IF
    SCOFFZ=SCOFFZ+1
    
    
    END IF

END SUB



SUB DRAW_SCROLLER()

    DIM AS INTEGER X,Y
    DIM A AS INTEGER
    
    GLLOADIDENTITY
    GLENABLE GL_LIGHTING
    
    GLPUSHMATRIX
    glTranslatef(0, 0 ,  -20)    
    glRotatef(3 , 1.0, 0.0, 0.0)
    glRotatef(YR, 0.0, 1.0, 0.0)
    glRotatef(ZR, 0.0, 0.0, 1.0)    
    
        
        FOR Y=1 TO SRY    

            FOR X=1 TO SRX
                
IF SSF(X,Y)=1 THEN
            GLBEGIN GL_QUADS
            if y<=3 then GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACEA(0))
            if y>3 and y<=5 then GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE4(0))
            if y>5 then GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE5(0))
            
            GLNORMAL3F 0,0,1
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)-.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)-.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)+.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)+.5,(SSZ(X,Y)+.5)+SCOFFZ

            GLNORMAL3F 0,0,-1
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)+.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)+.5,(SSZ(X,Y)-.5)+SCOFFZ         
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)-.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)-.5,(SSZ(X,Y)-.5)+SCOFFZ
            
            GLNORMAL3F 0,1,0
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)+.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)+.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)+.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)+.5,(SSZ(X,Y)-.5)+SCOFFZ
            
            GLNORMAL3F 0,-1,0
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)-.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)-.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)-.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)-.5,(SSZ(X,Y)+.5)+SCOFFZ

            GLNORMAL3F -1,0,0
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)-.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)+.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)+.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)-.5,SSY(X,Y)-.5,(SSZ(X,Y)-.5)+SCOFFZ

            GLNORMAL3F 1,0,0
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)-.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)+.5,(SSZ(X,Y)-.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)+.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLVERTEX3F SSX(X,Y)+.5,SSY(X,Y)-.5,(SSZ(X,Y)+.5)+SCOFFZ
            GLEND    
END IF            
            NEXT
        NEXT

        GLPOPMATRIX
        GLDISABLE GL_LIGHTING
        
END SUB



SUB SCROLLINIT
    DIM AS DOUBLE FLX,FLY
    DIM AS INTEGER X,Y
    
    FLY=-((SRY-1)/2)
    FOR Y=1 TO SRY
        FLX=-((SRX-1)/2)
        FOR X=1 TO SRX
            
            SSX(X,Y)=0
            SSY(X,Y)=FLY
            SSZ(X,Y)=FLX
            SSF(X,Y)=0

        FLX=FLX+1     
        NEXT
        FLY=FLY+1
    NEXT
    
END SUB

SUB STARFIELD
    
    DIM SS AS DOUBLE
    SS=DELTA*1.5
    DIM A AS INTEGER
    GLDISABLE(GL_LIGHTING)
    GLENABLE GL_FOG
GLPUSHMATRIX
'    GLUPERSPECTIVE 105.0, W_XW / W_YH, .1, 100.0  
    glTranslatef(0, 0, -8)     
    glRotatef(0 , 1.0, 0.0, 0.0)
    glRotatef(0, 0.0, 1.0, 0.0)
    glRotatef(yr, 0.0, 0.0, 1.0)    
    GLVIEWPORT 0, w_yh*.05 , w_xw, w_yh*.8 


    FOR A=0 TO STARS



    GLBEGIN GL_LINES

        GLCOLOR3F .9, .9 ,.9
        GLVERTEX3F vvx(a),vvy(a),vvz(a)
        GLCOLOR3F 1.0, 1.0 ,1.0                            
        GLVERTEX3F vvx(a),vvy(a),vvz(a)+.35        

    GLEND


    vvz(a)=vvz(a)+SS
    if vvz(a)>=10 then 
        vvz(a)=vvz(a)-50

    END IF
    NEXT
'    GLUPERSPECTIVE 105.0, W_XW / W_YH, .1, 100.0  
GLPOPMATRIX
GLENABLE (GL_LIGHTING)
GLDISABLE GL_FOG
END SUB


SUB QUADBARS()
    
    GLENABLE GL_LIGHTING
    GLPUSHMATRIX
    glloadidentity
    
    DIM AS DOUBLE  SMALL =.15 :' WIDTH OF SMALL BARS
    DIM AS DOUBLE  SLENG = 32 :' LENGTH OF SMALL BARS
    DIM AS DOUBLE  LARGE =1.5 :' WIDTH OF LARGE BARS
    DIM AS DOUBLE  BLENG =8  :' LENGTH OF LARGE BARS
    



        glTranslatef(0, 0, -7) 
        glRotatef(320*sin(timer/2), 1.0, 0.0, 0.0)
        glRotatef(0, 0.0, 1.0, 0.0)
        glRotatef(0, 0.0, 0.0, 1.0)   

        DIM QO AS DOUBLE
        QO=0    
    







    GLVIEWPORT 0,w_yh*.35, w_xw,w_yh


glbegin gl_quads
GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE2(0))
        GLCOLOR3F 0.0,0.0,0.4
        glnormal3f 0,0,1
        glvertex3f -SLENG,-SMALL,SMALL
        glvertex3f  SLENG,-SMALL,SMALL
        glvertex3f  SLENG, SMALL,SMALL
        glvertex3f -SLENG, SMALL,SMALL
'
        GLCOLOR3F 0.0,0.0,0.6
        glnormal3f 0,0,-1
        glvertex3f -SLENG, SMALL,-SMALL
        glvertex3f  SLENG, SMALL,-SMALL
        glvertex3f  SLENG,-SMALL,-SMALL
        glvertex3f -SLENG,-SMALL,-SMALL
GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE1(0))
        GLCOLOR3F 0.0,0.0,0.8
        glnormal3f 0,-1,0
        glvertex3f -SLENG,-SMALL,-SMALL
        glvertex3f  SLENG,-SMALL,-SMALL
        glvertex3f  SLENG,-SMALL,SMALL
        glvertex3f -SLENG,-SMALL,SMALL'
'
        GLCOLOR3F 0.0,0.0,1.0
        glnormal3f 0,1,0
        glvertex3f -SLENG,SMALL,SMALL
        glvertex3f  SLENG,SMALL,SMALL        
        glvertex3f  SLENG,SMALL,-SMALL     
        glvertex3f -SLENG,SMALL,-SMALL
glend


    GLVIEWPORT 0,-w_yh*.45, w_xw,w_yh


glbegin gl_quads
GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE2(0))
        GLCOLOR3F 0.0,0.0,0.4
        glnormal3f 0,0,1
        glvertex3f -SLENG,-SMALL,SMALL
        glvertex3f  SLENG,-SMALL,SMALL
        glvertex3f  SLENG, SMALL,SMALL
        glvertex3f -SLENG, SMALL,SMALL

        GLCOLOR3F 0.0,0.0,0.6
        glnormal3f 0,0,-1
        glvertex3f -SLENG, SMALL,-SMALL
        glvertex3f  SLENG, SMALL,-SMALL
        glvertex3f  SLENG,-SMALL,-SMALL
        glvertex3f -SLENG,-SMALL,-SMALL
GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE1(0))
        GLCOLOR3F 0.0,0.0,0.8
        glnormal3f 0,-1,0
        glvertex3f -SLENG,-SMALL,-SMALL
        glvertex3f  SLENG,-SMALL,-SMALL
        glvertex3f  SLENG,-SMALL,SMALL
        glvertex3f -SLENG,-SMALL,SMALL

        GLCOLOR3F 0.0,0.0,1.0
        glnormal3f 0,1,0
        glvertex3f -SLENG,SMALL,SMALL
        glvertex3f  SLENG,SMALL,SMALL        
        glvertex3f  SLENG,SMALL,-SMALL     
        glvertex3f -SLENG,SMALL,-SMALL
glend








        GLVIEWPORT 0,w_yh*.35, w_xw,w_yh
        glEnable(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, tex1) 
        GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE3(0))
        
GLBEGIN GL_QUADS
        

        glnormal3f 0,0,1
        glTexCoord2f 0.0, 0.0
        glvertex3f  QO-BLENG,-LARGE,LARGE
        glTexCoord2f 1.0, 0.0
        glvertex3f  QO+BLENG,-LARGE,LARGE
        glTexCoord2f 1.0, 1.0
        glvertex3f  QO+BLENG, LARGE,LARGE
        glTexCoord2f 0.0, 1.0
        glvertex3f  QO-BLENG, LARGE,LARGE
        	    

        glnormal3f 0,0,-1
        glTexCoord2f 0.0, 0.0
        glvertex3f  QO-BLENG, LARGE,-LARGE
        glTexCoord2f 1.0, 0.0
        glvertex3f  QO+BLENG, LARGE,-LARGE
        glTexCoord2f 1.0, 1.0
        glvertex3f  QO+BLENG,-LARGE,-LARGE
        glTexCoord2f 0.0, 1.0
        glvertex3f  QO-BLENG,-LARGE,-LARGE


        glnormal3f 0,-1,0
        glTexCoord2f 0.0, 0.0
        glvertex3f  QO-BLENG,-LARGE,-LARGE
        glTexCoord2f 1.0, 0.0
        glvertex3f  QO+BLENG,-LARGE,-LARGE
        glTexCoord2f 1.0, 1.0
        glvertex3f  QO+BLENG,-LARGE,LARGE
        glTexCoord2f 0.0, 1.0
        glvertex3f  QO-BLENG,-LARGE,LARGE


        glnormal3f 0,2,0        
        glTexCoord2f 0.0, 0.0
        glvertex3f  QO-BLENG,LARGE,LARGE
        glTexCoord2f 1.0, 0.0
        glvertex3f  QO+BLENG,LARGE,LARGE
        glTexCoord2f 1.0, 1.0
        glvertex3f  QO+BLENG,LARGE,-LARGE
        glTexCoord2f 0.0, 1.0
        glvertex3f  QO-BLENG,LARGE,-LARGE
        
        glnormal3f -1,0,0   
        glvertex3f  QO-BLENG,-LARGE,-LARGE
        glvertex3f  QO-BLENG,-LARGE,LARGE
        glvertex3f  QO-BLENG,LARGE,LARGE
        glvertex3f  QO-BLENG,LARGE,-LARGE

        glnormal3f  1,0,0   
        glvertex3f  QO+BLENG,LARGE,-LARGE
        glvertex3f  QO+BLENG,LARGE,LARGE
        glvertex3f  QO+BLENG,-LARGE,LARGE
        glvertex3f  QO+BLENG,-LARGE,-LARGE
        
GLEND
GLDISABLE(GL_TEXTURE_2D)




GLPOPMATRIX
GLDISABLE GL_LIGHTING

END SUB


SUB STARINIT()

DIM A AS INTEGER

FOR A=0 TO STARS

    VVX(A)=(RND(1)*80)-40
    VVY(A)=(RND(1)*80)-40
    VVZ(A)=(RND(1)*50)-40
NEXT


FOR A=0 TO CUBES
    WHILE(CCX(A)>-14) AND (CCX(A)<14)
    CCX(A)=(RND(1)*80)-40
    WEND
    WHILE(CCY(A)>-14) AND (CCY(A)<14)
    CCY(A)=(RND(1)*80)-40
    WEND
    CCZ(A)=(RND(1)*80)-40
NEXT

END SUB


'===============================================================================
' Initialise OpenGL
'===============================================================================
sub InitOGL()

	pfd.cColorBits = 32 
    pfd.cDepthBits = 32
	pfd.dwFlags    = PFD_SUPPORT_OPENGL + PFD_DOUBLEBUFFER
   	IF W_FULLSCREEN=1 THEN hDC = GetDC(CreateWindow( "Edit", "BLAH!", WS_POPUP+WS_VISIBLE+WS_MAXIMIZE, 0 , 0 , 0 , 0, 0, 0, 0, 0))
    IF W_FULLSCREEN<>1 THEN hDC = GetDC(CreateWindow("Edit", "BLAH!", WS_POPUP+WS_VISIBLE+WS_BORDER,W_XO, W_YO, W_XW , W_YH, 0, 0, 0, 0))    
	SetPixelFormat ( hDC, ChoosePixelFormat ( hDC, @pfd) , @pfd )
	wglMakeCurrent ( hDC, wglCreateContext(hDC) )
    ShowCursor(FALSE)
    
	GLLOADIDENTITY
    IF W_FULLSCREEN=1 THEN
        W_XW=GetSystemMetrics(SM_CXSCREEN)
        W_YH=GetSystemMetrics(SM_CYSCREEN)
    END IF
    
    GLVIEWPORT 0, 0, w_xw, w_yh                          '' Reset The Current Viewport
	GLMATRIXMODE GL_PROJECTION                          '' Select The Projection Matrix
	GLLOADIDENTITY
    
    GLUPERSPECTIVE 105.0, W_XW / W_YH, .1, 100.0       '' Calculate The Aspect Ratio Of The Window
    
	GLMATRIXMODE GL_MODELVIEW                           '' Select The Modelview Matrix
	GLLOADIDENTITY                                      '' Reset The Modelview Matrix

	GLSHADEMODEL GL_SMOOTH                              '' Enable Smooth Shading
	GLCLEARCOLOR 0.0, 0.0, 0.0,0
	GLCLEARDEPTH 1.0                                    '' Depth Buffer Setup
	GLENABLE GL_DEPTH_TEST                              '' Enables Depth Testing
	GLDEPTHFUNC GL_LEQUAL                               '' The Type Of Depth Testing To Do
	GLHINT GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST    '' Really Nice Perspective Calculations

    GLFOGF(GL_FOG_START,   10.0)
    GLFOGF(GL_FOG_END,     20.0)
    GLFOGI(GL_FOG_MODE,GL_EXP)    
    GLFOGF(GL_FOG_DENSITY,0.05)




'    glEnable(GL_LIGHTING)
	glEnable(GL_LIGHT0)
    glLightfv( GL_LIGHT0, GL_AMBIENT, @LightAmbient(0))        '' Load Light-Parameters Into GL_LIGHT1
    glLightfv( GL_LIGHT0, GL_POSITION, @LightPosition(0))    

    GLSHADEMODEL (GL_SMOOTH)

    GLENABLE (GL_CULL_FACE)
    GLCULLFACE(GL_BACK)
    
    GLLINEWIDTH 2
    GLENABLE GL_POINT_SMOOTH
    GLENABLE GL_LINE_SMOOTH
    
    GLBLENDFUNC(GL_ONE_MINUS_CONSTANT_ALPHA,GL_DST_COLOR)    
    GLENABLE GL_SMOOTH
    'GLHINT (GL_LINE_SMOOTH_HINT,GL_NICEST)
end sub



Sub LoadDataImage()
    dim i as integer
    'Loads Color palette
    for i = 0 to 255
         img_r( i ) = upp.bmp.pal (i*3) 'Red color
         img_g( i ) = upp.bmp.pal (i*3+1)'Green color
         img_b( i ) = upp.bmp.pal (i*3+2)'Blue color
         
         if img_r( i) >255 then img_r( i) =255
         if img_g( i) >255 then img_g( i) =255
         if img_b( i) >255 then img_b( i) =255
         'img_r( i ) =(img_b(i) Shl 16) Or (img_g(i) Shl 8 )  Or img_r(i)
img_r(i)=rgba(img_b( i ),img_g( i ),img_r( i ),255)
    Next    
    
    for i = 1 to (imgx*imgy) - 1
         img_buffer(i) = upp.bmp.raw (i)
    next  
        
End Sub

Sub DrawImage(byval xpos as integer,byval ypos as integer)
    dim as uinteger x,y,pixel,mong,y2
    DIM AS UINTEGER PTR PP,PP2
    y2=127
    for Y = 0 to imgy-1
        PP=@logoBUFFER(Y*IMGX)
        pp2 = @img_buffer((Y2*IMGX))
        for X = 0 to imgx-1
            mong = (img_r(*pp2) )
                *PP = MONG
            PP  +=1
            pp2 +=1
        next
        YPOS=YPOS+1
        Y2=Y2-1
    next
    
End Sub



SUB UTMATRIX(BYVAL CH  AS INTEGER)
    DIM AS INTEGER X,Y
    DIM AS INTEGER BM    
    BM=(CH*64)-64

    FOR Y=1 TO 8
    FOR X=1 TO 8
        LATRIX (X,Y) = FONT((X+((Y-1)*8))+BM)
    NEXT
    NEXT
    MLINE=1
END SUB


SUB LETTERNEW(BYVAL CH  AS INTEGER, BYVAL XX AS DOUBLE,BYVAL YY AS DOUBLE,BYVAL ZZ AS DOUBLE)
    GLPUSHMATRIX
    GLLOADIDENTITY
    GLTRANSLATEF (XX,YY,ZZ)
    DIM AS DOUBLE LX,LY
    
    
    LY=.5
        
    DIM AS INTEGER X,Y
    
    DIM AS INTEGER BM    
    BM=(CH*64)-64

    FOR Y=1 TO 8
        LX=-.045
            GLMATERIALFV (GL_FRONT,GL_AMBIENT_AND_DIFFUSE,@FACE9(0))
IF Y<=3 THEN GLCOLOR3F 0.2,0.2,0.2
IF Y> 3 and y<= 5 THEN GLCOLOR3F 0.5,0.5,0.0
IF Y>5 THEN GLCOLOR3F 0.5,0.0,0.2        
    FOR X=1 TO 8
        
        IF FONT((X+((Y-1)*8))+BM) = 1 THEN
            
        GLBEGIN GL_QUADS    
        
            glnormal3f 0,0,1
            

            
            glvertex3f LX,LY,0
            glvertex3f LX+.0125,LY,0
            glvertex3f LX+.0125, LY+.0125,0
            glvertex3f LX, LY+.0125,0
            
        GLEND
        
        END IF
        LX=LX+.0125
    NEXT
        LY=LY-.0125
    NEXT
    
    GLPOPMATRIX
    
END SUB

'space
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0

'!
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0

' "
data 0,1,1,1,0,1,1,1
data 0,1,1,1,0,1,1,1
data 0,1,1,1,0,1,1,1
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0

' # 

data 0,0,0,0,0,0,0,0
data 0,1,1,1,0,1,1,0
data 1,1,1,1,1,1,1,1
data 0,1,1,1,0,1,1,0
data 0,1,1,1,0,1,1,0
data 1,1,1,1,1,1,1,1
data 0,1,1,1,0,1,1,0
data 0,0,0,0,0,0,0,0

' $ = £
data 0,0,1,1,1,1,1,0
data 0,1,1,1,0,1,1,1
data 1,1,1,1,1,0,0,0
data 0,1,1,1,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,1,1,1,0,0,0,0
data 1,1,1,1,1,1,1,1

' %
data 0,0,0,0,0,0,0,0
data 0,1,1,0,0,1,1,1
data 0,1,1,0,1,1,1,0
data 0,0,0,1,1,1,0,0
data 0,0,1,1,1,0,0,0
data 0,1,1,1,0,1,1,0
data 1,1,1,0,0,1,1,0
data 0,0,0,0,0,0,0,0
' & = O
data 0,0,0,1,1,0,0,0
data 0,1,1,1,1,1,1,0
data 0,1,1,1,1,1,1,0
data 1,1,1,1,1,1,1,1
data 1,1,1,1,1,1,1,1
data 0,1,1,1,1,1,1,0
data 0,1,1,1,1,1,1,0
data 0,0,0,1,1,0,0,0
' '
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0

' (
data 0,0,1,1,1,1,0,0
data 0,1,1,1,1,0,0,0
data 0,1,1,1,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,1,1,1,1,0,0,0
data 0,0,1,1,1,1,0,0
' )
data 0,0,1,1,1,1,0,0
data 0,0,0,1,1,1,1,0
data 0,0,0,0,1,1,1,0
data 0,0,0,0,1,1,1,0
data 0,0,0,0,1,1,1,0
data 0,0,0,0,1,1,1,0
data 0,0,0,1,1,1,1,0
data 0,0,1,1,1,1,0,0

' *
data 0,0,0,0,0,0,0,0
data 0,1,0,1,1,0,1,0
data 0,0,1,1,1,1,0,0
data 0,1,1,1,1,1,1,0
data 0,1,1,1,1,1,1,0
data 0,0,1,1,1,1,0,0
data 0,1,0,1,1,0,1,0
data 0,0,0,0,0,0,0,0

' +
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,1,1,1,1,1,1,0
data 0,1,1,1,1,1,1,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,0,0,0,0,0
' ,
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,1,1,1,1,0,0

' -
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,1,1,1,1,1,1,0
data 0,1,1,1,1,1,1,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
' .
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,0,0,0
data 0,0,0,1,1,0,0,0
' /
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,1,1,1
data 0,0,0,0,1,1,1,0
data 0,0,0,1,1,1,0,0
data 0,0,1,1,1,0,0,0
data 0,1,1,1,0,0,0,0
data 1,1,1,0,0,0,0,0
data 0,0,0,0,0,0,0,0

'0
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,1,0,1,1,1
data 1,1,1,0,1,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'1
data 0,0,0,1,1,1,0,0
data 0,0,1,1,1,1,0,0
data 0,0,1,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,1,1,1,1,1,0
'2
data 0,0,1,1,1,1,1,0
data 0,1,1,1,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,1,1
data 1,1,1,1,1,1,1,1
'3
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 0,0,0,0,1,1,1,0
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'4
data 1,1,1,0,1,1,1,0
data 1,1,1,0,1,1,1,0
data 0,1,1,1,1,1,1,1
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
'5
data 1,1,1,1,1,1,1,0
data 1,1,1,0,1,1,1,0
data 1,1,1,0,0,0,0,0
data 0,1,1,1,1,1,1,0
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'6
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,0,0,0,0,0,0
data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'7
data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 0,0,0,0,1,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
'8
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'9
data 0,1,1,1,1,1,1,1
data 1,1,0,0,0,1,1,1
data 0,1,1,1,1,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1

' :
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,1,1,1,1,0,0

' ;
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0

' <
data 0,0,0,0,0,0,0,0
data 0,0,1,1,1,0,0,0
data 0,1,1,1,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,0,0,0,0,0,0

' =
data 0,0,0,0,0,0,0,0
data 0,0,1,1,1,1,0,0
data 0,0,1,1,1,1,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,1,1,1,1,0,0
data 0,0,1,1,1,1,0,0
data 0,0,0,0,0,0,0,0

' >
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,1,1,1,0
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,1,1,1,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,0,0,0,0

' ?
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 0,0,0,1,1,1,1,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,1,1,1,0,0

' @
data 0,0,0,0,0,0,0,0
data 0,0,1,1,1,1,0,0
data 0,1,1,0,0,1,1,0
data 0,1,0,1,1,0,1,0
data 0,1,0,0,0,0,1,0
data 0,1,0,1,1,0,1,0
data 0,0,1,1,1,1,0,0
data 0,0,0,0,0,0,0,0

'[]\^_?@

'A
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
'B
data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,0
'C
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'D
data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,0
'E
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,1,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'F
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,1,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0

'G
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,1,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0

'H
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1

'I
data 0,1,1,1,1,1,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,1,1,1,1,1,0,0
'J
data 0,1,1,1,1,1,1,1
data 1,1,1,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 1,1,1,1,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'K
data 1,1,1,0,1,1,1,0
data 1,1,1,0,1,1,1,0
data 1,1,1,1,1,1,0,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
'L

data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0

'M

data 0,1,1,0,1,1,1,0
data 1,1,1,1,1,1,1,1
data 1,1,1,1,0,1,1,1
data 1,1,1,1,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1

'N

data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1

'O
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
'P

data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0

'Q
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,1,0,1,1
data 1,1,1,0,1,1,0,1
data 1,1,1,0,0,1,1,0
data 0,1,1,1,1,1,1,0


'R

data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
'S

data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,0,0,0
data 0,1,1,1,1,1,1,0
data 0,0,0,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0

'T
data 0,1,1,1,1,1,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,1,1,1,0,0,0
'U
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0

'V

data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,0,0,1,1,0
data 0,0,1,1,1,1,0,0

'W
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,1,0,1,1,1
data 1,1,1,1,0,1,1,1
data 1,1,1,1,0,1,1,1
data 0,1,1,1,1,1,1,0

'X
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1

'Y
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 1,1,1,0,0,1,1,1
data 0,1,1,1,1,1,1,0

'Z
data 0,1,1,1,1,1,1,1
data 1,1,1,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,1,1,1,1,1,1,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,1,1,1
data 1,1,1,1,1,1,1,0

'[
data 1,1,1,1,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 1,1,1,1,0,0,0,0
'\
data 1,1,0,0,0,0,0,0
data 1,1,1,0,0,0,0,0
data 0,1,1,1,0,0,0,0
data 0,0,1,1,1,0,0,0
data 0,0,0,1,1,1,0,0
data 0,0,0,0,1,1,1,0
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,0,1,1
']
data 0,0,0,0,1,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,0,1,1,1
data 0,0,0,0,1,1,1,1
'^
data 0,0,0,1,1,0,0,0
data 0,0,1,1,1,1,0,0
data 0,1,1,0,0,1,1,0
data 1,1,1,0,0,1,1,1
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0

'_
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,0,0,0,0,0,0,0
data 0,1,1,1,1,1,1,0
