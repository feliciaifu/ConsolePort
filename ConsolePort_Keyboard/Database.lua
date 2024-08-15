local Data, _, env = ConsolePort:DB('Data'), ...; _ = CPAPI.Define;

env.DefaultLayout = {
	[1] = { 
		{"a", "A", "1", "/s "},
		{"b", "B", "2", "/p "},
		{"c", "C", "3", "/i "},
		{"d", "D", "4", "/g "},
	},
	[2] = { 
		{"e", "E", "5", "/y "},
		{"f", "F", "6", "/w "},
		{"g", "G", "7", "/e "},
		{"h", "H", "8", "/r "},
	},
	[3] = { 
		{"i", "I", "9", "/raid "},
		{"j", "J", "<", "/readycheck "},
		{"k", "K", "0", "/rw "},
		{"l", "L", ">", "%T "},
	},
	[4] = { 
		{"m", "M", "@", "^"},
		{"n", "N", "&", "#"},
		{"o", "O", "$", "€"},
		{"p", "P", "%", "£"},
	},
	[5] = { 
		{"q", "Q", "/", "½"},
		{"r", "R", "(", "["},
		{"s", "S", "\\", "\|"},
		{"t", "T", ")", "]"},
	},
	[6] = { 
		{"u", "U", "+", "§"},
		{"v", "V", "*", "{"},
		{"w", "W", "=", "¿"},
		{"x", "X", "/", "}"},
	},
	[7] = { 
		{"y", "Y", "{rt1}", "{rt1}"},
		{"z", "Z", "{rt2}", "{rt2}"},
		{"\"", "'", "{rt3}", "{rt3}"},
		{"-", "_", "{rt4}", "{rt4}"},
	},
	[8] = { 
		{"!", "!", "{rt5}", "{rt5}"},
		{".", ":", "{rt6}", "{rt6}"},
		{",", ";", "{rt7}", "{rt7}"},
		{"?", "?", "{rt8}", "{rt8}"},
	},
}

env.DefaultMarkers = {
	["{rt1}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1:0|t",
	["{rt2}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2:0|t",
	["{rt3}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3:0|t",
	["{rt4}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4:0|t",
	["{rt5}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5:0|t",
	["{rt6}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6:0|t",
	["{rt7}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7:0|t",
	["{rt8}"] = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8:0|t",
	
	["{ck1}"] = "|TInterface\\AddOns\\ConsolePortKeyboard\\Textures\\IconSpace:0|t",
	["{ck2}"] = "|TInterface\\AddOns\\ConsolePortKeyboard\\Textures\\IconEraser:0|t",
	["{ck3}"] = "|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t",
	["{ck4}"] = "|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0|t",

	["/rw "] = "|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:0|t",
	["/raid "] = "|TInterface\\Scenarios\\ScenarioIcon-Boss:0|t",
	["/readycheck "] = "|TInterface\\RAIDFRAME\\ReadyCheck-Waiting:0|t",
	["/attacktarget "] = "|TInterface\\CURSOR\\Attack:0|t",

	["%T "] = "|TInterface\\MINIMAP\\TRACKING\\Target:0|t",
	["%T"]  = "|TInterface\\MINIMAP\\TRACKING\\Target:0|t",
	["%F "] = "|TInterface\\MINIMAP\\TRACKING\\Focus:0|t",
	["%F"]  = "|TInterface\\MINIMAP\\TRACKING\\Focus:0|t",

	["/s "] = "/s",
	["/p "] = "/p",
	["/i "] = "/i",
	["/g "] = "/g",
	["/y "] = "/y",
	["/w "] = "/w",
	["/e "] = "/e",
	["/r "] = "/r",
}

function env:GetText(text)
	return self.Markers[text] or text;
end

local DEPENDENCY = { keyboardEnable = true };
ConsolePort:AddVariables({
	_('Radial Keyboard', 2);
	keyboardSpaceButton = _{Data.Button('PAD1');
		name = '空格';
		desc = '触发空格指令的按键。';
		deps = DEPENDENCY;
	};
	keyboardEnterButton = _{Data.Button('PAD2');
		name = '回车';
		desc = '触发回车指令的按键。';
		deps = DEPENDENCY;
	};
	keyboardEraseButton = _{Data.Button('PAD3');
		name = '退格';
		desc = '触发退格指令的按键。';
		deps = DEPENDENCY;
	};
	keyboardEscapeButton = _{Data.Button('PAD4');
		name = 'ESC';
		desc = '触发 ESC 指令的按键。';
		deps = DEPENDENCY;
	};
	keyboardMoveLeftButton = _{Data.Button('PADDLEFT');
		name = '左移';
		desc = '向左移动光标的按键。';
		deps = DEPENDENCY;
	};
	keyboardMoveRightButton = _{Data.Button('PADDRIGHT');
		name = '右移';
		desc = '向右移动光标的按键。';
		deps = DEPENDENCY;
	};
	keyboardNextWordButton = _{Data.Button('PADDDOWN');
		name = '下一个词';
		desc = '选择下一个建议单词的按键。';
		deps = DEPENDENCY;
	};
	keyboardPrevWordButton = _{Data.Button('PADDUP');
		name = '上一个词';
		desc = '选择上一个建议单词的按键。';
		deps = DEPENDENCY;
	};
	keyboardAutoCorrButton = _{Data.Button('PADRTRIGGER');
		name = '单词补全';
		desc = '插入建议单词的按键。';
		deps = DEPENDENCY;
	};
	keyboardDictPattern = _{Data.String("[%a][%w']*[%w]+");
		name = '字典匹配模式';
		desc = '用于匹配字词的 Lua 模式，以便查询字典。';
		advd = true;
		deps = DEPENDENCY;
	};
	keyboardDictAlphabet = _{Data.String('abcdefghijklmnopqrstuvwxyz');
		name = '字典匹配字母';
		desc = '用于字典建议和文字处理的字母。';
		advd = true;
		deps = DEPENDENCY;
	};
	keyboardDictYieldRate = _{Data.Number(4000, 500, true);
		name = '自动更正效率';
		desc = '每一帧产生的修正差异的数量。';
		note = '更高的速率会更快地生成建议，但可能会造成卡顿。';
		advd = true;
		deps = DEPENDENCY;
	};
})