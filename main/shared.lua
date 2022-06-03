Config = {}


Config.Locations = {
    vector3(241.727, 220.706, 106.286),
    vector3(150.266, -1040.203, 29.374),
    vector3(-1212.980, -330.841, 37.787),
    vector3(-2962.582, 482.627, 15.703),
    vector3(-112.202, 6469.295, 31.626),
    vector3(314.187, -278.621, 54.170),
    vector3(-351.534, -49.529, 49.042),
    vector3(1175.0643310547, 2706.6435546875, 38.094036102295),
}

EYES = {}
EYES.Functions = {
    CreateBlips = function()
        for key, value in pairs(Config.Locations) do
        local blip = AddBlipForCoord(value.x,value.y,value.z)
        SetBlipSprite(blip, 108)
        SetBlipScale(blip, 0.3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Bank")
        EndTextCommandSetBlipName(blip)
        end
    end
}

Config.Card = {
    ["Silver Card"] = 1000,
    ["Gold Card"] = 5000,
    ["Diamond Card"] = 10000
}

Config.Discord = {
    ["Token"] = "",
    ["Log"] = "",
    ["Bot Logo"] = "https://cdn-nq.logo.com.tr/product/crops/750x480/92100.jpg"
}




