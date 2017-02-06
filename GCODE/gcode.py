from Tkinter import *
from tkFileDialog import *
import os
import sys
colours = ("#d4d4d4", "red")

#helper functions
#move horizontally
def move(fwrite, x, y, feed):
    fwrite.write("G1" + " X" + str(x) + " Y" + str(y) + " F" + str(feed) + "\n")
#^ max speed
def fmove(fwrite, x, y):
    fwrite.write("G0" + " X" + str(x) + " Y" + str(y) + "\n")
#z-axis analog
def drill(fwrite, z, plunge):
    fwrite.write("G1" + " Z" + str(z) + " F" + str(plunge) + "\n")
def fz(fwrite, z):
    fwrite.write("G0" + " Z" + str(z) + "\n")
    
#code to create a groove
def groove(fwrite, x,y,z,numCuts,depPerCut,plunge,feed,dep,l):
    #full cut
    for i in range (1, numCuts + 1):
        drill(fwrite, z - (depPerCut * i), plunge)
        move(fwrite, x + l, y, feed)
        move(fwrite, x, y, feed)
    #last partial cut
    drill(fwrite, z - dep, plunge)
    move(fwrite, x + l, y, feed)
    move(fwrite, x, y, feed)
    drill(fwrite, z, plunge)
    
def writeFile(x,u,filename):
    #measures = [fr,pr,dia,dpc,dep,l,wall,space,stream,span]
    filen = asksaveasfilename(defaultextension='.gcode',initialfile=filename.get())
    gcode = open(filen, "w")
    if u.get() == "in":
        gcode.write("G20 ")
    elif u.get() == "mm":
            gcode.write("G21 ")
    else:
        return 0
        
    #set zero
    gcode.write("G90\n")
    for (i,x) in enumerate(measures):
        try:
            t = float(x.get())
        except:
            print 'Did not compute - %s invalid value'%commands[i] 
            return i    
        
    fr = measures[0].get()
    pr = measures[1].get()
    dia = measures[2].get()
    dpc = measures[3].get()
    dep = measures[4].get()
    l = measures[5].get()
    wall = measures[6].get()
    space = measures[7].get()
    stream = measures[8].get()
    span =measures[9].get()
    h =measures[10].get()

    #distance between start points of grooves, l is X-axis, w is Y-axis
    incrementl = space + l + dia
    incrementw = wall + dia
    
    #move to the zero coordinate and set base values at zero
    gcode.write("G1 X0 Y0 Z0 ")
    X = 0.0
    Y = 0.0
    Z = 0.0
    
    #set the speed for the above action
    gcode.write("F" + str(pr) + "\n")
    
    #calculate number of grooves in each row and column as well as the number
    #of nessacery full cuts per groove
    segs = int(stream/incrementl)
    channels = int(span/incrementw)
    cuts = int(dep/dpc)
    
    #cut all of the grooves    
    for j in range (0, channels):
        X = 0.0
        for k in range (0, segs):
            fz(gcode, Z + h)
            fmove(gcode, X, Y)
            drill(gcode, Z, pr)
            groove(gcode, X,Y,Z,cuts,dpc,pr,fr,dep,l)
            X += incrementl
        Y += incrementw
    
    gcode.close  

