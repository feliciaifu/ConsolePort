local c, _, env, Data = CreateCounter(), ...; Data = env.db.Data;
_ = function(i) i.sort = c() return i end;
---------------------------------------------------------------
-- Helpers
---------------------------------------------------------------

env.Toplevel = {
	Art     = false;
	Cluster = false;
	Divider = false;
	Group   = false;
	Page    = false;
	Petring = true;
	Toolbar = true;
}; -- k: interface, v: unique

---------------------------------------------------------------
local Type = {}; env.Types = Type;
---------------------------------------------------------------
Type.SimplePoint = Data.Interface {
	name = '位置';
	desc = '元素的位置。';
	Data.Point {
		point = _{
			name = '锚点';
			desc = '连接锚点。';
			Data.Select('CENTER', env.Const.ValidPoints());
		};
		relPoint = _{
			name = '相对锚点';
			desc = '父级锚点的匹配点。';
			Data.Select('CENTER', env.Const.ValidPoints());
		};
		x = _{
			name = 'X 轴偏移';
			desc = '与锚点的水平偏移量。';
			Data.Number(0, 1, true);
		};
		y = _{
			name = 'Y 轴偏移';
			desc = '与锚点的垂直偏移量。';
			vert = true;
			Data.Number(0, 1, true);
		};
	};
};

Type.Visibility = Data.Interface {
	name = '可见性';
	desc = env.MakeMacroDriverDesc(
		'元素的可见性条件。接受成对的宏条件和可见性状态，或单个可见性状态。',
		'根据条件显示或隐藏元素。',
		'condition', 'state', true, nil, {
			['show'] = '显示元素。';
			['hide'] = '隐藏元素。';
		}
	);
	Data.String(env.Const.DefaultVisibility);
};

Type.Opacity = Data.Interface {
	name = '不透明度';
	desc = env.MakeMacroDriverDesc(
		'元素的不透明度条件。接受成对的宏条件和百分比不透明度，或单个不透明度值。',
		'根据条件改变元素的不透明度。',
		'condition', 'opacity', true, nil, {
			['100'] = '完全不透明。';
			['50']  = '半透明。';
			['0']   = '完全透明。';
		}
	);
	note = '不透明度用百分比表示，100表示完全不透明（完全可见），0表示完全透明。超出0到100范围的值将会被限制在该范围内。';
	Data.String('100');
};

Type.Scale = Data.Interface {
	name = '比例';
	desc = env.MakeMacroDriverDesc(
		'元素的缩放条件。接受成对的宏条件与百分比缩放值，或者单一的缩放值。',
		'根据条件对元素进行缩放。',
		'condition', 'scale', true, nil, {
			['100'] = '正常大小。';
			['200'] = '双倍大小。';
			['50']  = '一半大小。';
		}
	);
	Data.String('100');
};

Type.Override = Data.Interface {
	name = '覆盖';
	desc = env.MakeMacroDriverDesc(
		'元素的按键绑定覆盖条件。接受成对的宏条件和覆盖状态，或单个覆盖状态。',
		'设置或取消对元素的按键绑定。',
		'condition', 'override', true, nil, {
			['true']   = '在元素上设置按键绑定。';
			['false']  = '从元素上移除按键绑定。';
			['shown']  = '当元素显示时，按键绑定会被设置到该元素上。';
			['hidden'] = '当元素被隐藏时，按键绑定会被设置到该元素上。';
		}
	);
	Data.String('shown');
};

Type.Modifier = Data.Interface {
	name = '控制键';
	desc = env.MakeMacroDriverDesc(
		'元素的控制键条件。接受成对的宏条件和控制键。',
		'根据当前的控制键显示对应的按键。',
		'condition', 'modifier', false, {
			['M0']   = '没有控制键的简称。';
			['M1']   = 'Shift 控制键的简称。';
			['M2']   = 'Ctrl 控制键的简称。';
			['M3']   = 'Alt 控制键的简称。';
			['[mod:...]'] = '前缀，用于匹配被保留的控制键。';
			['[]']   = '空条件，永远为真。';
		}, {
			['Mn']   = '按键设置为切换到的位置，其中 n 是控制键的编号。可以组合多个控制键。';
		}
	);
	note = '控制键可以组合使用。例如，M1M2 表示同时按住 Shift 和 Ctrl 控制键。';
	Data.String(' ');
};

