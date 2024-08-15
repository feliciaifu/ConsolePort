local db, Data, _, env = ConsolePort:DB(), ConsolePort:DB('Data'), ...; _, env.db = CPAPI.Define, db;
------------------------------------------------------------------------------------------------------------
ConsolePort:AddVariables({
------------------------------------------------------------------------------------------------------------
	_(MAINMENU_BUTTON, 2);
	gameMenuScale = _{Data.Range(0.85, 0.05, 0.5, 2);
		name = '比例';
		desc = '游戏菜单和环形菜单的比例。';
	};
	gameMenuFontSize = _{Data.Range(15, 1, 8, 20);
		name = '字体大小';
		desc = '环形菜单中按键的字体大小。';
	};
	gameMenuCustomSet = _{Data.Bool(false);
		name = '使用自定义按键集群';
		desc = '在游戏菜单中使用自定义按键集群，否则将动态生成按键集群。';
	};
	gameMenuAccept = _{Data.Button('PAD1');
		name = '主要按键';
		desc = '执行操作并关闭菜单。';
		deps = { gameMenuCustomSet = true };
	};
	gameMenuPlural = _{Data.Button('PAD2');
		name = '次要按键';
		desc = '执行操作而不会关闭菜单。';
		deps = { gameMenuCustomSet = true };
	};
	gameMenuReturn = _{Data.Button('PADLSHOULDER');
		name = '返回按键';
		desc = '返回上一个菜单。';
		deps = { gameMenuCustomSet = true };
	};
	gameMenuSwitch = _{Data.Button('PADRSHOULDER');
		name = '切换按键';
		desc = '在主菜单和环形菜单之间切换。';
		deps = { gameMenuCustomSet = true };
	};
})