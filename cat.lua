function main()
    local DateFormatter = luajava.bindClass("java.time.format.DateTimeFormatter")
    local LocalDateTime = luajava.bindClass("java.time.LocalDateTime")
    
    local cat = Module.new("Cat", "Yes", "VISUAL", this)


    this:registerCallback("hud", function(hud)
        -- watermark --
        renderer:textWithShadow(hud:getStack(), "cat §8v0.0.1", vec2d(2, 2), color(255, 255, 255, 255)) 

        -- time
        currentTime = LocalDateTime:now():format(DateFormatter:ofPattern("HH:mm:ss"))
        renderer:textWithShadow(hud:getStack(), currentTime, vec2d(2, 12), color(255, 255, 255, 255)) 
        



        --coords --
        local nether = tostring(mc.world:getRegistryKey():getValue():getPath())
        if string.match(nether, "nether") then
            text = string.format("%s §7[%s] §f%s %s §7[%s]", mc.player:getBlockX(), math.floor(mc.player:getBlockX() * 8), mc.player:getBlockY(), mc.player:getBlockZ(), math.floor(mc.player:getBlockZ() * 8))
        else
            text = string.format("%s §7[%s] §f%s %s §7[%s]", mc.player:getBlockX(), math.floor(mc.player:getBlockX() / 8), mc.player:getBlockY(), mc.player:getBlockZ(), math.floor(mc.player:getBlockZ() / 8))
        end

        dir = tostring(mc.player:getHorizontalFacing())

        renderer:textWithShadow(hud:getStack(), text, vec2d(2, mc:getWindow():getScaledHeight() - 11), color(255, 255, 255, 255))
        renderer:textWithShadow(hud:getStack(), dir, vec2d(2, mc:getWindow():getScaledHeight() - 21), color(255, 255, 255, 255))

        
        -- fps --
        local fps = "fps: ".. globals:getFps()
        renderer:textWithShadow(hud:getStack(), fps, vec2d(mc:getWindow():getScaledWidth() - renderer:width(fps), mc:getWindow():getScaledHeight()- 11), color(255, 255, 255, 255))
        
        local server = string.format("server: %s", globals:getServer())
        renderer:textWithShadow(hud:getStack(), server, vec2d(mc:getWindow():getScaledWidth() - renderer:width(server), mc:getWindow():getScaledHeight()- 21), color(255, 255, 255, 255))


        ---- other ----
        -- hi --
        local text = "hi, "..globals:getUsername() .. " :3"
        renderer:textWithShadow(hud:getStack(), text, vec2d(renderer:windowWidth()/2 - renderer:width(text)/2 , 4), color(255, 255, 255, 255))
        
        -- fullbright --
        mc.options.gamma = 1337

    end)
end
