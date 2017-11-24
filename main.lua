function love.load()
	deadzone = 0.25 -- adjustable, my pretty worn controller needs to have this as high as 0.3
	love.graphics.setBackgroundColor(30, 30, 30)
	joystick = love.joystick.getJoysticks()[1]
    s = {}
    currentButton = "testButton"
    currentJoystick = "testJoystick"
    buttonCount = joystick:getButtonCount()
    buttonDown = 0 
end

function love.update()
    s.ax, s.ay = joystick:getAxes() -- ax and ay are the actual raw values from the controller
    checkButton()
	local extent = math.sqrt(math.abs(s.ax * s.ax) + math.abs(s.ay * s.ay))
	local angle = math.atan2(s.ay, s.ax)
	if (extent < deadzone) then
		s.x, s.y = 0, 0 -- x and y are the rectified inputs
	else
		extent = math.min(1, (extent - deadzone) / (1 - deadzone))
		s.x, s.y = extent * math.cos(angle), extent * math.sin(angle)
	end
end

function love.draw()
	-- bullseye
	love.graphics.setColor(20, 10, 20)
	love.graphics.circle("fill", 250, 250, 200, 48)
	love.graphics.setColor(30, 30, 30)
	love.graphics.circle("fill", 250, 250, 200 * deadzone, 24)
	-- actual values indicator line
	love.graphics.setColor(160, 80, 160)
	love.graphics.circle("fill", 250, 250, 5, 8)
	love.graphics.setColor(200, 100, 200)
	love.graphics.line(250, 250,  250 + (s.ax * 200), 250 + (s.ay * 200))
	-- fixed location indicator circle
	love.graphics.setColor(150, 120, 150)
    love.graphics.circle("line", 250 + (s.x * 200), 250 + (s.y * 200), 10, 12)
    
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("x: " .. s.ax, 10, 10)
    love.graphics.print("y: " .. s.ay, 10, 30)
    love.graphics.print(buttonDown, 10, 50)
end

function love.gamepadpressed(joystick, button)
    currentJoystick = joystick
    currentButton = button
end

function checkButton()
    buttonDown = ""
    for i=1, buttonCount do
        if joystick:isDown(i) then
            buttonDown = ("Button " .. i)
        end
    end
end