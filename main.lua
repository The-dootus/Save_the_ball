local love = require "love"
local enemy = require "Enemy"
local button = require "Button"
local game ={
    difficulty = 1,
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    },
    points = 0,
    levels = {15, 30, 60, 120}
}
local fonts = {
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(24),
        size = 24
    },
    maive = {
        font = love.graphics.newFont(60),
        size = 60
    }
}
local player = {
    radius = 20,
    x = 30,
    y = 30
}
local buttons = {
    menu_state = {},
    ended_state = {}
}
local enemies = {}
local function changeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["paused"] = state == "paused"
    game.state["running"] = state == "running"
    game.state["ended"] = state == "ended"
end
local function startNewGame()
    game.points = 0
changeGameState("running")
love.window.setMode(800, 600)
    enemies = {
        enemy(1)
    }
end
function love.load()
love.window.setTitle("Save the ball")
love.mouse.setVisible(false)
buttons.menu_state.play_game = button("Play Game", startNewGame, nil, 120, 40)
buttons.menu_state.settings = button("Options (TBA)", nil, nil, 120, 40)
buttons.menu_state.exit_game = button("Exit Game", love.event.quit, nil, 120, 40)
buttons.ended_state.replay_game = button("Replay?", startNewGame, nil, 120, 40)
buttons.ended_state.menu = button("Menu", changeGameState, "menu", 120, 40)
buttons.ended_state.exit_game = button("Exit Game", love.event.quit, nil, 120, 40)
function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
    if button == 1 then
        if game.state["menu"] then
            for index in pairs(buttons.menu_state) do
                buttons.menu_state[index]:checkPressed(x, y, player.radius)
            end
        end
    end
end
end
end

function love.update(dt)
player.x, player.y = love.mouse.getPosition()
if game.state["running"] then
for i = 1, #enemies do
    if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
        enemies[i]:move(player.x, player.y)
        for j = 1, #game.levels do
            if math.floor(game.points) == game.levels[j] then
                table.insert(enemies, 1, enemy(game.difficulty * (j + 1)))
                game.points = game.points + 1
            end
        end
    else
        changeGameState("ended")
        love.window.setMode(150, 200)
    end
end
game.points = game.points + dt
end
end
function love.draw()
    love.graphics.setFont(fonts.medium.font)
    love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.newFont(16), 10, love.graphics.getHeight() - 30)
    if game.state["running"]then
        love.graphics.printf("Points: " .. math.floor(game.points), love.graphics.newFont(24), 0, 10, love.graphics.getWidth(),
    "center")
        for i = 1, #enemies do
            enemies[i]:draw()
        end
        love.graphics.circle("fill", player.x, player.y, player.radius)
    elseif game.state["menu"] then
        buttons.menu_state.play_game:draw(10, 20, 17, 10)
        buttons.menu_state.settings:draw(10, 70, 17, 10)
        buttons.menu_state.exit_game:draw(10, 120, 17, 10)
elseif game.state["ended"] then
    buttons.ended_state.replay_game:draw(10, 20, 17, 10)
    buttons.ended_state.menu:draw(10, 70, 17, 10)
    buttons.ended_state.exit_game:draw(10, 120, 17, 10)
end
    if not game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end
-- sssssssssssssssss