Type.Page = Data.Interface {
	name = '页面';
	desc = env.MakeMacroDriverDesc(
		'元素的页面条件。接受成对的宏条件和页面标识符，或单个页码。',
		'将按键切换到适用的页面，公式为：\nslotID = (page - 1) * slots + offset + i',
		'condition', 'page', true, env.Const.PageDescription, {
			['dynamic']  = '动态页码，与全局页码相匹配。';
			['override'] = '解析到当前的覆盖页面或载具页面。';
			['n']        = '要切换到的静态页码。';
		}
	);
	Data.String('dynamic');
};

---------------------------------------------------------------
local Interface = {}; env.Interface = Interface;
---------------------------------------------------------------
Interface.ClusterHandle = Data.Interface {
	name = '按键集群';
	desc = '一个按键集群，包含单个按键的所有控制键。';
	Data.Table {
		type = {hide = true; Data.String('ClusterHandle')};
		pos = _(Type.SimplePoint : Implement {
			desc = '按键集群的位置。';
		});
		size = _{
			name = '尺寸';
			desc = '按键集群的尺寸大小。';
			Data.Number(64, 2);
		};
		showFlyouts = _{
			name = '显示悬挂按键';
			desc = '显示按键集群的悬挂小按键。';
			Data.Bool(true);
		};
		dir = _{
			name = '方向';
			desc = '按键集群的悬挂方向。';
			Data.Select('DOWN', env.Const.Cluster.Directions());
		};
	};
};

Interface.Cluster = Data.Interface {
	name = '动作条集群';
	desc = '一个动作条的集群。';
	Data.Table {
		type = {hide = true; Data.String('集群')};
		children = _{
			name = '按键';
			desc = '动作条集群中的按键。';
			Data.Mutable(Interface.ClusterHandle):SetKeyOptions(env.Const.ProxyKeyOptions);
		};
		pos = _(Type.SimplePoint : Implement {
			desc = '动作条集群的位置。';
			{
				point    = 'BOTTOM';
				relPoint = 'BOTTOM';
				y        = 16;
			};
		});
		width = _{
			name = '宽度';
			desc = '动作条集群的宽度。';
			Data.Number(1200, 25);
		};
		height = _{
			name = '高度';
			desc = '动作条集群的高度。';
			Data.Number(140, 25);
		};
		rescale    = _(Type.Scale : Implement {});
		visibility = _(Type.Visibility : Implement {});
		opacity    = _(Type.Opacity : Implement {});
		override   = _(Type.Override : Implement {});
	};
};

Interface.GroupButton = Data.Interface {
	name = '动作按键';
	desc = '群组中的动作按键。';
	Data.Table {
		type = {hide = true; Data.String('GroupButton')};
		pos = Type.SimplePoint : Implement {
			desc = '按键的位置。';
		};
	};
};

Interface.Group = Data.Interface {
	name = '动作按键群组';
	desc = '动作按键的群组。';
	Data.Table {
		type = {hide = true; Data.String('Group')};
		children = _{
			name = '按键';
			desc = '群组中的按键。';
			Data.Mutable(Interface.GroupButton):SetKeyOptions(env.Const.ProxyKeyOptions);
		};
		pos = _(Type.SimplePoint : Implement {
			desc = '群组的位置。';
			{
				point    = 'BOTTOM';
				relPoint = 'BOTTOM';
				y        = 16;
			};
		});
		width = _{
			name = '宽度';
			desc = '群组的宽度。';
			Data.Number(400, 10);
		};
		height = _{
			name = '高度';
			desc = '群组的高度。';
			Data.Number(120, 10);
		};
		modifier   = _(Type.Modifier : Implement {});
		rescale    = _(Type.Scale : Implement {});
		visibility = _(Type.Visibility : Implement {});
		opacity    = _(Type.Opacity : Implement {});
		override   = _(Type.Override : Implement {});
	};
};

