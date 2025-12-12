local bagProp = nil
local bagModel = "prop_money_bag_01" -- Change to whatever prop you want

-- Prop Offsets
local offsetX = 0.40
local offsetY = -0.150
local offsetZ = 0.080
local pitch = 0.0
local roll = 270.0
local yaw = 0.0

local function loadModel(model)
    local mHash = GetHashKey(model)
    RequestModel(mHash)
    while not HasModelLoaded(mHash) do
        Wait(10)
    end
    return mHash
end

local function attachBag()
    local ped = PlayerPedId()
    local bone = GetPedBoneIndex(ped, 11816) -- Pelvic Bone
    local modelHash = loadModel(bagModel)

    if not DoesEntityExist(bagProp) then
        bagProp = CreateObject(modelHash, 0, 0, 0, true, true, true)
        NetworkRegisterEntityAsNetworked(bagProp)
    end

    AttachEntityToEntity(
        bagProp, ped, bone,
        offsetX, offsetY, offsetZ,
        pitch, roll, yaw,
        true, true, false, true, 1, true
    )
end

local function removeBag()
    if DoesEntityExist(bagProp) then
        DeleteEntity(bagProp)
        bagProp = nil
    end
end

-- Automatic attach/remove based on black_money
Citizen.CreateThread(function()
    while true do
        Wait(500)
      -- Change export to whatever inventory you are using and dirty money item
        local count = exports.ox_inventory:Search('count', 'black_money') or 0

        if count > 0 and not DoesEntityExist(bagProp) then
            attachBag()
        elseif count == 0 and DoesEntityExist(bagProp) then
            removeBag()
        end
    end
end)
