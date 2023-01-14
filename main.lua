function love.load()
    
    -- Target config
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    -- Variables
    gameState = 1
    highscore = 0
    score = 0
    timer = 25
    somekey = ''
    
    
    
    
    gameFont = love.graphics.newFont(40)
    minecraft_font = love.graphics.newFont('minecraft_font.ttf')
    
    -- Sprites config
    sprites = {}
        sprites.background = love.graphics.newImage('sprites/background3.png')
        sprites.crosshair = love.graphics.newImage('sprites/crosshair.png')
        sprites.benson = love.graphics.newImage('sprites/benson.png')
        sprites.Part = love.graphics.newImage('sprites/benson_feather.png')

    -- Particles config
    particles = love.graphics.newParticleSystem(sprites.Part, 32)
    particles:setParticleLifetime(1, 3)
    particles:setEmissionRate(1)
    particles:setLinearAcceleration(-25, -25, 50, 50)
    particles:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    emitParticles = false
    particlesTimer = -1


        
    -- Mouse config
    love.mouse.setVisible(false)

    -- Sound config
    src1 = love.audio.newSource('Ghost_Janitor_BASSFISH.wav', 'stream')
    src2 = love.audio.newSource('m1-garand-rifle-80192.mp3', 'static')
    src3 = love.audio.newSource('ducks1-32839.mp3', 'stream')

end

function love.update(dt)
    -- Particles refresh
    particles:update(dt)
    particlesTimer = particlesTimer - dt
 
if src1:isPlaying() == false then
    src1:play()   
end

if src3:isPlaying() == false then
    src3:play()   
end
    
    -- Main game loop
    if timer > 0 and gameState == 2 then
        timer = timer - dt
    end
    if timer <= 0 then
        if score > highscore then
            highscore = score
            gameState = 1
        end
        score = 0
        timer = 25
    end
end


function love.draw()
   -- Background
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 50, 10, 700, 40)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('line', 49, 9, 701, 41)
   -- Game sprites
   if gameState == 2 then
        
        love.graphics.draw(sprites.benson, target.x - target.radius, target.y - target.radius)
   end

   -- Particles
   
       
       
    if particlesTimer > 0 then
        love.graphics.draw(particles, particleX, particleY)
    end
        
   
   -- Text
   love.graphics.setColor(255,255,255)
   love.graphics.setFont(minecraft_font)
   love.graphics.print('score  '..score, 70, 20)
   love.graphics.print('highscore  '.. highscore, 625, 20)
   love.graphics.print(math.ceil(timer), 390, 20)
   if gameState == 1 then
        love.graphics.print('click to start playing, click w or mouse to shoot and r to reset', 200, 300)
   end
   
   -- Crosshair
   love.graphics.draw(sprites.crosshair, love.mouse.getX() - 47, love.mouse.getY() - 47)
end

-- Mouse
function love.mousepressed(x,  y, button, istouch, presses )
    if gameState == 2 then
        src2:stop()
        src2:play()
    end
    if button == 1 and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y )
        if mouseToTarget <= target.radius then
            score = score + 1
            particlesTimer = .5
            emitParticles = true
            particleX, particleY = love.mouse.getPosition()
            particles:emit(3)
            target.x = math.random(5, love.graphics.getWidth())
            target.y = math.random(5, love.graphics.getHeight())

        end
        
    end
    if gameState == 1 then
       gameState = 2
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
function love.keypressed(key, scancode, isrepeat)
    if gameState == 2 then
        src2:stop()
        src2:play()
    end
    somekey = key
    x,y = love.mouse.getPosition()
    if key == 'w' and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y )
        if mouseToTarget <= target.radius then
            score = score + 1
            particlesTimer = .5
            emitParticles = true
            particleX, particleY = love.mouse.getPosition()
            particles:emit(3)
            target.x = math.random(5, love.graphics.getWidth())
            target.y = math.random(5, love.graphics.getHeight())

        end
    end

    if key == 'r' and gameState == 2 then
        score = 0
        timer = 0 
        gameState = 1
    end

    if gameState == 1 then
       gameState = 2
    end
end
