Config = {}
Config.Debug = false

QBCore = exports['qb-core']:GetCoreObject()  -- uncomment if you use QBCore
-- ESX = exports["es_extended"]:getSharedObject() -- uncomment if you use ESX


Config.Settings = {
	Framework = 'QB', -- QB/ESX
	Inventory = 'OX', -- QB/OX
	Target = "OX", -- OX/QB
	WebHook = "", -- Discord webhook 
	Prop = "prop_explosive_c4_screen",
	ItemName = "c4_bomb"
}
