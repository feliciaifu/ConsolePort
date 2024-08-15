local __, db = ...; __ = 1; local Profile = {};
local kSelectAxisOptions = {
	LStickX = '左摇杆 X',
	LStickY = '左摇杆 Y',
	RStickX = '右摇杆 X',
	RStickY = '右摇杆 Y',
	LTrigger = '左扳机键',
	RTrigger = '右扳机键',
	GStickX = '陀螺仪 X',
	GStickY = '陀螺仪 Y',
	PStickX = '触摸板 X',
	PStickY = '触摸板 Y',
};
setfenv(__, setmetatable(db('Data'), {__index = _G}));
------------------------------------------------------------------------------------------------------------
-- Gamepad API profile values
------------------------------------------------------------------------------------------------------------
db:Register('Profile', {
	['移动'] = {
		{	name = '移动操作死区';
			path = 'stickConfigs/<stick:Movement>/deadzone';
			data = Range(0.25, 0.05, 0, 0.95);
			desc = '死区是指不响应的范围。设置移动死区，可以有效减少轻微移动导致的误操作。';
			note = ('|T%s:128:128:0|t'):format([[Interface\AddOns\ConsolePort_Config\Assets\Deadzone2Da.blp]]);
		};
		{
			name = '移动 X 轴';
			path = 'stickConfigs/<stick:Movement>/axisX';
			data = Map('LStickX', kSelectAxisOptions);
			desc = '用于左移/右移模拟输入。';
		};
		{
			name = '移动 Y 轴';
			path = 'stickConfigs/<stick:Movement>/axisY';
			data = Map('LStickY', kSelectAxisOptions);
			desc = '用于前进/后退的模拟输入。';
		};
	};
	['摄像机操作'] = {
		{	name = '摄像机偏转死区';
			path = 'stickConfigs/<stick:Camera>/deadzoneX';
			data = Range(0.05, 0.05, 0, 0.95);
			desc = '死区是指不响应的范围。设置偏转死区，目的是减少轻微偏转导致误操作。';
			note = ('|T%s:128:128:0|t'):format([[Interface\AddOns\ConsolePort_Config\Assets\DeadzoneXa.blp]]);
		};
		{	name = '摄像机仰俯死区';
			path = 'stickConfigs/<stick:Camera>/deadzoneY';
			data = Range(0.2, 0.05, 0, 0.95);
			desc = '死区是指不响应的范围。设置仰俯死区，目的是减少轻微仰俯导致误操作。';
			note = ('|T%s:128:128:0|t'):format([[Interface\AddOns\ConsolePort_Config\Assets\DeadzoneYa.blp]]);
		};
		{	name = '摄像机 2D 死区';
			path = 'stickConfigs/<stick:Camera>/deadzone';
			data = Range(0.25, 0.05, 0, 0.95);
			desc = '摄像机的 2D 死区，同时兼顾俯仰和偏转操作的区域。';
			note = ('|T%s:128:128:0|t'):format([[Interface\AddOns\ConsolePort_Config\Assets\Deadzone2Da.blp]]);
		};
		{
			name = '摄像机偏转轴';
			path = 'stickConfigs/<stick:Camera>/axisX';
			data = Map('RStickX', kSelectAxisOptions);
			desc = '用于摄像机左转/右转的模拟输入。';
		};
		{
			name = '摄像机仰俯轴';
			path = 'stickConfigs/<stick:Camera>/axisY';
			data = Map('RStickY', kSelectAxisOptions);
			desc = '用于摄像机上倾/下倾的模拟输入。';
		};
		{
			name = '观察视角偏转轴';
			path = 'stickConfigs/<stick:Look>/axisX';
			data = Map('GStickX', kSelectAxisOptions);
			desc = '用于观察视角左转/右转的模拟输入。';
			note = '观察视角是基于当前视野，临时转动摄像机查看其他视角。';
		};
		{
			name = '观察视角仰俯轴';
			path = 'stickConfigs/<stick:Look>/axisY';
			data = Map('GStickY', kSelectAxisOptions);
			desc = '用于观察视角上倾/下倾的模拟输入。';
			note = '观察视角是基于当前视野，临时转动摄像机查看其他视角。';
		};
	};
}, Profile)

function Profile:GetObject(path)
	for section, fields in pairs(self) do
		for i, field in ipairs(fields) do
			if ( field.path == path ) then
				return field, section, i;
			end
		end
	end
end

function Profile:GetConfiguredValue(path)
	local field = self:GetObject(path)
	if field then
		return field.data:Get()
	end
end