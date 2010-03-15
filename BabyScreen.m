//
//  BabyScreen.m
//  BabyFingers
//
//  Created by Baris Metin
//

#import "BabyScreen.h"
#import "OBJParser.h"


@implementation BabyScreen

- (id)initWithFrame: (NSRect)rect pixelFormat:(NSOpenGLPixelFormat *)format
{
    self = [super initWithFrame:rect pixelFormat:format];
    [self initOpenGLView];
    return self;
}

-(BOOL)acceptsFirstResponder { return YES; }
-(BOOL)becomeFirstResponder  { return YES; }
-(BOOL)resignFirstResponder  { return YES; }

- (void)initOpenGLView
{       
    glContext = [self openGLContext];
    [glContext makeCurrentContext];
    
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_DEPTH_TEST);
    
    GLfloat ambient[] = {0.2, 0.2, 0.2, 1.0};
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient);
    
    GLfloat diffuse[] = {1.0, 1.0, 1.0, 1.0};
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    glEnable(GL_LIGHT0);
}

- (void)reshape
{
    NSRect baseRect = [self convertRectToBase:[self bounds]];
    
    glViewport(0, 0, baseRect.size.width, baseRect.size.height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
}

- (void)keyDown: (NSEvent *)event
{
    [self drawRect:[self bounds]];
}

- (void)mouseMoved: (NSEvent *)event
{
    [self drawRect:[self bounds]];
}

- (void)drawRect: (NSRect)bounds
{
    glClearColor(0.5, 0.5, 0.8, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
  //  glTranslated(0.5, 0.5, 0.2);
    
    [self drawRandomObject];
    
    [glContext flushBuffer];
}


- (OBJ*) loadOBJ:(NSString*)file
{
    OBJParser* parser = [[OBJParser alloc] initWithFile:file];
    [parser parse];
    OBJ* obj = [parser object];
    [obj retain];
    [parser release];
    return obj;
}

- (void) drawObj:(OBJ*) obj
{
    NSUInteger num_faces = [[obj faces] count];
    
    glBegin(GL_TRIANGLES);
    for (int f=0; f < num_faces; f++) {
        //NSLog(@"f -- %d", f);
        Face3D* face = [[obj faces] objectAtIndex:f];
        
        for (int i=0; i < 3; i++) {
            //NSLog(@"i-- %d", i);
            Vertex3D* v = [[obj vertices] objectAtIndex:([face v][i] - 1)];
            Vertex3D* n = [[obj normals] objectAtIndex:([face n][i] - 1)];
            glNormal3f([n x], [n y], [n z]);
            glVertex3f([v x], [v y], [v z]);
        }
        
    }
    glEnd();
    
}

- (void) drawRandomObject
{
    // TESTING
    static double i = 10;
    i += 10;
    if (i >=540) i = 0;
    

    srand(time(0) * i);
    int k = rand();
    NSLog(@"%d", k);

    // TEST animation
    glRotated(i, i-k, i+k, i+45);
    glTranslated(i/(k*360.0), -i/360.0, 0);

    OBJ* butterfly = [self loadOBJ:[[NSBundle mainBundle] pathForResource:@"butterfly" ofType:@"obj"]];
    [self drawObj:butterfly];
    
}

@end
