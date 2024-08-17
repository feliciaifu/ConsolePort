local db, Data, _, env = ConsolePort:DB(), ConsolePort:DB('Data'), ...; _, env.db = CPAPI.Define, db;
local MODID_SELECT = {'SHIFT', 'CTRL', 'ALT'};
local DEPENDENCY = { UIenableCursor = true };

---------------------------------------------------------------
-- Add variables to config
---------------------------------------------------------------
ConsolePort:AddVariables({
	_('界面光标', 2);
	UIpointerAnimation = _{Data.Bool(true);
		name = '显示默认按键';
		desc = '显示默认鼠标操作按键。';
		deps = DEPENDENCY;
		advd = true;
	};
	UIpointerSound = _{Data.Bool(true);
		name = '启用动画';
		desc = '指针箭头沿行进方向旋转。';
		deps = DEPENDENCY;
		advd = true;
	};
	UIpointerDefaultIcon = _{Data.Bool(true);
		name = '显示默认按键';
		desc = '显示默认的鼠标操作按键。';
		deps = DEPENDENCY;
		advd = true;
	};
	UIaccessUnlimited = _{Data.Bool(false);
		name = '无限模式';
		desc = '允许光标与整个界面交互，而不仅仅是面板。';
		note = '与需求模式相结合，实现完全的光标控制。';
		deps = DEPENDENCY;
		advd = true;
	};
	UIshowOnDemand = _{Data.Bool(false);
		name = '需求模式';
		desc = '光标按需出现，而不是在面板出现时响应出现。';
		note = '需要切换界面光标绑定按键才能使用光标。';
		deps = DEPENDENCY;
		advd = true;
	};
	UIholdRepeatDisable = _{Data.Bool(false);
		name = '禁用重复移动';
		desc = '禁用重复的光标移动 - 每次点击只会移动光标一次。';
		deps = DEPENDENCY;
	};
	UIholdRepeatDelay = _{Data.Number(.125, 0.025);
		name = '重复移动延迟';
		desc = '按住一个方向时，重复移动的延迟时间，单位为秒。';
		deps = { UIenableCursor = true, UIholdRepeatDisable = false };
		advd = true;
	};
	UIholdRepeatDelayFirst = _{Data.Number(.125, 0.025);
		name = '重复移动第一次延迟';
		desc = '按住一个方向时，第一次响应重复移动的延迟时间，单位为秒。';
		deps = { UIenableCursor = true, UIholdRepeatDisable = false };
		advd = true;
	};
	UIleaveCombatDelay = _{Data.Number(0.5, 0.1);
		name = '重启延迟';
		desc = '在离开战斗后重新激活界面光标的延迟时间，单位为秒。';
		deps = DEPENDENCY;
		advd = true;
	};
	UIpointerSize = _{Data.Number(22, 2, true);
		name = '指针尺寸';
		desc = '指针箭头的尺寸，单位为像素。';
		deps = DEPENDENCY;
		advd = true;
	};
	UIpointerOffset = _{Data.Number(-2, 1);
		name = '指针偏移';
		desc = '指针箭头与所选节点中心的偏移量，单位为像素。';
		deps = DEPENDENCY;
		advd = true;
	};
	UItravelTime = _{Data.Range(4, 1, 1, 10);
		name = '移动时间';
		desc = '光标从一个节点移动到另一个节点所需的时间。';
		note = '数值越高速度越慢。';
		deps = DEPENDENCY;
		advd = true;
	};
	UICursorLeftClick = _{Data.Button('PAD1');
		name = KEY_BUTTON1;
		desc = '用于复制鼠标左键点击的按键。这是主要的界面操作动作。';
		note = '在长按时，可以通过点击方向键来模拟拖动操作。';
		deps = DEPENDENCY;
	};
	UICursorRightClick = _{Data.Button('PAD2');
		name = KEY_BUTTON2;
		desc = '用于复制鼠标右键点击的按键。这是次要的界面操作动作。';
		note = '这个按键是直接从你的背包中使用或出售物品所必需的。';
		deps = DEPENDENCY;
	};
	UICursorSpecial = _{Data.Button('PAD4');
		name = '特殊按键';
		desc = '用于处理特殊动作的按键，例如将物品添加到多功能法环。';
		deps = DEPENDENCY;
	};
	UICursorCancel = _{Data.Button('PAD3');
		name = '取消按键';
		desc = '用于处理取消操作的按键，如退出菜单。';
		deps = DEPENDENCY;
	};
	UImodifierCommands = _{Data.Select('SHIFT', unpack(MODID_SELECT));
		name = '控制键';
		desc = '设置用来修改操作的控制键。';
		note = '控制键可以和方向键一起用来滚动。';
		opts = MODID_SELECT;
		deps = DEPENDENCY;
	};
})