Interface.Page = Data.Interface {
	name = '动作页面';
	desc = '动作按键的页面。';
	Data.Table {
		type = {hide = true; Data.String('Page')};
		pos = _(Type.SimplePoint : Implement {
			desc = '页面的位置。';
			{
				point    = 'BOTTOM';
				relPoint = 'BOTTOM';
				y        = 20;
			};
		});
		hotkeys = _{
			name = '显示热键';
			desc = '显示按键上的热键。';
			Data.Bool(true);
		};
		reverse = _{
			name = '逆向排序';
			desc = '反转按键的顺序。';
			Data.Bool(false);
		};
		paddingX = _{
			name = '水平填充';
			desc = '按键之间的水平填充。';
			Data.Number(4, 1);
		};
		paddingY = _{
			name = '垂直填充';
			desc = '按键之间的垂直填充。';
			vert = true;
			Data.Number(4, 1);
		};
		orientation = _{
			name = '方向';
			desc = '页面的方向。';
			Data.Select('HORIZONTAL', 'HORIZONTAL', 'VERTICAL');
		};
		stride = _{
			name = '队列';
			desc = '每行或每列的按键数量。';
			Data.Range(NUM_ACTIONBAR_BUTTONS, 1, 1, NUM_ACTIONBAR_BUTTONS);
		};
		slots = _{
			name = '插槽';
			desc = '页面中按键的数量。';
			Data.Range(NUM_ACTIONBAR_BUTTONS, 1, 1, NUM_ACTIONBAR_BUTTONS);
		};
		offset = _{
			name = '偏移';
			desc = '页面的起始点。';
			Data.Range(1, 1, 1, NUM_ACTIONBAR_BUTTONS);
		};
		page       = _(Type.Page : Implement {});
		rescale    = _(Type.Scale : Implement {});
		visibility = _(Type.Visibility : Implement {});
		opacity    = _(Type.Opacity : Implement {});
		override   = _(Type.Override : Implement {});
	};
};

Interface.Petring = Data.Interface {
	name = '宠物法环';
	desc = '宠物指令的按键法环。';
	Data.Table {
		type = {hide = true; Data.String('Petring')};
		pos = _(Type.SimplePoint : Implement {
			desc = '宠物法环的位置';
			{
				point    = 'BOTTOM';
				relPoint = 'BOTTOM';
				y        = 90;
			};
		});
		fade = _{
			name = '淡出按键';
			desc = '当没有鼠标移动时，淡出宠物法环。';
			Data.Bool(true);
		};
		status = _{
			name = '状态栏';
			desc = '显示宠物的能量和健康状况。';
			Data.Bool(true);
		};
		vehicle = _{
			name = '载具时启用';
			desc = '在载具时显示宠物环。';
			Data.Bool(true);
		};
		scale = _{
			name = '比例';
			desc = '宠物法环的比例。';
			Data.Range(0.75, 0.05, 0.5, 2);
		};
	};
};

