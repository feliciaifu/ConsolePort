local Bindings, _, db = CPAPI.CreateDataHandler(), ...; db:Register('Bindings', Bindings)
local function client(id) return [[Interface\Icons\]]..id end;
---------------------------------------------------------------
-- Binding handler
---------------------------------------------------------------
do local function click(id, btn) return ('CLICK %s%s:%s'):format(_, id, btn or 'LeftButton') end;

	Bindings.Custom = {
		EasyMotion        = click 'EasyMotionButton';
		Page2             = click('Pager', 2);
		Page3             = click('Pager', 3);
		Page4             = click('Pager', 4);
		Page5             = click('Pager', 5);
		Page6             = click('Pager', 6);
		PetRing           = click 'PetRing';
		RaidCursorFocus   = click 'RaidCursorFocus';
		RaidCursorTarget  = click 'RaidCursorTarget';
		RaidCursorToggle  = click 'RaidCursorToggle';
		UICursorToggle    = click 'Cursor';
		UtilityRing       = click 'UtilityToggle';
		MenuRing          = click 'MenuTrigger';
		--FocusButton     = click 'FocusButton';
	};
end

---------------------------------------------------------------
-- Special bindings provider
---------------------------------------------------------------
do local function hold(binding) return ('%s（长按）'):format(binding) end;

	Bindings.Special = {
		---------------------------------------------------------------
		-- Targeting
		---------------------------------------------------------------
		{	binding = Bindings.Custom.EasyMotion;
			name    = hold'目标单位框架';
			desc    = [[
				为你屏幕上的单位框架生成单位热键，使你可以快速在友善目标之间切换。

				使用时，按住绑定按键，然后点击选择的目标上提示的按键，然后松开绑定按键切换你的目标。

				这种按键绑定对5人本时的治疗者非常推荐，它提供一种极快的目标选择方式。

				但在团队中，选中你的目标所需的操作复杂性可能会令人望而却步。
				查看切换团队光标，获得更多不同的选择。
			]];
			image = {
				file  = CPAPI.GetAsset([[Tutorial\UnitHotkey]]);
				width = 256;
				height = 256;
			};
		};
		{	binding = Bindings.Custom.RaidCursorToggle;
			name    = '切换团队光标';
			desc    = [[
				激活一个光标，锁定在你的小队/团队框架上，允许你在保持对敌对目标锁定的同时，治疗另一名友善目标。

				团队光标也可以设置为直接目标选择，移动光标将切换你当前的目标。

				在使用时，团队光标占用一组方向键组合来控制光标位置。

				在路径选择模式下，光标不会响应重定向宏或模糊目标的技能，比如牧师的苦修。
				查看目标单位框架，获取更多不同的选择。
			]];
			image = {
				file  = CPAPI.GetAsset([[Tutorial\RaidCursor]]);
				width = 256;
				height = 256;
			};
		};
		{	binding = Bindings.Custom.RaidCursorFocus;
			name    = '焦点团队光标';
		};
		{	binding = Bindings.Custom.RaidCursorTarget;
			name    = '目标团队光标';
		};
		--[[{	name    = hold(FOCUS_CAST_KEY_TEXT);
			binding = Bindings.Custom.FocusButton;
		};]]
		---------------------------------------------------------------
		-- Utility
		---------------------------------------------------------------
		{	binding = Bindings.Custom.UICursorToggle;
			name    = '切换界面光标';
		};
		{	binding = Bindings.Custom.UtilityRing;
			name    = '多功能法环';
			desc    = [[
				一个环形菜单，你可以把不想占用动作条的物品、技能、宏和坐骑添加进去。

				使用时，按住绑定按键，然后将摇杆倾斜到你想要选择的物品的方向，接着松开绑定按键。

				要将物品或技能添加到环形菜单，按照界面光标的提示操作，或者作为替代方法，用鼠标光标选取物品或技能，按下绑定按键将其放入环形菜单。

				要从环形菜单中移除物品，当你聚焦在该物品上时，按照提示进行操作即可。

				多功能法环会自动添加你尚未放置在动作条上的任务物品和临时技能。
			]];
		};
		{	binding = Bindings.Custom.PetRing;
			name    = '宠物法环';
			desc    = [[
				一个环形菜单，让你能够控制你当前的宠物。
			]];
			texture = [[Interface\ICONS\INV_Box_PetCarrier_01]];
		};
		{	binding = Bindings.Custom.MenuRing;
			name    = '菜单法环';
			desc    = [[
				一个环形菜单，可以把常用面板和高频使用指令集中起来，方便快速访问。


				菜单法环也可以通过切换页面，从游戏菜单中访问，无需单独的绑定。
			]];
		};
		---------------------------------------------------------------
		-- Pager
		---------------------------------------------------------------
		{	binding = Bindings.Custom.Page2;
			name    = hold(BINDING_NAME_ACTIONPAGE2);
		};
		{	binding = Bindings.Custom.Page3;
			name    = hold(BINDING_NAME_ACTIONPAGE3);
		};
		{	binding = Bindings.Custom.Page4;
			name    = hold(BINDING_NAME_ACTIONPAGE4);
		};
		{	binding = Bindings.Custom.Page5;
			name    = hold(BINDING_NAME_ACTIONPAGE5);
		};
		{	binding = Bindings.Custom.Page6;
			name    = hold(BINDING_NAME_ACTIONPAGE6);
		};
	};
