pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

// credits:
// music from 'jelpi' demo game
// menu system by pixelcod


function _init()
gamestate = 4
gold = {49,50,51,50,49}
spaceoff = {32,32}
indloc ={}
debug = {}
score = 0
timerb = 0
nextbub = copy(timer)
	bubs ={}
	ind = 1
	
	introbub = copy(animatedbub)
 introbub:reset()
 introbub.pos[1] = 55
 introbub.pos[2] = 60
 introbub.speed = 0

	for j = 0, 5 do
 	for i = 0, 5 do
 	 local mult = flr(rnd(3)) 
  		 b = copy(bubble)
 	  	b.sl ={1+mult*16,
  									2+mult*16,
  								 3+mult*16,
  								 2+mult*16,
  								 1+mult*16}
 		b.pos[1]*=(i*1.5)
 		b.pos[1]+=spaceoff[1]
 		b.pos[2]*=(j*1.5)
  	b.pos[2]+=spaceoff[2]	
  	add(indloc, {b.pos[1],b.pos[2]})
	 		
 		b.id +=rnd(#b.sl)
 		
 		
 	 add(bubs,b)
 		while (checkmatch(ind)!=nil) do
  	 	mult = flr(rnd(3))
   		bubs[ind].sl = {1+mult*16,
   									2+mult*16,
   								 3+mult*16,
   								 2+mult*16,
   								 1+mult*16}
 	  end

 		
 		

 		ind+=1
 	end
 end
	
 nextbub:set(5)
 
 initbubline()

end

function _update()

 handle_buttons()
 if gamestate == 0 then
 	updatebubs()
 	sel:update()
 	if (btn(4) and btn(5)) then
 		nextbub:pause()
 		initm()
 		gamestate = 1
 		return
  end
 	check_insertbubble()
 	
 elseif(gamestate == 1) then
 	updatem()
 elseif(gamestate ==4) and
	 btnp(4) then
	  music(1)
	  sfx(8)
	  
	  
	   nextbub:begin()
 		gamestate = 0
 elseif(activekeys[z_k]) then
 	_init()
 end
 bounceupdate()
end

function drawbg(ispause)
	local sprite = nil
	if ispause then
 	sprite = 162
 else
 	sprite = 128
 end
	for i = 0, 128/16 do
		for j =0,128/16 do
			spr(sprite,i*16,j*16,2,2)
		end
	end
end


function _draw()
 drawbg(false)
 if gamestate == 0 then
  rectfill(30,30,100,100,7)
 	rect(30,30,100,100,1)
 	drawbubs()
 	sel:draw()

  rectfill(0,12,128,20,7)
 	print("score: "..score,85,14,1)
 	print("new bubble: "..ceil(timerb),10,14,1) 
		rectfill(0,116,128,124,7)
		print("press z+x for menu",menu_bounce_start,119,0)


	elseif (gamestate == 1) then
 	drawm()
 elseif (gamestate == 4 ) then
 	draw_intro()
 
 else
		print("game over!",50,50,8)
		print("press \"z\" to start over",10,60,1)
	end
	 	drawdebug()
end

function drawdebug()

	for f = 1, #debug do
		print (debug[f], 10,10*f,1)
		
	end
	//debug = {}
		
end
menu_bounce_start = 0
menu_bounce_direction = 1
function bounceupdate()
	menu_bounce_start+=menu_bounce_direction

	if menu_bounce_start>=55 or menu_bounce_start<=0 then
	 menu_bounce_direction *=-1
	end
end


function draw_intro()
	drawbg(true)
	rectfill(30,30,100,100,7)
 rect(30,30,100,100,1)
 print("welcome to bubs",35,50,1)
 introbub:update()
 introbub:draw()
 
 print("press \"z\"",45,80,1)

end
-->8
l_k = 1
r_k = 2
u_k = 3
d_k = 4
z_k = 5
x_k = 6
activekeys ={}
buttond =
{
 false,
 false,
 false,
 false,
 false
}
bubble = 
{
sl = {1,2,3,2,1},
id = 1,
pos = {8,8},
ref = 0.05
}

function bubble:rend()
	spr(self.sl[ceil(self.id)],self.pos[1],self.pos[2])
end

function bubble:update()
	self.id +=self.ref
	if self.id > #self.sl then
		self.id = 1
	end
end

function drawbubs()
	for i=1, #bubs do
		bubs[i]:rend()
	end
end

function updatebubs()
	for i=1, #bubs do
		bubs[i]:update()
	end
end
-- lots of useful stuff here
-- taken from harraps post:
-- https://www.lexaloffle.com/bbs/?tid=2951
function copy(o)
  local c
  if type(o) == 'table' then
    c = {}
    for k, v in pairs(o) do
      c[k] = copy(v)
    end
  else
    c = o
  end
  return c
end


function btnd(id) 
	if (btn(id)==false) then
		buttond[id] = false
	else
		if buttond[id] then
			return false
		else
		 buttond[id] = true
		 return true
		end
	end
end


function getbubsbyid(id)
	
	lookup = indloc[id]
	if lookup == nil then return nil end
	for i = 1, #bubs do
		if bubs[i].pos[1] == lookup[1] 
		and bubs[i].pos[2] == lookup[2] then
				return i
		end
		
	end
	
	return nil
end

function handle_buttons()
 activekeys =
 {
 btnd(0),
 btnd(1),
 btnd(2),
 btnd(3),
 btnd(4),
 btnd(5) 
 }
end

function dobubsmatch(id1,id2)
 local b1 = getbubsbyid(id1)
 local b2 = getbubsbyid(id2)
 
 if b1 == nil then return false end
 if b2 == nil then return false end
 
 if bubs[b1].sl[1] == 	bubs[b2].sl[1] then
	 	return true
 end
 
 return false
end


function checkmatch(id)
 local d = false
 local above = id-6
 local left = id-1
 local right = id+1
 local below = id+6
 
 
 if id == 15 then
 d = true 
 end
 
 matchcount = 0
 matchset = {}
 
 // horizontal
 while ( (left % 6 != 0) 
 and(dobubsmatch(id,left))) do
 		matchcount+=1
 		add(matchset,left)
 		left -=1
 end
 
 while ( (right % 6 != 1) 
 and dobubsmatch(id,right) ) do
 		matchcount+=1
 		add(matchset,right)
 		right +=1
 end 

 if matchcount <2 then
 	matchset = {}
 	matchcount = 0
 end

 //vertical 
 local umatch = {}
 local umatchcount = 0
 while ( (above >0) and 
 dobubsmatch(id,above)) do
 		umatchcount+=1
 	 add(umatch,above)
 		above -=6

 end

 while ( (below <=36) and 
 (dobubsmatch(id,below)))do
 		umatchcount+=1
 		add(umatch,below)
 		below +=6
 end

 if umatchcount >=2 then
 	for i =1, #umatch do
 		add(matchset,umatch[i])
 	end
 	matchcount+=umatchcount
 end

 if matchcount >=2 then
 	add(matchset, id)
 		matchset = sort(matchset)
 	return matchset
 end
 
 return nil
end

function getemptyslots()
	r = {}
	for i = 1, 36 do
		if getbubsbyid(i) == nil then
			add(r,i)
		end
	end
 return r
end
-->8
sel = 
{
	pos = {30,30},
 orient = true,
 roff = 1,
 doff = 0,
 posoff = 1
}

function sel:draw()

	if sel.orient then
		rect(sel.pos[1],
							sel.pos[2],
							sel.pos[1]+23,
							sel.pos[2]+11,
							1)
	else
			rect(sel.pos[1],
							sel.pos[2],
							sel.pos[1] + 11,
							sel.pos[2]+23,
							1)
	end
	local x = sel:get()
	//print(x[1]..','..x[2],60,10,1)
	//print (sel.roff..','..sel.doff,10,20,1)


// b1 = getbubsbyid(x[1])
// print(b1.pos[1]..','..b1.pos[2],10,30,1)
	//debugbubs()
	local xy = sel:get()
	b1 = getbubsbyid(xy[1])
	b2 = getbubsbyid(xy[2])
//	print(b2,10,40,1)
			
end


function sel:update()

	if activekeys[x_k] then
	  sfx(9)
			sel.orient = not sel.orient
			local t = sel.roff
			sel.roff = sel.doff
			sel.doff = t
	end

	if activekeys[l_k] and
	(sel.posoff-1)%6 !=0 then
	  sfx(7)
			sel.pos[1]-=12
			sel.posoff-=1
			
	end
	if activekeys[r_k] and
			(sel.posoff+sel.roff)%6 !=0  then
	sfx(7)
			sel.pos[1]+=12
			sel.posoff+=1
	end
	if activekeys[d_k] and
				sel.posoff+(sel.doff*6)<=30 
	 then
	 sfx(7)
			sel.pos[2]+=12
			sel.posoff+=6
	end	
	if activekeys[u_k] and
		sel.posoff>6  then
		sfx(7)
			sel.pos[2]-=12
			sel.posoff-=6
	end		
	
	if activekeys[z_k] then
	
		sel:swapbubs()
	end
end

function sel:get()
	return {sel.posoff,
	sel.posoff+sel.roff+(sel.doff*6)}
end

function sel:swapbubs()
	 sfx(10)
	 local xy = sel:get()
	 local b1 = getbubsbyid(xy[1])
	 local b2 = getbubsbyid(xy[2])		 
	 if (b2 == nil) then
	 	if (b1 != nil) then
	 		 bubs[b1].pos = indloc[xy[2]]
	 	end
	 elseif
	 	b1 == nil then
	 		 bubs[b2].pos = indloc[xy[1]]
	 else
	 local b = copy (bubs[b2])
	 bubs[b2].pos = bubs[b1].pos
	 bubs[b1].pos = b.pos
		end
			 trymatch()
end

function trymatch()
  _draw()
		for i = 1,36 do
	
		local c  = checkmatch(i)
	
		if c !=nil then
			sfx(8)
 		 for x = 1, #c do
 		 	bubs[getbubsbyid(c[x])].sl = copy(gold)
 		 	score+=1
 		 	_draw()
 		 	wait(5)
				end
			 for x = 1, #c do
 		 	del(bubs,bubs[getbubsbyid(c[x])])
				end
		end
end
end


function debugbubs()

 for i = 1, 36 do
 	
 	local  g= 	getbubsbyid(i)
 	if g then
 		print(i,bubs[g].pos[1],bubs[g].pos[2],1)
		end
 end

end
-->8
function sort(t)

	st = {}
	while (#t != nil) and (#t!=0) do
	//	add(debug,#t)
		local small = 999
		
		for i = 1, #t do
			if t[i] < small then
				small = t[i]
			end
	 end
	 add(st,small)
	 del(t,small)
	end
return st
end

function wait(a) for i = 1,a do flip() end end

-->8
timer =
{
	start = nil,
	duration = nil,
	elapsed = 0,
	ispaused = false
}

function timer:set(duration)
	self.duration = duration
	self.elapsed = 0
	self.ispaused = false
	self.start = nil
end
function timer:begin()
	self.start = time()
end

function timer:restart()
 self:begin()
 self.elapsed = 0
end

function timer:check()
	if self.ispaused then return false end
	if self.time() - self.start > self.duration then
		return true
	else
		return false 
	end
end

function timer:pause()
 self.ispaused = true
end

function timer:get()
	self.elapsed = time() - self.start
	return self.duration - self.elapsed
end

function timer:unpause()
	if self.ispaused then
		self.ispaused = false
		self.start = time() - self.elapsed
 end
end
-->8
function check_insertbubble()

	timerb = nextbub:get()
	if timerb<=0 then
	 nextbub:restart()
		if #bubs >=35 then
			gamestate=3
			music(-1)
			sfx(6)
		else
			insertbubble()
		end
	end
end


function insertbubble()
	local g = getemptyslots()
	local lim =ceil((rnd(ceil(#g/2))))
	if lim > 3 then lim = 3 end
	for x = 1, lim do
 
 	local i = ceil(rnd(#g))
	
 	local mult = flr(rnd(3)) 
  		b = copy(bubble)
 	  b.sl = {1+mult*16,
  									2+mult*16,
  								 3+mult*16,
  								 2+mult*16,
  								 1+mult*16}

 		b.pos[1] = indloc[g[i]][1]
  	b.pos[2] = indloc[g[i]][2]
 		b.id +=rnd(#b.sl)
 		add(bubs,b)
 		del(g,g[i])
 		sfx(11)
 	end
 	trymatch()
	end
-->8
--menu system
--by pixelcod

musicf = true

function lerp(startv,endv,per)
 return(startv+per*(endv-startv))
end

function update_cursor()
 if (btnp(2)) m.sel-=1 cx=m.x sfx(7)
 if (btnp(3)) m.sel+=1 cx=m.x sfx(7)
 if (btnp(4)) cx=m.x sfx(7)
 if (btnp(5)) sfx(7)
 if (m.sel>m.amt) m.sel=1
 if (m.sel<=0) m.sel=m.amt
 
 cx=lerp(cx,m.x+5,0.5)
end

function draw_options()
 for i=1, m.amt do
  oset=i*8
  if i==m.sel then
   rectfill(cx,m.y+oset-1,cx+45,m.y+oset+5,col1)
   print(m.options[i],cx+1,m.y+oset,col2)
  else
   print(m.options[i],m.x,m.y+oset,col1)
  end
 end
end


function init_menu()
 
 m={}
 m.x=8
 cx=m.x
 m.y=40
 m.options={"resume","settings"}
 m.amt=0
 for i in all(m.options) do
  m.amt+=1
 end
 m.sel=1
 sub_mode=0
 menu_timer=0
 resetbubline()
end

function update_menu()
 update_cursor()
 if sub_mode==0 then
  if btnp(4) and
  menu_timer>1 then
   if m.options[m.sel]=="settings" then
    init_settings()
   elseif
    m.options[m.sel]=="resume" then
    nextbub:unpause()
    gamestate = 0
   end
  end
  if btnp(5) then 
  nextbub:unpause()
  gamestate = 0
  end
 end
 
 if (sub_mode==1) update_settings()
 
 col1=pals[palnum][1]
 col2=pals[palnum][2]
 menu_timer+=1
	if (sub_mode==0) and btnp(5) then
		gs = 0
	end
 
end

function draw_menu()
 cls(col2)
 drawbg(true)
 udbubline()

 draw_options()
 
 end

function init_settings()
 m.sel=1
 if musicf then
	 m.options={"pause music"}
	else
		 m.options={"play music"}
	end
 m.amt=0
 for i in all(m.options) do
  m.amt+=1
 end
 sub_mode=1
 menu_timer=0
end


function update_settings()
 update_cursor()
  if sub_mode==1 then
   if btnp(4) and
   menu_timer>1 then
    if  m.options[m.sel]=="pause music" then
     	music(-1)
     	musicf = false
     	init_settings()
    elseif m.options[m.sel]=="play music" then
     	music(0)
     	musicf = true
     	init_settings() 
    end
   end
   if btnp(5) then init_menu() end
  end
    
end

----------------------

function initm()
 pals={{7,0},{15,1},{6,5},
			   {10,8},{0,6},{7,2}}
 palnum=5
 init_menu()
end

function updatem()
 update_menu()
end

function drawm()
 draw_menu()
end
-->8
anims =
{
 {130,132},
 {134,136,138,140,142,164,166}  
}
cols =
{
	{1,11},
	{1,12},
	{1,8}
}
poss =
{10,100}

animatedbub =
{
sprite = {130,132},
refresh = 0.25,
lastrefresh = nil,
sid = 1,
col = nil,
speed = 1
}


function animatedbub:reset()
	self.sprite=anims[ceil(rnd(#anims))]
	self.col = cols[ceil(rnd(#cols))]
	self.sid = ceil(rnd(#self.sprite))

	self.lastrefresh = time()
	self.pos = {rnd(129),10}

	self.speed = rnd(1)+1
end

function animatedbub:update()
	self.pos[1]-=self.speed
		
	if self.pos[1] <= -16 then
		self.pos[1] = 129
	end
	
	if time() - self.lastrefresh 
	> self.refresh then
	
		self.sid +=1
	 self.lastrefresh = time()
	end	

	if self.sid > 
	   #self.sprite then
		self.sid = 1
	end
	
end

function animatedbub:draw()
 pal(self.col[1],self.col[2])
 spr(self.sprite[self.sid],
 self.pos[1],
 self.pos[2],
 2,
 2
 )
 pal(0)
end


function initbubline()
 bubline = {}
 for i = 0, 8 do
 	b = copy(animatedbub)
 	b:reset()
 	b.pos[1] = 129-(32*i)
 	add(bubline,b)
 end
end

function udbubline()
	for i = 1, #bubline do
		bubline[i]:update()
		bubline[i]:draw()
	end
end

function resetbubline()
	for i = 1, #bubline do
		bubline[i]:reset()
		if i%2 == 0 then
			bubline[i].pos[2] = 100 
		end
	end
end


__gfx__
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000899999980088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700899aa9980899998000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700089aaaa98089aa98000899800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700089aaaa98089aa98000899800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700899aa9980899998000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000899999980088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003bbbbbb30033330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003bb77bb303bbbb3000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003b7777b303b77b30003bb300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003b7777b303b77b30003bb300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003bb77bb303bbbb3000033000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003bbbbbb30033330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001cccccc10011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001cc66cc101cccc1000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001c6666c101c66c10001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001c6666c101c66c10001cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001cc66cc101cccc1000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001cccccc10011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aaaaaa90099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aa77aa909aaaa9000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009a7777a909a77a90009aa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009a7777a909a77a90009aa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aa77aa909aaaa9000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aaaaaa90099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddffffffff0000000000000000000000000111110000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddffffffff0000000111110000000000011111111000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddffffffff0000111111111000000000111511111100000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddffffffff0055111115111000000001115511111100000111110000000000000000000000000000000000000000000111110000000000000000000000
ddddddddffffffff0015511155111100000011155111111000011111111000000011111100000000000000001111100000011111111000000011111100000000
ddddddddffffffff011151155111110000011111111111000011111111110000011111111100000000000111111111000011111ee11100000111111111000000
ddddddddffffffff01d111111111110000111111d1111100001155115511100011111555511000000001111111111110001111eee11110001111111111100000
ddddddddffffffff11111111d111110000222211111111000115151515511100111115511111000000111111eeeee11001111eeeee111100111eeeee11110000
ffffffffdddddddd111111111111111000111221111111100111111111111100111111511111100000111111eeeee11001111eeeee111100111eeeee11151000
ffffffffdddddddd112222211111111101111121111111110111111111111100115551111ee11000001511111eeee1100111111111111100111eeee111151000
ffffffffdddddddd12211122111111110111111111111111011eeeeeeee1110001511111eee111000115111111eee1100111111111155100011eee1115551100
ffffffffdddddddd121111122111111101111111111111110111eeeeeeee11000155111eeee111000115511111ee111001115155155511000111e11111551100
ffffffffdddddddd111111112111111101111111111111110111eeeeeee111000111111eeee1110001111151111e111001115551115111000111111151111100
ffffffffdddddddd1111111111111111011111111111111100111eeee1111100001111eeee111100001115511111111000111111111111000011111151111100
ffffffffdddddddd0111111111111111001111111111111100001111111100000001111111111100001115551111100000001111111100000001115551111100
ffffffffdddddddd0000111111111110000011111111111000000000000000000000001111111000000111111111000000000000000000000000001111111000
ddddffffddddffff11111111dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddffffddddffff11111111dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddffffddddffff11111111dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddffffddddffff11111111dddddddd000000000000000000000111110000000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddd11111111dddddddd000000001111100000011111111000000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddd11111111dddddddd000000111111110000111111111100000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddd11111111dddddddd000001115551111000115511551110000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddd11111111dddddddd000011111151111001151515155111000000000000000000000000000000000000000000000000000000000000000000
ddddffffddddffffdddddddd11111111000111111111111001111111111111000000000000000000000000000000000000000000000000000000000000000000
ddddffffddddffffdddddddd1111111100111ee11115551001111111111111000000000000000000000000000000000000000000000000000000000000000000
ddddffffddddffffdddddddd111111110111eeeee1111510011eeeeeeee111000000000000000000000000000000000000000000000000000000000000000000
ddddffffddddffffdddddddd111111110111eeeeee1115000111eeeeeeee11000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddddddddddd111111110111eeeeee1111000111eeeeeee111000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddddddddddd11111111001111111111110000111eeee11111000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddddddddddd11111111000011111110000000001111111100000000000000000000000000000000000000000000000000000000000000000000
ffffddddffffdddddddddddd11111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
01030000185701c5701f57024570185701c5701f57024560185601c5601f56024560185501c5501f550245501a5501d5501f540245401a5301d5301f530235301a5301d5301f5301a5201d510215102451023515
01100000240452400528000280452b0450c005280450000529042240162d04500005307553c5252d000130052b0451f006260352b026260420c0052404500005230450c00521045230461f0450c0051c0421c025
01100000187451a7001c7001c7451d745187001c7451f7001a745247001d7451d70021745277002470023745217451f7001d7001d7451a7451b7001c7451f7001a745227001c7451b70018745187001f7451f700
01100000305453c52500600006003e625006000c30318600355250050000600006003e625006000060018600295263251529515006003e625006000060018600305250050018601006003e625246040060000600
01100000004750c47518475004750a475004750a4750c475004750a4750c475004750a4750c4751147513475004750c4750a475004750a475004750a4750c475004750c47516475004751647518475114750c475
01100000180721a0751b0721f0721e0751f0751e0721f075270752607724075200721f0751b0771a0751b07518072180621805218042180350000000000000000000000000000000000000000000000000000000
011000000c37518375243751f3751b3721a372193711b372183721837217371163511533114311133001830214302143021830218302003000030000300003000030000300003000030000300003000030000300
010300001505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01040000180301c0301f0302403024030000002400024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000210201f0201d0201c0201b0201b0201a02019020170201602015020140201302013020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001205015050180501d05020050210501e0501a0501605013050100500e0500e05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200001305013050130501805018050180501d0501d0501b0002000024000270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 01434144
00 02434144
00 01034244
02 02034244
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144
00 41414144

