display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"

_W = display.contentWidth
_H = display.contentHeight

playtime = 0

sky = display.newImageRect( "sky.jpg", 800, 600 )
sky.x = 400
sky.y = 300

local myFilterA = {categoryBits = 6, maskBits = 1}--弾用
local myFilterB = {categoryBits = 3, maskBits = 2}--的用
local myFilterC = {categoryBits = 5, maskBits = 4}--壁用


physics = require("physics")
physics.start()
physics.setGravity(0,1) 


local targetObj = display.newImage("crate.png", {density = 0.01, bounce = 1.0, filter = myFilterB})
targetObj.x = 150
targetObj.y = 40

physics.addBody(targetObj)


group_r = display.newGroup()
rect1 = display.newRect(0, _H, _W, 5)
physics.addBody(rect1, "static", {filter = myFilterC})
rect2 = display.newRect(-5, 0, 5, _H)
physics.addBody(rect2, "static", {filter = myFilterC })
rect3 = display.newRect(_W, 0, 5, _H)
physics.addBody(rect3, "static", {filter = myFilterC})


group_r:insert(rect1)
group_r:insert(rect2)
group_r:insert(rect3)

local sensors = {
	display.newRect(-10,_H+10,_W,5),
	display.newRect(-50,0,35,_H),
	display.newRect(_W+10,0,35,_H),
}

gameOverFlag = false

local function gameOverCheck(event)
	if event.phase == "began" then
		local message = display.newText(" ", 150,100, native.systemFont,40)
		local message1 = display.newText("", 150, 160,native.systemFont,40)
		message1:setTextColor(255,255,255)
		local Time = tostring(playtime)
		message1.text = "yourtime is " .. Time
		if(playtime < 30) then
			message:setTextColor(255,0,0)
			message.text = "GameOver!"
		elseif(playtime < 45) then
			message:setTextColor(0,255,0)
			message.text = "Great!"
		else
			message:setTextColor(255,255,0)
			message.text = "you're crazy!"
		end
		gameOverFlag = true
	end
end

for index, sensor in pairs(sensors) do
	physics.addBody(sensor, "static", {isSensor = true})
	sensor:addEventListener("collision", gameOverCheck)
end
	
touch_key = 0;

_X = 0;
_Y = 0;

function onTouch(event)
	_X = event.x
	_Y = event.y
	if event.phase == "began" then
		touch_key = 1
	elseif event.phase == "moved" then
		touch_key = 2
	elseif event.phase == "ended" then
		touch_key = 0
		
	end
end

sky:addEventListener("touch", onTouch)

deleteSensor = display.newRect(0,-15,_W, 5)
physics.addBody(deleteSensor,"static", {filter = myFilterC, isSensor = true})

function delete(event)
	if(event.phase == "began") then
		event.other:removeSelf()
	end
end

deleteSensor:addEventListener("collision", delete)

local watch = display.newText(playtime, _W-25,10, native.systemFont,20)
watch:setTextColor(255,255,255)

function onTimeEvent(event)
	if touch_key >0 then
		local circle = display.newCircle(_X,_Y,10)
		circle:setFillColor(math.random(255),math.random(255),math.random(255))
		physics.addBody(circle, {bounce = 1.0, debsuty = 3.0, radius = 10, filter = myFilterA})
		circle:setLinearVelocity(0,-500)
	end
end

function watchAction(event)
	if(gameOverFlag == false) then
		playtime = playtime + 1
		watch.text = playtime
	end
end
	
timer.performWithDelay(500,onTimeEvent,0)
timer.performWithDelay(1000, watchAction,0)
