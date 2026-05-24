function main()
    local DateFormatter = luajava.bindClass("java.time.format.DateTimeFormatter")
    local LocalDateTime = luajava.bindClass("java.time.LocalDateTime")

    --  HUD --
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
        -- TODO fix fullbright
        --mc.options.gamma = 1337
    end)

    -- Scaffold --
    local module = Module.new("Scaffold", "", "MOVEMENT", this)

    local placeDelay = 0

    module:body(function()
        

        local pDelay = NumberBuilder(0):name("PlaceDelay"):setBounds(0, 20):build(module)
        local autoRotate = BooleanBuilder(true):name("AutoRotate"):build(module)
        local downCount = NumberBuilder(1):name("DownCount"):setBounds(1, 5):build(module)
        local swing = BooleanBuilder(true):name("Swing"):build(module)

        module:registerCallback("events", function(event)

            if(event:getName() == "tick") then

                placeDelay = placeDelay + 1

                -- Place blocks below feet
                if(placeDelay >= pDelay:getValue()) then
                    for i = 1, downCount:getValue() do
                        local x = math.floor(mc.player:getX())
                        local y = math.floor(mc.player:getY()) - i
                        local z = math.floor(mc.player:getZ())

                        local blockName = tostring(globals:getBlock(x, y, z))
                        
                        -- Check if block is air (replaceable)
                        if(blockName == "Block{minecraft:air}") then
                            local pos = luajava.newInstance("net.minecraft.util.math.BlockPos", x, y, z)
                            
                            if(interactions:isPlaceable(pos, autoRotate:getValue())) then

                                if(swing:getValue()) then
                                    local Hand = luajava.bindClass("net.minecraft.util.Hand")
                                    mc.player:swingHand(Hand.MAIN_HAND)
                                end
                                interactions:place(pos, autoRotate:getValue())
                                placeDelay = 0
                                return
                            end
                        end
                    end
                end

            end

        end)

        module:onEnable(function()
            placeDelay = pDelay:getValue()
        end)

    end)
end