---------------------------------------------------------------
-- Standalone frame stack
---------------------------------------------------------------
-- This list aims to contain all the frames, popups, panels
-- that are not caught by frame managers (e.g. UIPanelWindows),
-- and exist within the FrameXML code in some shape or form. 

env.StandaloneFrameStack = {
	'ContainerFrameCombinedBags';
	'CovenantPreviewFrame';
	'EngravingFrame';
	'LFGDungeonReadyPopup';
	'OpenMailFrame';
	'PetBattleFrame';
	'ReadyCheckFrame';
	'SplashFrame';
	'StackSplitFrame';
	'UIWidgetCenterDisplayFrame';
	'FloatingChatFrame';
	'ScrollingMessageFrame';
	'BuffFrame';
	'Blizzard_ObjectiveTrackerContainer';
	'CompactRaidFrameManager';
	'PartyFrame';
	'ObjectiveTrackerFrame';
};
for i=1, (NUM_CONTAINER_FRAMES   or 13) do tinsert(env.StandaloneFrameStack, 'ContainerFrame'..i) end
for i=1, (NUM_GROUP_LOOT_FRAMES  or 4)  do tinsert(env.StandaloneFrameStack, 'GroupLootFrame'..i) end
for i=1, (STATICPOPUP_NUMDIALOGS or 4)  do tinsert(env.StandaloneFrameStack, 'StaticPopup'..i)    end

env.UnlimitedFrameStack = {
	UIParent;
	DropDownList1;
	DropDownList2;
};


---------------------------------------------------------------
-- Frame management resources
---------------------------------------------------------------

-- Managers are periodically scanned by the frame stack handler
-- to add new frames to the registry. The table is associative
-- if the value is true, and indexed if the value is false.
env.FrameManagers = { -- table, isAssociative
	[UIPanelWindows]  = true;
	[UISpecialFrames] = false;
	[UIMenus]         = false;
};

-- Pipelines are hooked by the frame stack handler to add new
-- frames to the registry as they pass through the pipeline.
-- Global references are hooked by name, and methods are hooked
-- by name and method name.
env.FramePipelines = { -- global ref, bool or method
	ShowUIPanel             = true;
	StaticPopupSpecial_Show = true;
	HelpTipTemplateMixin    = 'Init';
};

---------------------------------------------------------------
-- Node management resources
---------------------------------------------------------------
env.IsClickableType = {
	Button      = true;
	CheckButton = true;
	EditBox     = true;
};

env.DropdownReplacementMacro = {
	SET_FOCUS   = '/focus %s';
	CLEAR_FOCUS = '/clearfocus';
	PET_DISMISS = '/petdismiss';
};

env.Attributes = {
	IgnoreNode   = 'nodeignore';
	IgnoreScroll = 'nodeignorescroll';
	PassThrough  = 'nodepass';
	Priority     = 'nodepriority';
	Singleton    = 'nodesingleton';
	SpecialClick = 'nodespecialclick';
	CancelClick  = 'nodecancelclick';
	IgnoreMime   = 'nodeignoremime';
};

---------------------------------------------------------------
-- Unavoidable taint error messages
---------------------------------------------------------------
env.ForbiddenActions = CPAPI.Proxy({
	['FocusUnit()'] = ([[
		当界面光标处于激活状态时，无法可靠地从单位下拉菜单中设置焦点。

		请使用其他方法来设置焦点，例如使用 %s 绑定、/focus 宏或团队光标。
	]]):format(BLUE_FONT_COLOR:WrapTextInColorCode(BINDING_NAME_FOCUSTARGET));
	['ClearFocus()'] = ([[
		当界面光标处于激活状态时，无法可靠地从单位下拉菜单中清除焦点。

		请使用其他方法来清除焦点，例如使用 %s 绑定、/focus 宏或团队光标。
	]]):format(BLUE_FONT_COLOR:WrapTextInColorCode(BINDING_NAME_FOCUSTARGET));
	['CastSpellByID()'] = [[
		当界面光标处于激活状态时，一些操作可能无法可靠地执行。
		你似乎尝试从受到界面光标影响的来源施放一个法术。

		请使用其他方法来施放这个法术，比如使用宏或你的动作条。
	]];
}, function()
	return [[
		当界面光标处于激活状态时，一些操作可能无法可靠地执行。
		你似乎尝试执行了一个被光标污染而被阻止的操作。

		你也许可以忽略此消息，但如果你的界面没有正常工作，可能需要重新加载。
	]];
end);