end

---------------------------------------------------------------
-- Primary bindings provider
---------------------------------------------------------------
Bindings.Proxied = {
	ExtraActionButton = 'EXTRAACTIONBUTTON1';
	InteractTarget    = 'INTERACTTARGET';
	Jump              = 'JUMP';
	LeftMouseButton   = 'CAMERAORSELECTORMOVE';
	RightMouseButton  = 'TURNORACTION';
	TargetNearest     = 'TARGETNEARESTENEMY';
	TargetPrevious    = 'TARGETPREVIOUSENEMY';
	TargetScan		  = 'TARGETSCANENEMY';
	ToggleAllBags     = 'OPENALLBAGS';
	ToggleAutoRun     = 'TOGGLEAUTORUN';
	ToggleGameMenu    = 'TOGGLEGAMEMENU';
	ToggleWorldMap    = 'TOGGLEWORLDMAP';
};

Bindings.Primary = {
	---------------------------------------------------------------
	-- Mouse
	---------------------------------------------------------------
	{	binding = Bindings.Proxied.LeftMouseButton;
		name    = KEY_BUTTON1;
		desc    = [[
			用于切换自由光标，允许你使用摄像头摇杆作为鼠标指针。

			当你的一个按键被设置为模拟左键点击时，此绑定按键不能被更改。
		]];
		readonly = function() return GetCVar('GamePadCursorLeftClick') ~= 'none' end;
	};
	{	binding = Bindings.Proxied.RightMouseButton;
		name    = KEY_BUTTON2;
		desc    = [[
			用于切换中心光标，允许你在游戏中与物体和角色进行交互，光标位置固定在屏幕中心。

			当你的一个按钮被设置为模拟右键点击时，此绑定按键不能被更改。
		]];
		readonly = function() return GetCVar('GamePadCursorRightClick') ~= 'none' end;
	};
	---------------------------------------------------------------
	-- Targeting
	---------------------------------------------------------------
	{	binding = Bindings.Proxied.InteractTarget;
		desc    = [[
			允许你与游戏世界中的NPC和物体进行交互。

			具有与中心光标相同的功能，但不需要你将光标或瞄准装置直接对准目标。

			可交互对象在进入范围时会被高亮显示。
		]];
	};
	{	binding = Bindings.Proxied.TargetScan;
		desc    = [[
			在你前方的狭窄锥形区域内轮询敌人。按住按键可在切换目标之前高亮显示目标。

			在与多个敌人战斗时，对于快速切换目标尤为有用，同时保持高精度。

			目标优先级是通过瞄准定位的，这意味着最接近锥形区域中心的目标将首先被选中。
			如果远处的目标更接近锥形区域的中心，这可能导致优先选择一个远处目标而不是近处的。

			大多数玩家推荐将其作为主要的目标选择方式。
		]];
		image = {
			file  = CPAPI.GetAsset([[Tutorial\TargetScan]]);
			width = 512 * 0.65;
			height = 256 * 0.65;
		};
	};
	{	binding = Bindings.Proxied.TargetNearest;
		desc    = [[
			选中位于你前方最近的敌对目标。如果当前没有目标，将选择中心位置的敌人。否则，它将循环选择最近的敌对目标。

			按住可以高亮显示目标，然后再决定是否切换目标。

			推荐用作辅助目标选择方式，或者在休闲游戏或不适应目标扫描方式时，作为主要目标选择方式。

			不建议在地下城或其他需要高精度选择的场景中使用。
		]];
		image = {
			file  = CPAPI.GetAsset([[Tutorial\TargetNearest]]);
			width = 512 * 0.65;
			height = 256 * 0.65;
		};
	};
	---------------------------------------------------------------
	-- Movement keys
	---------------------------------------------------------------
	{	binding = Bindings.Proxied.Jump;
		desc    = [[
			也可以用来在水下向上游动，乘飞行坐骑上升，以及在骑龙时起飞或向上拍动翅膀。

			跳跃功能在进行需要拇指操作的左手动作时，用于弥补移动中的距离。

			在常规设置中，左摇杆控制你的移动。如果你需要在移动中按下方向键组合，
			跳跃可以用来保持你的前进势头，同时让你的拇指短暂离开摇杆。
		]];
	};
	{ 	binding = Bindings.Proxied.ToggleAutoRun;
		desc    = [[
			自动奔跑功能可使你的角色在当前面对的方向上持续移动，而无需进行任何操作。

			自动奔跑有助于减轻长时间移动导致的拇指疲劳，或者在移动时解放拇指去做其他事情。
		]];
	};
	---------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------
	{	binding = Bindings.Proxied.ToggleGameMenu;
		desc    = [[
			绑定按键处理所有通过按下键盘上的Esc键触发的功能。它根据不同的游戏状态执行不同的操作。

			如果有任何与法术或目标相关的正在进行的动作，它们将被取消。
			在有活动目标时按下绑定按键将清除它。
			在施放法术时按下绑定按键键将打断法术施放。

			绑定按键还根据屏幕上当前显示的内容处理其他各种情况。
			例如，如果打开任何面板时，如法术书面板，按下绑定按键将执行必要的动作来关闭或隐藏它。

			如果上述情况都不适用，按下绑定按键将打开或关闭游戏主菜单。
		]];
	};
	{	binding = Bindings.Proxied.ToggleAllBags;
		desc    = '打开和关闭所有背包。';
	};
	{	binding = Bindings.Proxied.ToggleWorldMap;
		desc = CPAPI.IsRetailVersion and '切换显示综合世界地图和任务日志。' or '切换世界地图。';
	};
	---------------------------------------------------------------
	-- Camera
	---------------------------------------------------------------
	{	binding = 'CAMERAZOOMIN';
		desc    = '将摄像头镜头拉近。长按可持续拉近。';
	};
	{	binding = 'CAMERAZOOMOUT';
		desc    = '将摄像头镜头拉远。长按可持续拉远。';
	};
	---------------------------------------------------------------
	-- Misc
	---------------------------------------------------------------
	{	binding = Bindings.Proxied.ExtraActionButton;
		name    = BINDING_NAME_EXTRAACTIONBUTTON1:gsub('%d', ''):trim();
		desc    = [[
			额外动作按键包含了在各种任务、场景和首领战斗中使用的一种临时技能。

			当这个绑定未设置时，额外动作按键总是在多功能法环上随时可用。

			这个按键在你的游戏手柄动作条上作为一个普通动作按键出现，但你不能更改其内容。
		]];
	};
};

