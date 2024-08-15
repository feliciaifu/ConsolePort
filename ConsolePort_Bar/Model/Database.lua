local _, env = ...;
---------------------------------------------------------------
-- Constants
---------------------------------------------------------------
env.Const.ProxyKeyOptions = function()
	local keys = {};
	for buttonID in pairs(env.db.Gamepad.Index.Button.Binding) do
		if CPAPI.IsButtonValidForBinding(buttonID) then
			keys[buttonID] = buttonID;
		end
	end
	return keys;
end

env.Const.DefaultPresetName = ('%s (%s)'):format(GetUnitName('player'), GetRealmName());
env.Const.ManagerVisibility = '[petbattle] hide; show';
env.Const.DefaultVisibility = '[vehicleui][overridebar] hide; show';

env.Const.ValidFontFlags = CPAPI.Enum('OUTLINE', 'THICKOUTLINE', 'MONOCHROME');
env.Const.ValidJustifyH  = CPAPI.Enum('LEFT', 'CENTER', 'RIGHT');
env.Const.ValidPoints    = CPAPI.Enum(
	'CENTER', 'TOP',      'BOTTOM',
	'LEFT',   'TOPLEFT',  'BOTTOMLEFT',
	'RIGHT',  'TOPRIGHT', 'BOTTOMRIGHT'
);
env.Const.PageDescription =  {
	['vehicleui']   = '载具界面激活。';
	['possessbar']  = '支配栏可见，例如心智控制或野兽之眼。';
	['overridebar'] = '一个覆盖栏被激活，当特定场景没有载具界面时使用。';
	['shapeshift']  = '临时的变化，但不同于自己的动作条或姿态动作条。';
	['bar:1']       = '已选择页面 1 (默认)';
	['bar:2']       = '已选择页面 2';
	['bar:3']       = '已选择页面 3';
	['bar:4']       = '已选择页面 4';
	['bar:5']       = '已选择页面 5';
	['bar:6']       = '已选择页面 6';
	['bonusbar:1']  = '姿态/形态 1';
	['bonusbar:2']  = '姿态/形态 2';
	['bonusbar:3']  = '姿态/形态 3';
	['bonusbar:4']  = '姿态/形态 4';
	['bonusbar:5']  = '驭龙术';
};

---------------------------------------------------------------
do -- Variables
---------------------------------------------------------------
local classColor = CreateColor(CPAPI.NormalizeColor(CPAPI.GetClassColor()));
local Data, _ = env.db.Data, CPAPI.Define;

