return {

    buyer_cooldown = 10000, -- Time in milliseconds until you can sell to the same ped. 1000 = 1 second.
    money_item = 'money',

    police = {
        callpoliceondeny = false, -- If police should be called if the ped runs away (You need to add your dispatch) in resource/client.lua - police_dispatch()
        required = 1, -- Amount of cops required to sell drugs, set to false for no requirement.
        multi = 0.05, -- Multiplier applied to sale price per officer on.
        job = 'police', -- Police Job name
    },
    

    drugs = { -- base_price = Base price for 1 drug : maxsale = max amount of items that can be sold at once : rep_sale = reputation received from sale of drug.
        ['weed'] = {base_price = 200, max_sale = 2, rep_sale = 2},
        ['weed_brick'] = {base_price = 100, max_sale = 2, rep_sale = 1},
    },  


    reps = {
        {
            level = 'streetthug', 
            label = 'Street Thug', 
            description = 'You are just getting started!',
            sale_multi = 0, 
            min_reputation = 0
        },
        {
            level = 'streetthug2', 
            label = 'Street Thug II', 
            description = 'You are getting the hang of it!',
            sale_multi = 0.05, 
            min_reputation = 100
        },
        {
            level = 'middleman', 
            label = 'Middle Man', 
            description = 'You are becoming a trusted dealer!',
            sale_multi = 0.10, 
            min_reputation = 200
        },
        {
            level = 'middleman2', 
            label = 'Middle Man II', 
            description = 'You are known all around Los Santos!',
            sale_multi = 0.15, 
            min_reputation = 300
        },
        {
            level = 'middleman3', 
            label = 'Middle Man III', 
            description = 'You are respected all around los Santos!',
            sale_multi = 0.20, 
            min_reputation = 400},
        {
            level = 'kingpin', 
            label = 'King Pin', 
            description = 'You are a King Pin, everyone knows and respects you!',
            sale_multi = 0.25, 
            min_reputation = 500
        },
    },


    interaction = { 
        type = '3dtext', -- Supports: 'target' & '3dtext'


        targetlabel = 'Sell Drugs',
        targetradius = 3.0, 
        targeticon = 'fas fa-cannabis', -- https://fontawesome.com/icons
        targetdistance = 2.0,

        text = '[~g~E~w~] Sell Drugs'
    },

    
}