require 'SpearTraps/SpearTraps'
require 'TimedActions/ISBaseTimedAction'

ISRemoveSpearFromGrave = ISBaseTimedAction:derive('ISRemoveSpearFromGrave')

function ISRemoveSpearFromGrave:isValid()
	return true
end

function ISRemoveSpearFromGrave:waitToStart()
	self.character:faceThisObject(self.grave)
	return self.character:shouldBeTurning()
end

function ISRemoveSpearFromGrave:update()
	self.character:faceThisObject(self.grave)
end

function ISRemoveSpearFromGrave:start()
	self:setActionAnim('Loot')
	self.character:SetVariable('LootPosition', 'Low')
end

function ISRemoveSpearFromGrave:stop()
	ISBaseTimedAction.stop(self);
end

function ISRemoveSpearFromGrave:perform()
	ISBaseTimedAction.perform(self)
	removeSpearTile(self.grave)
	local spears = self.grave:getModData()['spears'] or {}
	local spearIndex = findNonBrokenSpear(spears)
	table.remove(spears, spearIndex)
	self.character:getInventory():AddItem(self.spear)
end

function ISRemoveSpearFromGrave:new(character, grave, spear, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.grave = grave
	o.grave2 = getGrave(getOtherSquare(grave))
	if not isFirstSquare(grave) then
		o.grave = o.grave2
		o.grave2 = grave
	end
	o.spear = InventoryItemFactory.CreateItem(spear.itemType)
	o.spear:setCondition(spear.condition)
	o.spear:setHaveBeenRepaired(spear.repair)
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time
	if o.character:isTimedActionInstant() then o.maxTime = 1; end
	return o
end
