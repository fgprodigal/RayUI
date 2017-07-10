----------------------------------------------------------
-- Load RayUI Environment
----------------------------------------------------------
RayUI:LoadEnv()


if bit.bnot(0) ~= 0xFFFFFFFF then
    local _bnot = bit.bnot
    function bit.bnot(value)
        if value < 0 then
            return _bnot(value)
        else
            return 0xFFFFFFFF - value
        end
    end
end