for i, set in ipairs(Bindings.Primary) do
	set.name = set.name or GetBindingName(set.binding)
end

Bindings.Dynamic = {
	{	binding = 'TARGETSELF';
		unit    = 'player';
	};
};
for i=1, (MAX_PARTY_MEMBERS or 4) do tinsert(Bindings.Dynamic,
	{	binding = 'TARGETPARTYMEMBER'..i;
		unit    = 'party'..i;
		texture = client('Achievement_PVP_A_0'..i);
	}
) end;

for i, set in ipairs(Bindings.Dynamic) do
	set.name = set.name or GetBindingName(set.binding)
end

---------------------------------------------------------------
-- Get description for custom bindings
---------------------------------------------------------------
do -- Handle custom rings
	local CUSTOM_RING_DESC = [[
		一个环形菜单，你可以把不想占用动作条的物品、技能、宏和坐骑添加进去。

		使用时，按住绑定按键，然后将摇杆倾斜到你想要选择的物品的方向，接着松开绑定按键。

		要从环形菜单中移除物品，当你聚焦在该物品上时，按照提示进行操作即可。
	]]
	local CUSTOM_RING_ICON = [[Interface\AddOns\ConsolePort_Bar\Assets\Textures\Icons\Ring]]

	local function FindBindingInCollection(binding, collection)
		for i, set in ipairs(collection) do
			if (set.binding == binding) then
				return set;
			end
		end
	end

	function Bindings:GetCustomBindingInfo(binding)
		return FindBindingInCollection(binding, self.Special)
			or FindBindingInCollection(binding, self.Primary)
			or FindBindingInCollection(binding, self.Dynamic)
	end

	function Bindings:GetDescriptionForBinding(binding, useTooltipFormat, tooltipLineLength)
		local set = self:GetCustomBindingInfo(binding)

		if set then
			local desc, image, texture, unit = set.desc, set.image, set.texture, set.unit;
			if ( desc and useTooltipFormat ) then
				desc = CPAPI.FormatLongText(desc, tooltipLineLength)
			end
			if ( image and useTooltipFormat ) then
				image = CPAPI.CreateSimpleTextureMarkup(image.file, image.width, image.height)
			end
			if ( unit and type(texture) ~= 'function' ) then
				local default = texture;
				texture = function(self)
					if UnitExists(unit) then
						return SetPortraitTexture(self, unit)
					end
					self:SetTexture(default)
				end
				set.texture = texture;
			end
			return desc, image, set.name, texture;
		end

		local customRingName = db.Utility:ConvertBindingToDisplayName(binding)
		if customRingName then
			return CUSTOM_RING_DESC, nil, customRingName, self:GetIcon(binding) or CUSTOM_RING_ICON, customRingName;
		end
	end
