CreateThread(function()
    while true do
        Wait(10000) -- update every 10 seconds

        GlobalState:set('rpc', {
            GetNumPlayerIndices(),
            0 -- Don't change this value
        }, true)
    end
end)