Interface.Toolbar = Data.Interface {
	name = '工具栏';
	desc = '一个包含经验条、快捷方式、职业专用栏和其他信息的工具栏。';
	Data.Table {
		type = {hide = true; Data.String('Toolbar')};
		pos = _(Type.SimplePoint : Implement {
			desc = '工具栏的位置';
			{
				point    = 'BOTTOM';
				relPoint = 'BOTTOM';
			};
		});
		menu = _{
			name = '菜单';
			desc = '在工具栏上显示的菜单按键。';
			Data.Table {
				eye = _{
					name = '集群控制键切换';
					desc = '切换动作条集群所有控制键的可见性。';
					Data.Bool(true);
				};
				micromenu = _{
					name = '微菜单';
					desc = '获取微菜单按键的所有权，并将其移至工具栏。';
					note = '禁用时需要 /reload 才能完全解锁。';
					Data.Bool(true);
				};
			};
		};
		castbar = _{
			name = '施法条';
			desc = '施法条的配置。';
			note = '此功能仅在怀旧服中可用。';
			hide = CPAPI.IsRetailVersion;
			Data.Table {
				enabled = _{
					name = '启用';
					desc = '获取施法条的所有权。';
					note = '禁用时需要 /reload 才能完全解锁。';
					Data.Bool(true);
				};
			};
		};
		totem = _{
			name = '职业动作条';
			desc = '职业动作条的配置。';
			note = CPAPI.IsRetailVersion and '此功能仅在怀旧服中可用。';
			hide = CPAPI.IsRetailVersion;
			Data.Table {
				enabled = _{
					name = '启用';
					desc = '获取职业动作条的所有权';
					note = '禁用时需要 /reload 才能完全解锁。';
					Data.Bool(true);
				};
				hidden = _{
					name = '隐藏';
					desc = '隐藏职业动作条。';
					Data.Bool(false);
				};
				pos = _(Type.SimplePoint : Implement {
					desc = '职业动作条的位置。';
					{
						point    = 'BOTTOM';
						relPoint = 'BOTTOM';
						y        = 190;
					};
				});
			};
		};
		width = _{
			name = '宽度';
			desc = '工具栏的宽度。';
			Data.Range(900, 25, 300, 1200);
		};
	};
};

Interface.Divider = Data.Interface {
	name = '分隔线';
	desc = '用于分隔元素的分隔线。';
	Data.Table {
		type = {hide = true; Data.String('Divider')};
		pos = _(Type.SimplePoint : Implement {
			desc = '分隔线的位置。';
			{
				point    = 'BOTTOM';
				relPoint = 'BOTTOM';
				y        = 100;
			};
		});
		breadth = _{
			name = '宽度';
			desc = '分隔线的宽度。';
			Data.Number(400, 25);
		};
		depth = _{
			name = '深度';
			desc = '分隔线的深度。';
			vert = true;
			Data.Number(50, 10);
		};
		thickness = _{
			name = '厚度';
			desc = '分隔线的厚度。';
			Data.Range(1, 1, 1, 10)
		};
		intensity = _{
			name = '渐变强度';
			desc = '渐变的强度。';
			Data.Range(25, 5, 0, 100);
		};
		rotation = _{
			name = '旋转角度';
			desc = '分隔线的旋转角度。';
			Data.Range(0, 5, 0, 360);
		};
		transition = _{
			name = '过渡';
			desc = '不透明度变化的过渡时间。';
			note = '从一种状态到另一种状态的透明度变化所需的时间，单位为毫秒。';
			Data.Range(50, 25, 0, 500);
		};
		opacity = _(Type.Opacity : Implement {});
		rescale = _(Type.Scale : Implement {});
	};
};

Interface.Art = Data.Interface {
	name = '装饰图形';
	desc = '界面中的装饰图形。';
	Data.Table {
		type = {hide = true; Data.String('Art')};
		pos = _(Type.SimplePoint : Implement {
			desc = '装饰图形的位置。';
			{
				point    = 'BOTTOM';
				relPoint = 'BOTTOM';
				y        = 16;
			};
		});
		width = _{
			name = '宽度';
			desc = '装饰图形的宽度。';
			Data.Number(768, 16);
		};
		height = _{
			name = '高度';
			desc = '装饰图形的高度。';
			Data.Number(192, 16);
		};
		style = _{
			name = '风格';
			desc = '装饰图形的风格。';
			Data.Select('Collage', env.Const.Art.Types());
		};
		flavor = _{
			name = '类型';
			desc = '装饰图形的类型。';
			Data.Select('Class', 'Class', unpack(env.Const.Art.Selection));
		};
		blend = _{
			name = '混合模式';
			desc = '装饰图形的混合模式。';
			Data.Select('BLEND', env.Const.Art.Blend());
		};
		opacity = _(Type.Opacity : Implement {});
		rescale = _(Type.Scale : Implement {});
	};
};