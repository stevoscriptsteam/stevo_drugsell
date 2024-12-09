local config = lib.require('config')
local stevo_lib = exports['stevo_lib']:import()

local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM stevo_drugsell_rep')

if not success then
    MySQL.query([[CREATE TABLE IF NOT EXISTS `stevo_drugsell_rep` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(50) NOT NULL,
    `rep` INT NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `owner` (`owner`)
    )]])
    print('[Stevo Scripts] Deployed database table for stevo_drugsell')
end


function get_reputation(source)
    local identifier = stevo_lib.GetIdentifier(source)

    local row = MySQL.single.await('SELECT `rep` FROM `stevo_drugsell_rep` WHERE `owner` = ? LIMIT 1', {
        identifier
    })

    if row == nil or row.rep == nil then 
        MySQL.insert.await('INSERT INTO `stevo_drugsell_rep` (owner, rep) VALUES (?, ?)', {
            identifier, 0
        })
        return 0
    else
        return row.rep
    end
end


function set_reputation(source, rep)
    local identifier = stevo_lib.GetIdentifier(source)

    local row = MySQL.single.await('SELECT `rep` FROM `stevo_drugsell_rep` WHERE `owner` = ? LIMIT 1', {
        identifier
    })

    if not row then 
        MySQL.insert.await('INSERT INTO `stevo_drugsell_rep` (owner, rep) VALUES (?, ?)', {
            identifier, rep
        })
        return rep
    else
        local newrep = rep + row.rep
        MySQL.update.await('UPDATE `stevo_drugsell_rep` SET rep = ? WHERE `owner` = ?', {
            newrep, identifier
        })

        local old_level = nil
        local new_level = nil
    
        for _, rep in ipairs(config.reps) do
            if row.rep >= rep.min_reputation then
                old_level = rep
            end
            if newrep >= rep.min_reputation then
                new_level = rep
            end
        end
    
        if new_level and old_level and new_level.level ~= old_level.level then
            return true, newrep, string.format("You have leveled up from %s to %s", old_level.label, new_level.label)
        else
            return false, newrep, nil
        end
    end
end


lib.callback.register('stevo_drugsell:sale', function(source, data)

    local police_multi = 0

    if config.police.require then 
        local police_count = stevo_lib.GetJobCount(source, config.police.job) 

        if police_count < config.police.required then 
            return false
        end

        local police_amount = config.police.multi * data.amount
        police_multi = config.police.multi * police_amount
    end

    local reputation = get_reputation(source)

    local reputation_multi = nil

    for _, rep in ipairs(config.reps) do
        if reputation >= rep.min_reputation then
            reputation_multi = rep.sale_multi * data.amount
        end
    end

    local final_amount = data.amount + police_multi + reputation_multi

    exports.ox_inventory:RemoveItem(source, data.item, data.count)
    exports.ox_inventory:AddItem(source, config.money_item, final_amount)

    local level_up, current_reputation, msg = set_reputation(source, data.rep)

    return math.floor(final_amount), level_up, current_reputation, msg
end)


lib.callback.register('stevo_drugsell:getReputation', function(source)
    local name = stevo_lib.GetName(source)
    local rep = get_reputation(source)
    return rep, name
end)


lib.callback.register('stevo_drugsell:setReputation', function(source, rep)
    local level_up, current_reputation, msg = set_reputation(source, rep)
    return level_up, current_reputation, msg
end)