env:Register('Variables', CPAPI.Callable({
	---------------------------------------------------------------
	_'动作条';
	---------------------------------------------------------------
	showMainIcons = _{Data.Bool(true);
		name = '显示主图标';
		desc = '显示主要按键的图标。';
	};
	showCooldownText = _{Data.Bool(GetCVarBool('countdownForCooldowns'));
		name = '启用冷却时间数字';
		desc = '在按键上显示冷却时间的数字。';
	};
	disableDND = _{Data.Bool(false);
		name = '禁用拖放功能';
		desc = '禁用动作条上的拖放功能。';
	};
	---------------------------------------------------------------
	_'动作按键';
	---------------------------------------------------------------
	LABclickOnDown = _{Data.Bool(true);
		name = '按下时响应';
		desc = '按下按键时响应动作，而不是释放时响应。';
	};
	LABhideElementsMacro = _{Data.Bool(false);
		name = '隐藏宏文本';
		desc = '在按键上隐藏宏的文本。';
	};
	LABcolorsRange = _{Data.Color(CreateColor( 0.8, 0.1, 0.1 ));
		name = '超出范围颜色';
		desc = '按键上范围指示器的颜色。';
	};
	LABcolorsMana = _{Data.Color(CreateColor(0.5, 0.5, 1.0 ));
		name = '法力不足颜色';
		desc = '按键上法力指示器的颜色。';
	};
	LABtooltip = _{Data.Select('Enabled', 'Enabled', 'Disabled', 'NoCombat');
		name = '提示';
		desc = '鼠标移至按键上时显示提示。';
	};
	---------------------------------------------------------------
	_'动作按键 | 页面热键';
	---------------------------------------------------------------
	LABhotkeyColor = _{Data.Color(CreateColor( 0.75, 0.75, 0.75 ));
		name = '颜色';
		desc = '按键上热键文字的颜色。';
	};
	LABhotkeyFontSize = _{Data.Number(12, 1);
		name = '尺寸';
		desc = '按键上热键文字的尺寸。';
	};
	LABhotkeyPositionOffsetX = _{Data.Number(4, 1, true);
		name = 'X 轴偏移';
		desc = '按键上热键文本的水平偏移。';
	};
	LABhotkeyPositionOffsetY = _{Data.Number(0, 1, true);
		name = 'Y 轴偏移';
		desc = '按键上热键文本的垂直偏移。';
	};
	LABhotkeyJustifyH = _{Data.Select('RIGHT', env.Const.ValidJustifyH());
		name = '对齐';
		desc = '按键上热键文本的对齐方式。';
	};
	LABhotkeyFontFlags = _{Data.Select('OUTLINE', env.Const.ValidFontFlags());
		name = '字体装饰';
		desc = '按键上热键文字的字体装饰。';
	};
	LABhotkeyPositionAnchor = _{Data.Select('TOPRIGHT', env.Const.ValidPoints());
		name = '锚点';
		desc = '按键上热键文本的锚点。';
	};
	LABhotkeyPositionRelAnchor = _{Data.Select('TOPRIGHT', env.Const.ValidPoints());
		name = '相对锚点';
		desc = '按键上热键文本的相对锚点。';
	};
	---------------------------------------------------------------
	_'动作按键 | 宏文本';
	---------------------------------------------------------------
	LABmacroColor = _{Data.Color(WHITE_FONT_COLOR);
		name = '颜色';
		desc = '按键上宏文本的颜色。';
		deps = { LABhideElementsMacro = false };
	};
	LABmacroFontSize = _{Data.Number(10, 1);
		name = '尺寸';
		desc = '按键上宏文本的字体大小。';
		deps = { LABhideElementsMacro = false };
	};
	LABmacroPositionOffsetX = _{Data.Number(0, 1, true);
		name = 'X 轴偏移';
		desc = '按键上宏文本的水平偏移。';
		deps = { LABhideElementsMacro = false };
	};
	LABmacroPositionOffsetY = _{Data.Number(2, 1, true);
		name = 'Y 轴偏移';
		desc = '按键上宏文本的垂直偏移。';
		deps = { LABhideElementsMacro = false };
	};
	LABmacroJustifyH = _{Data.Select('CENTER', env.Const.ValidJustifyH());
		name = '对齐';
		desc = '按键上宏文本的对齐方式。';
		deps = { LABhideElementsMacro = false };
	};
	LABmacroFontFlags = _{Data.Select('OUTLINE', env.Const.ValidFontFlags());
		name = '字体装饰';
		desc = '按键上宏文本的字体装饰。';
		deps = { LABhideElementsMacro = false };
	};
	LABmacroPositionAnchor = _{Data.Select('BOTTOM', env.Const.ValidPoints());
		name = '锚点';
		desc = '按键上宏文本的锚点。';
		deps = { LABhideElementsMacro = false };
	};
	LABmacroPositionRelAnchor = _{Data.Select('BOTTOM', env.Const.ValidPoints());
		name = '相对锚点';
		desc = '按键上宏文本的相对锚点。';
		deps = { LABhideElementsMacro = false };
	};
	---------------------------------------------------------------
	_'动作按键 | 冷却';
	---------------------------------------------------------------
	LABcountColor = _{Data.Color(WHITE_FONT_COLOR);
		name = '颜色';
		desc = '按键上计数器文本的颜色。';
	};
	LABcountFontSize = _{Data.Number(16, 1);
		name = '尺寸';
		desc = '按键上计数器文本的字体大小。';
	};
	LABcountPositionOffsetX = _{Data.Number(-2, 1, true);
		name = 'X 轴偏移';
		desc = '按键上计数器文本的水平偏移。';
	};
	LABcountPositionOffsetY = _{Data.Number(4, 1, true);
		name = 'Y 轴偏移';
		desc = '按键上计数器文本的垂直偏移。';
	};
	LABcountJustifyH = _{Data.Select('RIGHT', env.Const.ValidJustifyH());
		name = '对齐';
		desc = '按键上计数器文本的对齐方式。';
	};
	LABcountFontFlags = _{Data.Select('OUTLINE', env.Const.ValidFontFlags());
		name = '字体装饰';
		desc = '按键上计数器文本的字体装饰。';
	};
	LABcountPositionAnchor = _{Data.Select('BOTTOMRIGHT', env.Const.ValidPoints());
		name = '锚点';
		desc = '按键上计数器文本的锚点。';
	};
	LABcountPositionRelAnchor = _{Data.Select('BOTTOMRIGHT', env.Const.ValidPoints());
		name = '相对锚点';
		desc = '按键上计数器文本的相对锚点。';
	};
	---------------------------------------------------------------
	_'群组';
	---------------------------------------------------------------
	groupHotkeySize = _{Data.Number(20, 1);
		name = '热键尺寸';
		desc = '按键群组上热键图标的大小。';
	};
	groupHotkeyOffsetX = _{Data.Number(0, 1, true);
		name = '热键 X 轴偏移';
		desc = '按键群组上热键图标的水平偏移。';
	};
	groupHotkeyOffsetY = _{Data.Number(-2, 1, true);
		name = '热键 Y 轴偏移';
		desc = '按键群组上热键图标的垂直偏移。';
	};
	groupHotkeyAnchor = _{Data.Select('CENTER', env.Const.ValidPoints());
		name = '热键锚点';
		desc = '按键群组上热键图标的锚点。';
	};
	groupHotkeyRelAnchor = _{Data.Select('TOP', env.Const.ValidPoints());
		name = '热键相对锚点';
		desc = '按键群组上热键图标的相对锚点。';
	};
	---------------------------------------------------------------
	_'集群';
	---------------------------------------------------------------
	clusterShowAll = _{Data.Bool(false);
		name = '始终显示所有按键';
		desc = '任何时候都显示集群中所有启用的群组。';
		note = '默认情况下，鼠标移动和冷却时会显示控制键。';
	};
	clusterShowFlyoutIcons = _{Data.Bool(true);
		name = '显示控制键图标';
		desc = '显示控制键按键的图标。';
	};
	clusterFullStateModifier = _{Data.Bool(false);
		name = '全状态控制键';
		desc = '启用集群的所有控制键状态，包括未映射的控制键。';
	};
	swipeColor = _{Data.Color(classColor);
		name = '冷却转圈颜色';
		desc = '按键上冷却转圈时的颜色。';
	};
	borderColor = _{Data.Color(WHITE_FONT_COLOR);
		name = '边框顶点颜色';
		desc = '按键边框上顶点的颜色。';
	};
	clusterBorderStyle = _{Data.Select('Normal', 'Normal', 'Large', 'Beveled');
		name = '主按键边框样式';
		desc = '主按键周围边框的样式。';
	};
	---------------------------------------------------------------
	_'工具栏';
	---------------------------------------------------------------
	enableXPBar = _{Data.Bool(true);
		name = '启用状态栏';
		desc = '显示工具栏底部的状态栏。';
		note = '状态栏包括经验条、声望、荣誉、神器能量和艾泽里特。';
	};
	fadeXPBar = _{Data.Bool(false);
		name = '淡出状态栏';
		desc = '鼠标滑出工具栏时淡出状态栏。';
		deps = { enableXPBar = true };
	};
	xpBarColor = _{Data.Color(classColor);
		name = '经验条颜色';
		desc = '经验条的颜色。';
		deps = { enableXPBar = true };
	};
	---------------------------------------------------------------
	_(GENERAL);
	---------------------------------------------------------------
	tintColor = _{Data.Color(classColor);
		name = '色带颜色';
		desc = '某些元素上色带效果的颜色。';
	};
}, function(self, key) return (rawget(self, key) or {})[1] end))
---------------------------------------------------------------
end -- Variables

