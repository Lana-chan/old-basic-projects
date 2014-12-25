'---- World of Artcraft server -------------------------------------------------
'---- '10-10-13 syniphas -------------------------------------------------------

#include "chisock/chisock.bi"
#include "vdata/vdata.bi"
#include "vbcompat.bi"
using chi
using vs.vdata

type node
    sock as socket ptr
    col as ubyte ptr
    pt as short ptr
    nam as zstring ptr
    declare function getstr() as zstring ptr
    declare constructor()
    declare destructor()
end type
constructor node()
    col = allocate(3*len(ubyte))
    pt = allocate(4*len(short))
end constructor
destructor node()
    delete sock
    deallocate col
    deallocate pt
    deallocate nam
end destructor
dim shared as linkedlist client
dim shared as integer clients=0, runc
dim shared as longint bcount
dim shared as string logtime
dim shared as any ptr thrncon, thrbuf
dim shared as socket main
dim shared as socket ptr active
dim shared as HashTable nodes
dim as string in, buf, kinp, kbuf
dim as ubyte typ
const w = 800, h = 600

'---- subs ---------------------------------------------------------------------
sub dlog(lin as string)
    dim as integer logfile
    print lin
    logfile = freefile
    open "log " & date & ".txt" for append as logfile
    print #logfile, lin
    close logfile
end sub

sub newconn(i as integer)
    do while runc = 1
        if active->listen_to_new(main,1) then
            dlog "someone joined: " & clients
            clients+=1
            dim aNode as node ptr
            aNode = new node()
            aNode->sock = active
            client.add(aNode)
            active = new socket
        endif
    loop
end sub

sub bufline(pt as short ptr, col as ubyte ptr)
    dim as ubyte byt
    dim as integer buffile
    byt = cubyte(0)
    buffile = freefile
    open ".\buffer\buffer" & logtime & ".bin" for binary as #buffile
    put #buffile, bcount+1, byt
    put #buffile, , cshort(pt[0])
    put #buffile, , cshort(pt[1])
    put #buffile, , cshort(pt[2])
    put #buffile, , cshort(pt[3])
    put #buffile, , cubyte(col[0])
    put #buffile, , cubyte(col[1])
    put #buffile, , cubyte(col[2])
    close #buffile
    bcount+=12
end sub

sub sendbuf(mynode as node ptr)
    dim as integer buffile, i
    dim as ubyte byt
    buffile = freefile
    open ".\buffer\buffer" & logtime & ".bin" for binary as #buffile
    do until eof(buffile)
        for i = 1 to 60
            get #buffile,, byt
            mynode->sock->put(byt)
        next
        sleep 1
    loop
    close #buffile
end sub

extern "c++"
function sendline(byval target as node ptr, byval mynode as node ptr) as integer
    if target = null or target = 0 then return false
    target->sock->put(cubyte(0))
    target->sock->put(mynode->pt[0])
    target->sock->put(mynode->pt[1])
    target->sock->put(mynode->pt[2])
    target->sock->put(mynode->pt[3])
    target->sock->put(mynode->col[0])
    target->sock->put(mynode->col[1])
    target->sock->put(mynode->col[2])
    'target->sock->put(pt[2])
    'target->sock->put(pt[3])
    return true
end function

function sendjoin(byval target as node ptr, byval myNode as node ptr) as integer
    if target = null or target = 0 then return false
    target->sock->put(cubyte(2))
    target->sock->put(cshort(len(*myNode->nam)))
    target->sock->put_data(myNode->nam, len(*myNode->nam))
    target->sock->put(mynode->col[0])
    target->sock->put(mynode->col[1])
    target->sock->put(mynode->col[2])
    target->sock->put(cubyte(1))
    return true
end function

function sendpart(byval target as node ptr, byval myNode as node ptr) as integer
    if target = null or target = 0 then return false
    if target = mynode then exit function
    target->sock->put(cubyte(2))
    target->sock->put(cshort(len(*myNode->nam)))
    target->sock->put_data(myNode->nam, len(*myNode->nam))
    target->sock->put(mynode->col[0])
    target->sock->put(mynode->col[1])
    target->sock->put(mynode->col[2])
    target->sock->put(cubyte(2))
    return true
end function

function sendbyte(byval target as node ptr, byval byt as integer) as integer
    if target = null or target = 0 then return false
    target->sock->put(cubyte(byt))
    return true
end function

function receive(byval myNode as node ptr, byval id as any ptr) as integer
    if myNode = null or myNode = 0 then return false
    dim as ubyte typ
    if myNode->sock->is_closed then
        dlog "Receive: disconnect " & myNode
        client.Enumerate(@sendpart,mynode)
        delete myNode
        clients-=1
        return false
    elseif myNode->sock->get(typ,,,true) then
        myNode->sock->get(typ)
        select case typ
        case 0
            mynode->sock->get(*mynode->pt,4,500)
            'mynode->sock->get(*mynode->col,3,500)
            'mynode->sock->get(pt[1],1,200)
            'mynode->sock->get(pt[2],1,200)
            'mynode->sock->get(pt[3],1,200)
            'if (pt[0] > 0 and pt[0] < w) and (pt[1] > 0 and pt[1]< h) and (pt[2] > 0 and pt[2] < w) and (pt[3] > 0 and pt[3] < h) then
            client.Enumerate(@sendline,mynode)
            bufline mynode->pt, mynode->col
            'endif
            'dlog "line: " & myNode->pt[0]&" "&myNode->pt[1]&" "&myNode->pt[2]&" "&myNode->pt[3]
        case 2
            myNode->nam = mynode->getstr
            myNode->sock->get(*myNode->col,3,500)
            client.Enumerate(@sendjoin,myNode)
            threadwait @thrbuf
            thrbuf = threadcreate(@sendbuf,myNode)
            dlog "joined: " & *myNode->nam & " " & mynode->col[0] & " " & mynode->col[1] & " " & mynode->col[2]
        end select
    endif
    return true
end function
end extern

sub clearcanvas
    logtime = format(now,"hhmmss")
    bcount = 0
    client.Enumerate(@sendbyte,1)
end sub

function node.getstr() as zstring ptr
    dim as short le
    dim as ubyte ptr buf
    this.sock->get(le,1,500)
    buf = allocate(int(le + 1))
    this.sock->get_data(buf, int(le))
    buf[le] = 0
    getstr=@buf[0]
end function

'---- main ---------------------------------------------------------------------
if(main.server(25679) <> SOCKET_OK) then print "Error!"
active = new socket
logtime = format(now,"hhmmss")

locate 25,1
dlog ""
dlog "Session start "& time

runc = 1
thrncon = threadcreate(@newconn,0)

do
    kbuf = inkey
    if len(kbuf) = 1 then
		select case kbuf[0]
		case is > 31
            kinp = kinp & kbuf
		case 8
			if(len(kinp) > 0) then
                locate 25,1
                print "                                                                                ";
				kinp=left(kinp,len(kinp)-1)
			end if
		case 13
			select case lcase(left(kinp,3))
            case "cls":clearcanvas
            case "end":dlog "Closing server":exit do
            end select
			kinp = ""
            locate 25,1
            print "                                                                                ";
		end select
        locate 25, 1
        print right(kinp, 80);
    endif

    sleep 5
    if client.size = 0 then continue do
    client.Enumerate(@receive,0)
loop

runc = 0
main.close()
threadwait @thrncon
threadwait @thrbuf
end
