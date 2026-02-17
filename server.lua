if Data.enabled then
    GlobalState:set('rpc', {GetNumPlayerIndices(), 0}, true)

    CreateThread(function()
        while true do 
            Wait(60000) -- 1 minute
            GlobalState:set('rpc', {
                GetNumPlayerIndices(),
                Data.queueExport()
            }, true)
        end
    end)
end