---------------------------------------------------------------
do -- Cluster information
---------------------------------------------------------------
local M1, M2, M3 = 'M1', 'M2', 'M3';
---------------------------------------------------------------
local NOMOD,  SHIFT,    CTRL,    ALT =
      '',    'SHIFT-', 'CTRL-', 'ALT-';
---------------------------------------------------------------
local SIZE_L,  SIZE_S,  SIZE_T  = 64, 46, 58;
local OFS_MOD, OFS_MID, OFS_FIX = 38, 21, 4;
-----------------------------------------------------------------------------------------------------------------------
local HK_ICONS_SIZE_L, HK_ICONS_SIZE_S = 32, 20;
local HK_ATLAS_SIZE_L, HK_ATLAS_SIZE_S = 18, 12;
-----------------------------------------------------------------------------------------------------------------------
env.Const.Cluster = {
	Directions = CPAPI.Enum('UP', 'DOWN', 'LEFT', 'RIGHT');
	Types      = CPAPI.Enum('Cluster', 'ClusterHandle', 'ClusterButton', 'ClusterShadow');
	ModNames   = CPAPI.Enum(NOMOD, SHIFT, CTRL, CTRL..SHIFT, ALT, ALT..SHIFT, ALT..CTRL, ALT..CTRL..SHIFT);
	SnapPixels = 4;
	PxSize     = SIZE_L;
	Layout = {
		[NOMOD]      = { ----------------------------------------------------------------------------------------------------------
			Prefix   = nil;
			Shadow   = { 82 / SIZE_L, 0.3, CPAPI.GetAsset([[Textures\Button\Shadow]]), {'CENTER', 0, -6} };
			Level    = 4;
			Hotkey   = {{ HK_ICONS_SIZE_L, HK_ATLAS_SIZE_L, {'TOP', 0, 12}, nil }};
			Coords   = {0, 1, 0, 1};
			-----------------------------------------------------------------------------------------------------------------------
		};
		[SHIFT]      = { ----------------------------------------------------------------------------------------------------------
			DOWN     = {'TOPRIGHT', 'BOTTOMLEFT',  OFS_MOD - OFS_FIX,  OFS_MOD + OFS_FIX, Coords = {0, 0,   1, 0,   0, 1,   1, 1}};
			UP       = {'BOTTOMRIGHT', 'TOPLEFT',  OFS_MOD - OFS_FIX, -OFS_MOD - OFS_FIX, Coords = {1, 0,   0, 0,   1, 1,   0, 1}};
			LEFT     = {'BOTTOMRIGHT', 'TOPLEFT',  OFS_MOD + OFS_FIX, -OFS_MOD + OFS_FIX, Coords = {1, 0,   1, 1,   0, 0,   0, 1}};
			RIGHT    = {'BOTTOMLEFT', 'TOPRIGHT', -OFS_MOD - OFS_FIX, -OFS_MOD + OFS_FIX, Coords = {0, 0,   0, 1,   1, 0,   1, 1}};
			-----------------------------------------------------------------------------------------------------------------------
			Prefix   = M1;
			Size     = SIZE_S / SIZE_L;
			TexSize  = SIZE_T / SIZE_S;
			Offset   = OFS_MOD / SIZE_L;
			Hotkey   = {{ HK_ICONS_SIZE_S, HK_ATLAS_SIZE_S, {'CENTER', 0, 0}, M1 }};
			-----------------------------------------------------------------------------------------------------------------------
		};
		[CTRL]       = { ----------------------------------------------------------------------------------------------------------
			DOWN     = {'TOPLEFT', 'BOTTOMRIGHT', -OFS_MOD + OFS_FIX,  OFS_MOD + OFS_FIX, Coords = {0, 1,   1, 1,   0, 0,   1, 0}};
			UP       = {'BOTTOMLEFT', 'TOPRIGHT', -OFS_MOD + OFS_FIX, -OFS_MOD - OFS_FIX, Coords = {1, 1,   0, 1,   1, 0,   0, 0}};
			LEFT     = {'TOPRIGHT', 'BOTTOMLEFT',  OFS_MOD + OFS_FIX,  OFS_MOD - OFS_FIX, Coords = {1, 1,   1, 0,   0, 1,   0, 0}};
			RIGHT    = {'TOPLEFT', 'BOTTOMRIGHT', -OFS_MOD - OFS_FIX,  OFS_MOD - OFS_FIX, Coords = {0, 1,   0, 0,   1, 1,   1, 0}};
			-----------------------------------------------------------------------------------------------------------------------
			Prefix   = M2;
			Size     = SIZE_S / SIZE_L;
			TexSize  = SIZE_T / SIZE_S;
			Offset   = OFS_MOD / SIZE_L;
			Hotkey   = {{ HK_ICONS_SIZE_S, HK_ATLAS_SIZE_S, {'CENTER', 0, 0}, M2 }};
			-----------------------------------------------------------------------------------------------------------------------
		};
		[CTRL..SHIFT] = { ----------------------------------------------------------------------------------------------------------
			DOWN     = {'TOP',          'BOTTOM',                  0,            OFS_MID, Coords = {0, 1,   1, 1,   0, 0,   1, 0}};
			UP       = {'BOTTOM',          'TOP',                  0,           -OFS_MID, Coords = {1, 1,   0, 1,   1, 0,   0, 0}};
			LEFT     = {'RIGHT',          'LEFT',            OFS_MID,                  0, Coords = {1, 0,   1, 1,   0, 0,   0, 1}};
			RIGHT    = {'LEFT',          'RIGHT',           -OFS_MID,                  0, Coords = {0, 0,   0, 1,   1, 0,   1, 1}};
			-----------------------------------------------------------------------------------------------------------------------
			Prefix   = M3;
			Size     = SIZE_S / SIZE_L;
			TexSize  = SIZE_T / SIZE_S * 0.9;
			Offset   = OFS_MID / SIZE_L;
			Hotkey   = {{ HK_ICONS_SIZE_S, HK_ATLAS_SIZE_S, {'CENTER', -4, 0}, M1 },
						{ HK_ICONS_SIZE_S, HK_ATLAS_SIZE_S, {'CENTER',  4, 0}, M2 }};
			-----------------------------------------------------------------------------------------------------------------------
		};
	};
	AdjustTextures = {
		[NOMOD] = {
			Border                =   env.GetAsset([[Textures\Button\Hilite]]);
			CheckedTexture        =   env.GetAsset([[Textures\Button\Hilite]]);
			Flash                 =   env.GetAsset([[Textures\Button\Hilite2x]]);
			NewActionTexture      =   env.GetAsset([[Textures\Button\Hilite]]);
			SpellHighlightTexture =   env.GetAsset([[Textures\Button\Hilite2x.png]]);
		};
		[SHIFT] = {
			Border                =   env.GetAsset([[Textures\Button\M1]]);
			NormalTexture         =   env.GetAsset([[Textures\Button\M1]]);
			PushedTexture         =   env.GetAsset([[Textures\Button\M1]]);
			HighlightTexture      =   env.GetAsset([[Textures\Button\M1Hilite]]);
			CheckedTexture        =   env.GetAsset([[Textures\Button\M1Hilite]]);
			NewActionTexture      =   env.GetAsset([[Textures\Button\M1Hilite]]);
			SpellHighlightTexture =   env.GetAsset([[Textures\Button\M1Hilite]]);
		};
		[CTRL] = {
			Border                =   env.GetAsset([[Textures\Button\M1]]);
			NormalTexture         =   env.GetAsset([[Textures\Button\M1]]);
			PushedTexture         =   env.GetAsset([[Textures\Button\M1]]);
			HighlightTexture      =   env.GetAsset([[Textures\Button\M1Hilite]]);
			CheckedTexture        =   env.GetAsset([[Textures\Button\M1Hilite]]);
			NewActionTexture      =   env.GetAsset([[Textures\Button\M1Hilite]]);
			SpellHighlightTexture =   env.GetAsset([[Textures\Button\M1Hilite]]);
		};
		[CTRL..SHIFT] = {
			Border                =   env.GetAsset([[Textures\Button\M3]]);
			NormalTexture         =   env.GetAsset([[Textures\Button\M3]]);
			PushedTexture         =   env.GetAsset([[Textures\Button\M3]]);
			HighlightTexture      =   env.GetAsset([[Textures\Button\M3Hilite]]);
			CheckedTexture        =   env.GetAsset([[Textures\Button\M3Hilite]]);
			NewActionTexture      =   env.GetAsset([[Textures\Button\M3Hilite]]);
			SpellHighlightTexture =   env.GetAsset([[Textures\Button\M3Hilite]]);
		};
	};
	Assets = {
		CooldownBling             =   env.GetAsset([[Textures\Cooldown\Bling]]);
		CooldownEdge              =   env.GetAsset([[Textures\Cooldown\Edge2x3.png]]);
		MainMask                  = CPAPI.GetAsset([[Textures\Button\Mask]]);
		MainSwipe                 =   env.GetAsset([[Textures\Cooldown\Swipe]]);
		EmptyIcon                 = CPAPI.GetAsset([[Textures\Button\EmptyIcon]]);
	};
	BorderStyle = {
		Normal = {
			NormalTexture         =   env.GetAsset([[Textures\Button\Normal]]);
			PushedTexture         =   env.GetAsset([[Textures\Button\Hilite]]);
			HighlightTexture      =   env.GetAsset([[Textures\Button\Hilite]]);
		};
		Large = {
			NormalTexture         =   env.GetAsset([[Textures\Button\Normal2x.png]]);
			PushedTexture         =   env.GetAsset([[Textures\Button\Normal2x.png]]);
			HighlightTexture      =   env.GetAsset([[Textures\Button\Hilite2x.png]]);
		};
		Beveled = {
			NormalTexture         = CPAPI.GetAsset([[Textures\Button\Normal]]);
			PushedTexture         = CPAPI.GetAsset([[Textures\Button\Hilite]]);
			HighlightTexture      =   env.GetAsset([[Textures\Button\Hilite]]);
		};
	};
	LABConfig = {
		clickOnDown     = true;
		flyoutDirection = 'RIGHT';
		showGrid        = true;
		tooltip         = 'enabled';
		colors = {
			mana =  { 0.5, 0.5, 1.0 };
			range = { 0.8, 0.1, 0.1 };
		};
		hideElements = {
			equipped = false;
			hotkey   = true;
			macro    = false;
		};
	};
};