end

---------------------------------------------------------------
-- Binding icon management
---------------------------------------------------------------
do local function custom(id) return ([[Interface\AddOns\ConsolePort_Bar\Assets\Textures\Icons\%s]]):format(id) end;

	local CustomIcons = {
		Bags      = custom 'Bags.png';
		Group     = custom 'Group.png';
		Jump      = custom 'Jump.png';
		Map       = custom 'Map.png';
		Menu      = custom 'Menu.png';
		Ring      = custom 'Ring.png';
		Run       = custom 'Run.png';
		Target    = custom 'Target';
		TNEnemy   = custom 'Target_Narrow_Enemy.png';
		TNFriend  = custom 'Target_Narrow_Friend.png';
		TWEnemy   = custom 'Target_Wide_Enemy.png';
		TWFriend  = custom 'Target_Wide_Friend.png';
		TWNeutral = custom 'Target_Wide_Neutral.png';
	}; Bindings.CustomIcons = CustomIcons;

	Bindings.DefaultIcons = {
		---------------------------------------------------------------
		JUMP                               = CustomIcons.Jump;
		TOGGLERUN                          = CustomIcons.Run;
		OPENALLBAGS                        = CustomIcons.Bags;
		TOGGLEGAMEMENU                     = CustomIcons.Menu;
		TOGGLEWORLDMAP                     = CustomIcons.Map;
		---------------------------------------------------------------
		INTERACTTARGET                     = CustomIcons.TWNeutral;
		---------------------------------------------------------------
		TARGETNEARESTENEMY                 = CustomIcons.TWEnemy;
		TARGETPREVIOUSENEMY                = CustomIcons.TWEnemy;
		TARGETSCANENEMY                    = CustomIcons.TNEnemy;
		TARGETNEARESTFRIEND                = CustomIcons.TWFriend;
		TARGETPREVIOUSFRIEND               = CustomIcons.TWFriend;
		TARGETNEARESTENEMYPLAYER           = CustomIcons.TNEnemy;
		TARGETPREVIOUSENEMYPLAYER          = CustomIcons.TNEnemy;
		TARGETNEARESTFRIENDPLAYER          = CustomIcons.TNFriend;
		TARGETPREVIOUSFRIENDPLAYER         = CustomIcons.TNFriend;
		---------------------------------------------------------------
		TARGETPARTYMEMBER1                 = CPAPI.IsRetailVersion and client 'Achievement_PVP_A_01';
		TARGETPARTYMEMBER2                 = CPAPI.IsRetailVersion and client 'Achievement_PVP_A_02';
		TARGETPARTYMEMBER3                 = CPAPI.IsRetailVersion and client 'Achievement_PVP_A_03';
		TARGETPARTYMEMBER4                 = CPAPI.IsRetailVersion and client 'Achievement_PVP_A_04';
		TARGETSELF                         = CPAPI.IsRetailVersion and client 'Achievement_PVP_A_05';
		TARGETPET                          = client 'Spell_Hunter_AspectOfTheHawk';
		---------------------------------------------------------------
		ATTACKTARGET                       = client 'Ability_SteelMelee';
		STARTATTACK                        = client 'Ability_SteelMelee';
		PETATTACK                          = client 'ABILITY_HUNTER_INVIGERATION';
		FOCUSTARGET                        = client 'Ability_Hunter_MasterMarksman';
		---------------------------------------------------------------
		[Bindings.Custom.EasyMotion]       = CustomIcons.Group;
		[Bindings.Custom.RaidCursorToggle] = CustomIcons.Group;
		[Bindings.Custom.RaidCursorFocus]  = CustomIcons.Group;
		[Bindings.Custom.RaidCursorTarget] = CustomIcons.Group;
		[Bindings.Custom.UtilityRing]      = CustomIcons.Ring;
		[Bindings.Custom.MenuRing]         = CustomIcons.Menu;
		--[Bindings.Custom.FocusButton]    = client 'VAS_RaceChange';
		---------------------------------------------------------------
	};
