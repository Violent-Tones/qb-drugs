lib.callback.register('qb-drugs:server:CreatedEmail', function(source)
    local src = source
    local meta = exports['qs-smartphone-pro']:getMetaFromSource(src)
    if meta and meta.metadata and meta.metadata.mailUserData then
        return 2 -- Working email and phone
    elseif meta and meta.metadata and not meta.metadata.mailUserData then
        return 1 -- Email not set up
    else
        return 0 -- Phone not setup yet
    end

end)