env.Const.Cluster.Masks, env.Const.Cluster.Swipes = (function(layout, directions)
	-- Generated masks and swipes for each prefix, e.g.:
	-- env.Const.Cluster.Masks.M1.UP = 'MASKS\M1_UP'
	local masks, swipes = {}, {};
	for _, data in pairs(layout) do
		local prefix = data.Prefix;
		if prefix then
			masks[prefix], swipes[prefix] = {}, {};
			for direction in pairs(directions) do
				masks  [prefix][direction] = env.GetAsset([[Textures\Masks\%s_%s]], prefix, direction)
				swipes [prefix][direction] = env.GetAsset([[Textures\Swipes\%s_%s]], prefix, direction)
			end
		end
	end
	return masks, swipes;
end)( env.Const.Cluster.Layout, env.Const.Cluster.Directions )

env.Const.Cluster.ModDriver = (function(driver, ...)
	for _, modifier in ipairs({...}) do
		-- Insert in reverse order to prioritize most complex modifiers
		tinsert(driver, 1, ('[mod:%s] %s'):format(modifier, modifier))
	end
	driver[#driver] = '[nomod]'; -- NOMOD fix
	return table.concat(driver, '; ')..' ;';
end)( {}, env.Const.Cluster.ModNames() )

end -- Cluster information

---------------------------------------------------------------
do -- Artwork
---------------------------------------------------------------
env.Const.Art = {
	Collage = { -- classFile = fileID, texCoordOffset
		WARRIOR     = {1, 1};
		PALADIN     = {1, 2};
		DRUID       = {1, 3};
		DEATHKNIGHT = {1, 4};
		----------------------------
		MAGE        = {2, 1};
		EVOKER      = {2, 1};
		HUNTER      = {2, 2};
		ROGUE       = {2, 3};
		WARLOCK     = {2, 4};
		----------------------------
		SHAMAN      = {3, 1};
		PRIEST      = {3, 2};
		DEMONHUNTER = {3, 3};
		MONK        = {3, 4};
		----------------------------
		[258]       = {3, 2};
	};
	Artifact = { -- classFile = atlas, yOffset
		DEATHKNIGHT = {'DeathKnightFrost', -20};
		DEMONHUNTER = {'DemonHunter',      -20};
		DRUID       = {'Druid',            -50};
		EVOKER      = {'MageArcane',       -30};
		HUNTER      = {'Hunter',             0};
		MAGE        = {'MageArcane',       -30};
		MONK        = {'Monk',             -30};
		PALADIN     = {'Paladin',            0};
		PRIEST      = {'Priest',           -20};
		ROGUE       = {'Rogue',              0};
		SHAMAN      = {'Shaman',           -20};
		WARLOCK     = {'Warlock',          -10};
		WARRIOR     = {'Warrior',           10};
		----------------------------
		[258]       = {'PriestShadow',     -20};
	};
};

env.Const.Art.CollageAsset = env.GetAsset([[Covers\%s]]);
env.Const.Art.ArtifactLine = 'Artifacts-%s-Header';
env.Const.Art.ArtifactRune = 'Artifacts-%s-BG-rune';

env.Const.Art.Types     = CPAPI.Enum('Collage', 'Artifact');
env.Const.Art.Blend     = CPAPI.Enum('ADD', 'BLEND');
env.Const.Art.Selection = {};
env.Const.Art.Flavors   = {};

local localeClassNames = {};
for i = 1, 20 do
	local class, classFile = GetClassInfo(i);
	if classFile then
		localeClassNames[classFile] = class;
	end
end
local function GetLocaleName(classFile)
	if (tonumber(classFile)) then
		return select(2, CPAPI.GetSpecializationInfoByID(tonumber(classFile)))
	end
	return localeClassNames[classFile];
end
for class in env.db.table.spairs(env.Const.Art.Collage) do
	local flavorID = GetLocaleName(class);
	if flavorID then
		tinsert(env.Const.Art.Selection, flavorID);
		env.Const.Art.Flavors[flavorID] = class;
	end
end

end -- Artwork