end

function Bindings:OnDataLoaded()
	self.Icons = CPAPI.Proxy(ConsolePortBindingIcons or {}, self.DefaultIcons)
	db:Save('Bindings/Icons', 'ConsolePortBindingIcons')
end

function Bindings:GetIcon(bindingID)
	return self.Icons[bindingID];
end

function Bindings:SetIcon(bindingID, icon)
	self.Icons[bindingID] = icon;
	db:TriggerEvent('OnBindingIconChanged', bindingID, self.Icons[bindingID])
end

function Bindings:GetIconProvider()
	if not self.IconProvider then
		self.IconProvider = self:RefreshIconDataProvider()
	end
	return self.IconProvider;
end

function Bindings:ReleaseIconProvider()
	if self.IconProvider then
		self.IconProvider = nil;
		collectgarbage()
	end
end

---------------------------------------------------------------
do -- Icon provider (see FrameXML\IconDataProvider.lua)
---------------------------------------------------------------
	local QuestionMarkIconFileDataID = 134400;

	local function FillOutExtraIconsMapWithSpells(extraIconsMap)
		for i = 1, GetNumSpellTabs() do
			local tab, tabTex, offset, numSpells = GetSpellTabInfo(i);
			offset = offset + 1;
			local tabEnd = offset + numSpells;
			for j = offset, tabEnd - 1 do
				local spellType, ID = GetSpellBookItemInfo(j, 'player');
				if spellType ~= 'FUTURESPELL' then
					local fileID = GetSpellBookItemTexture(j, 'player');
					if fileID ~= nil then
						extraIconsMap[fileID] = true;
					end
				end

				if spellType == 'FLYOUT' then
					local _, _, numSlots, isKnown = GetFlyoutInfo(ID);
					if isKnown and (numSlots > 0) then
						for k = 1, numSlots do
							local spellID, overrideSpellID, isSlotKnown = GetFlyoutSlotInfo(ID, k)
							if isSlotKnown then
								local fileID = GetSpellTexture(spellID);
								if fileID ~= nil then
									extraIconsMap[fileID] = true;
								end
							end
						end
					end
				end
			end
		end
	end

	local function FillOutExtraIconsMapWithTalents(extraIconsMap)
		local isInspect = false;
		for specIndex = 1, GetNumSpecGroups(isInspect) do
			for tier = 1, MAX_TALENT_TIERS do
				for column = 1, NUM_TALENT_COLUMNS do
					local icon = select(3, GetTalentInfo(tier, column, specIndex));
					if icon ~= nil then
						extraIconsMap[icon] = true;
					end
				end
			end
		end

		for pvpTalentSlot = 1, 3 do
			local slotInfo = C_SpecializationInfo.GetPvpTalentSlotInfo(pvpTalentSlot);
			if slotInfo ~= nil then
				for i, pvpTalentID in ipairs(slotInfo.availableTalentIDs) do
					local icon = select(3, GetPvpTalentInfoByID(pvpTalentID));
					if icon ~= nil then
						extraIconsMap[icon] = true;
					end
				end
			end
		end
	end

	local function FillOutExtraIconsMapWithEquipment(extraIconsMap)
		for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
			local itemTexture = GetInventoryItemTexture('player', i)
			if itemTexture ~= nil then
				extraIconsMap[itemTexture] = true;
			end
		end
	end

	local function FillOutExtraIconsWithCustomIcons(extraIcons)
		for _, customTexture in db.table.spairs(Bindings.CustomIcons) do
			tinsert(extraIcons, customTexture)
		end
	end

	function Bindings:RefreshIconDataProvider()
		local extraIconsMap = {};
		pcall(FillOutExtraIconsMapWithSpells, extraIconsMap)
		pcall(FillOutExtraIconsMapWithTalents, extraIconsMap)
		pcall(FillOutExtraIconsMapWithEquipment, extraIconsMap)

		local extraIcons = GetKeysArray(extraIconsMap)
		pcall(FillOutExtraIconsWithCustomIcons, extraIcons)

		local provider = {QuestionMarkIconFileDataID, unpack(extraIcons)};
		pcall(GetLooseMacroIcons, provider)
		pcall(GetLooseMacroItemIcons, provider)
		pcall(GetMacroIcons, provider)
		pcall(GetMacroItemIcons, provider)

		local customIconsRef = tInvert(Bindings.CustomIcons)
		for i, iconID in ipairs(provider) do
			if not tonumber(iconID) and not customIconsRef[iconID] then
				provider[i] = client(iconID)
			end
		end

		return provider;
	end
end