if __name__ == '__main__':

    root = Tk()
    root.geometry('900x400') 
    root.title("G-Code Slot Generator")
    
    units = StringVar();units.set('mm')
    speed = StringVar();speed.set(units.get()+'/min')

    wasMM = BooleanVar();wasMM.set(True)
    h = DoubleVar();h.set(6)
    fr = DoubleVar();fr.set(100)
    pr = DoubleVar();pr.set(100)
    dia = DoubleVar();dia.set(1)
    dpc = DoubleVar();dpc.set(0.1)
    l = DoubleVar();l.set(1)
    dep= DoubleVar();dep.set(0.5)
    wall= DoubleVar();wall.set(0.5)
    space = DoubleVar();space.set(0.4)
    stream = DoubleVar();stream.set(380)
    span = DoubleVar();span.set(100)
    i = IntVar()
    
    filename = StringVar();filename.set('LeeCarveyOswald')
    frame = Frame(root)
    frame.pack()

    wid =10
    
    commands=['Set Feed Rate:']
    commands.append('Set Plunge Rate:')
    commands.append('Set Bit Diameter(D):')
    commands.append('Set Depth per Cut:')
    commands.append('Set Groove Depth:')
    commands.append('Set Length of Cut (L):')
    commands.append('Set Wall Thickness (W):')
    commands.append('Set Barrier Thickness (G):')
    commands.append('Total Streamwise Length:')
    commands.append('Total Spanwise Length:')
    commands.append('Withdraw height:')
    
    measures = [fr,pr,dia,dpc,dep,l,wall,space,stream,span,h]
    ends = [speed,speed,units,units,units,units,units,units,units,units,units]
       
    
    def rename(*args):
        speed.set(units.get()+'/min')
        if units.get()=='in' and wasMM.get() == True:
            l.set(l.get()/25.4)
            h.set(h.get()/25.4)
            fr.set(fr.get()/25.4)
            pr.set(pr.get()/25.4)
            dia.set(dia.get()/25.4)
            dpc.set(dpc.get()/25.4)
            dep.set(dep.get()/25.4)
            wall.set(wall.get()/25.4)
            space.set(space.get()/25.4)
            stream.set(stream.get()/25.4)
            span.set(span.get()/25.4)
            wasMM.set(False)
        elif units.get()=='mm' and wasMM.get() == False:
            l.set(l.get()*25.4)
            h.set(h.get()*25.4)
            fr.set(fr.get()*25.4)
            pr.set(pr.get()*25.4)
            dia.set(dia.get()*25.4)
            dpc.set(dpc.get()*25.4)
            dep.set(dep.get()*25.4)
            wall.set(wall.get()*25.4)
            space.set(space.get()*25.4)
            stream.set(stream.get()*25.4)
            span.set(span.get()*25.4)
            wasMM.set(True)            
    units.trace('w',rename)
    
    def makeRow(desc, meas, end,r):
        Label(frame,text=desc).grid(row=r,column=0,sticky=E) 
        Entry(frame,textvariable=meas,justify=RIGHT,width=wid).grid(row=r,column=1,sticky=E)
        Label(frame,textvariable=end,anchor=W).grid(row=r,column=2,sticky=W)
    
    #Filename
    Label(frame,text='Enter File Name:').grid(row=0,column=0,sticky=E)
    Entry(frame,textvariable=filename,justify=RIGHT,width=20).grid(row=0,column=1,sticky=E,columnspan=2)
    Label(frame,text='.gcode').grid(row=0,column=3,sticky=W) 
    
    
    #Units
    Label(frame,text='Select Units:',anchor=W, justify=LEFT).grid(row=1,column=0,sticky=E)   
    umenu= OptionMenu(frame, units, "mm", "in")
    umenu.grid(row=1,column=1,sticky=W)
    
    
    N = len(commands)
    for (i,j) in enumerate(commands):
        makeRow(j,measures[i],ends[i],i+3)

    minuser = Button(frame,text="Generate G-Code",width=20, command = lambda: writeFile(measures,units,filename))
    minuser.grid(row=N+3,column=0,columnspan=3)   
    
    canvas_w = 595
    canvas_h = 400
    w = Canvas(frame, width=canvas_w,height=canvas_h)
    w.grid(row=0,column=6,rowspan=N+4)
    x0 = 20
    y0 = 20
    numpx = 100
    def back():
        w.create_rectangle(5, 5, canvas_w, canvas_h, outline=colours[0],fill=colours[0])
        
    def slot(x,y,L):
        w.create_oval(x, y, x+numpx, y+numpx, outline=colours[1],fill=colours[1])
        w.create_oval(x+int(L*numpx), y, x+int(numpx*(L+1)), y+numpx, outline=colours[1],fill=colours[1])
        w.create_rectangle(x+numpx/2, y, x+int((L)*numpx)+numpx/2, y+numpx, outline=colours[1],fill=colours[1])
        w.create_arc(x,y,x+numpx, y+numpx,start = 90,extent = 180,style=ARC)
        w.create_arc(x+int(L*numpx), y, x+int(numpx*(L+1)), y+numpx,start = 270,extent = 180,style=ARC)
        
        w.create_line(x+numpx/2, y, x+int(L*numpx+numpx/2), y)
        w.create_line(x+numpx/2, y+numpx, x+int(L*numpx+numpx/2), y+numpx)
        
    def redraw(*args):    
        back()
        try:
            incx = int(((space.get()+l.get())/dia.get()+1)*numpx)
            incy = int((wall.get()/dia.get()+1)*numpx)
           
            for i in range(4):
                for j in range(4):
                    slot(x0+i*incx,y0+incy*j,l.get()/dia.get())
            
            #Diameter Marker
            w.create_text(x0+numpx/2-10, y0+numpx/2, text='D')
            w.create_line(x0+numpx/2, y0,x0+numpx/2, y0+numpx, arrow=BOTH)
            
            #Length Marker
            w.create_line(x0+numpx/2, y0+numpx-5,x0+numpx/2+int(l.get()/dia.get()*numpx), y0+numpx-5, arrow=BOTH) 
            w.create_text(x0+numpx/2+int(l.get()/dia.get()*numpx/2), y0+numpx-15, text='L')
            
            #Barrier Marker
            w.create_text(x0+int(((space.get()/2+l.get())/dia.get()+1)*numpx), y0+numpx/2+10, text='G')
            w.create_line((x0+int(l.get()/dia.get()+1)*numpx), y0+numpx/2,x0+incx, y0+numpx/2, arrow=BOTH) 
            
            #Wall Marker
            w.create_line(x0+numpx/2+int(l.get()/dia.get()*numpx), y0+numpx,x0+numpx/2+int(l.get()/dia.get()*numpx),y0+incy, arrow=BOTH) 
            w.create_text(x0+numpx/2+int(l.get()/dia.get()*numpx)-10, y0+int((wall.get()/dia.get()/2.0+1)*numpx), text='W')            
        except ValueError:
            pass
    redraw()
    
    l.trace('w',redraw)
    space.trace('w', redraw)
    wall.trace('w',redraw)
    
    
    root.mainloop()
        
        
    
