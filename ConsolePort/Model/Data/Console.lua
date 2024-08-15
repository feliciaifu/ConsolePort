-- Consts
local MOTION_SICKNESS_CHARACTER_CENTERED = MOTION_SICKNESS_CHARACTER_CENTERED or '保持角色居中';
local MOTION_SICKNESS_REDUCE_CAMERA_MOTION = MOTION_SICKNESS_REDUCE_CAMERA_MOTION or '减少摄像机运动';
local SOFT_TARGET_DEVICE_OPTS = {[0] = OFF, [1] = '手柄', [2] = '键鼠', [3] = ALWAYS};
local SOFT_TARGET_ARC_ALLOWANCE = {[0] = '前方', [1] = '锥形', [2] = '周围'};
local unpack, _, db = unpack, ...; local Console = {}; db('Data')();
------------------------------------------------------------------------------------------------------------
-- Blizzard console variables
------------------------------------------------------------------------------------------------------------
db:Register('Console', CPAPI.Proxy({
	--------------------------------------------------------------------------------------------------------
	Emulation = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'GamePadEmulateShift';
			type = Button;
			name = '模拟 Shift';
			desc = '模拟 Shift 键的按键。按住该按键可激活对应的按键集。';
			note = '建议作为首选控制键。';
		};
		{	cvar = 'GamePadEmulateCtrl';
			type = Button;
			name = '模拟 Ctrl';
			desc = '模拟 Ctrl 键的按键。按住该按键可激活对应的绑定按键集';
			note = '建议作为次选控制键';
		};
		{ 	cvar = 'GamePadEmulateAlt';
			type = Button;
			name = '模拟 Alt';
			desc = '模拟 Alt 键的按键。';
			note = '只推荐高级用户使用。';
		};
		{	cvar = 'GamePadCursorLeftClick';
			type = Button;
			name = KEY_BUTTON1;
			desc = '在控制鼠标光标时模拟左键点击的按键。';
			note = '如果光标当前处于居中固定或隐藏状态，则在使用时激活鼠标光标。';
		};
		{	cvar = 'GamePadCursorRightClick';
			type = Button;
			name = KEY_BUTTON2;
			desc = '在控制鼠标光标时模拟右键点击的按键。';
			note = '用于在中心固定位置与世界互动。';
		};
		{	cvar = 'GamePadEmulateTapWindowMs';
			type = Number(350, 25);
			name = '模拟控制键按下的窗口期';
			desc = '模拟控制键的按键会在按下和松开的时间段内（窗口期），激活对应的按键集。';
			note = '以毫秒为单位。按下控制键和按键的任何组合都会取消激活效果。';
		};
	};
	--------------------------------------------------------------------------------------------------------
	Cursor = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'interactOnLeftClick';
			type = Bool(false);
			name = INTERACT_ON_LEFT_CLICK_TEXT;
			desc = OPTION_TOOLTIP_INTERACT_ON_LEFT_CLICK;
			note = '同时影响鼠标和游戏手柄。';
		};
		{	cvar = 'GamePadCursorAutoDisableJump';
			type = Bool(true);
			name = '跳跃时隐藏光标';
			desc = '在跳跃时禁用自由移动的鼠标光标。';
		};
		{	cvar = 'GamePadCursorAutoDisableSticks';
			type = Map(2, {[0] = NONE, [1] = TUTORIAL_TITLE2, [2] = STATUS_TEXT_BOTH});
			name = '摇杆输入时禁用光标';
			desc = '使用摇杆时，禁用自由移动的鼠标光标。';
			note = '当设置为双摇杆输入时，光标只会在双摇杆同时使用时禁用。';
		};
		{	cvar = 'CursorCenteredYPos';
			type = Range(0.6, 0.025, 0, 1);
			name = '光标中心位置';
			desc = '光标水平和垂直位置，处于屏幕高度的百分比。';
		};
		{	cvar = 'GamePadCursorSpeedStart';
			type = Number(0.1, 0.05);
			name = '光标启动速度';
			desc = '光标开始移动时的速度。';
		};
		{	cvar = 'GamePadCursorSpeedAccel';
			type = Number(2, 0.1);
			name = '光标加速度';
			desc = '光标持续移动时每秒的加速度。';
		};
		{	cvar = 'GamePadCursorSpeedMax';
			type = Number(1, 0.1);
			name = '光标最大速度';
			desc = '光标移动的最高速度。';
		};
	};
	--------------------------------------------------------------------------------------------------------
	Camera = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'CameraKeepCharacterCentered';
			type = Bool(true);
			name = MOTION_SICKNESS_CHARACTER_CENTERED;
			desc = '保持角色居中，减少眩晕。';
		};
		{	cvar = 'CameraReduceUnexpectedMovement';
			type = Bool(true);
			name = MOTION_SICKNESS_REDUCE_CAMERA_MOTION;
			desc = '减少摄像头意外移动，减少眩晕。';
		};
		{	cvar = 'test_cameraDynamicPitch';
			type = Bool(false);
			name = '动态仰俯角';
			desc = '在放大时向上倾斜摄像头。';
			note = ('不兼容 %s.'):format(MOTION_SICKNESS_CHARACTER_CENTERED);
		};
		{	cvar = 'test_cameraOverShoulder';
			type = Range(0, 0.5, -1.0, 1.0);
			name = '越肩视角';
			desc = '将摄像头水平偏离角色，使视角更具电影效果。';
			note = ('不兼容 %s.'):format(MOTION_SICKNESS_CHARACTER_CENTERED);
		};
		{	cvar = 'CameraFollowOnStick';
			type = Bool(false);
			name = '跟随摇杆（FOAS）';
			desc = '自动调整摄像头，让你只需一根摇杆就能控制移动。';
			note = ('|T%s:128:128:0|t'):format([[Interface\AddOns\ConsolePort_Config\Assets\jose.blp]]);
		};
		{	cvar = 'CameraFollowGamepadAdjustDelay';
			type = Number(1, 0.25);
			name = 'FOAS 延迟调节';
			desc = '当摄像头控制处于空闲状态时，开始调整前的延迟（秒）。';
		};
		{	cvar = 'CameraFollowGamepadAdjustEaseIn';
			type = Number(1, 0.25);
			name = 'FOAS 调节缓冲';
			desc = '从空闲摄像头过渡到自动调整（FOAS）所需的时间。';
		};
		{
			cvar = 'GamePadCameraLookMaxYaw';
			type = Range(0, 15, -180, 180);
			name = '观察视角的最大偏转';
			desc = '最大偏转角度的设置，用于摄像头的“观察视角”功能。';
			note = '观察视角是基于当前视野，临时转动摄像头查看其他视角的角度。';
		};
		{
			cvar = 'GamePadCameraLookMaxPitch';
			type = Range(0, 5, 0, 90);
			name = '观察视角的最大仰俯';
			desc = '最大仰俯角度的设置，用于摄像头的“观察视角”功能。';
			note = '观察视角是基于当前视野，临时转动摄像头查看其他视角的角度。';
		};
		{	cvar = 'GamePadCameraYawSpeed';
			type = Range(1, 0.25, -4.0, 4.0);
			name = '摄像头的偏转速度';
			desc = '摄像头的偏转速度 - 左转/右转。';
			note = '使用负值可以反转坐标轴。';
		};
		{	cvar = 'GamePadCameraPitchSpeed';
			type = Range(1, 0.25, -4.0, 4.0);
			name = '摄像头的仰俯速度';
			desc = '摄像头的仰俯速度 - 向上/向下。';
			note = '使用负值可以反转坐标轴。';
		};
	};
	--------------------------------------------------------------------------------------------------------
	System = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'synchronizeSettings';
			type = Bool(true);
			name = '同步设置';
			desc = '是否将本地设置保存到服务器。';
			note = '主要包含同步按键绑定、同步插件配置和同步宏。';
		};
		{	cvar = 'synchronizeBindings';
			type = Bool(true);
			name = '同步按键绑定';
			desc = '是否将本地按键绑定保存到服务器。';
		};
		{	cvar = 'synchronizeConfig';
			type = Bool(true);
			name = '同步插件配置';
			desc = '是否将角色和账户的配置保存到服务器。';
		};
		{	cvar = 'synchronizeMacros';
			type = Bool(true);
			name = '同步宏';
			desc = '是否将本地宏保存到服务器。';
		};
		{	cvar = 'GamePadUseWinRTForXbox';
			type = Bool(true);
			name = '使用 WinRT 游戏手柄映射（Xbox）';
			desc = '使用微软 API 将 Xbox 控制器映射到游戏中。';
			note = '如果遇到移动和按键绑定问题，请禁用。';
		};
		{	cvar = 'GamePadEmulateEsc';
			type = Button;
			name = '模拟 Esc';
			desc = '模拟 Esc 键的按键。';
			note = '该键可通过绑定“切换游戏菜单”来替代。在使用 ConsolePort 时不需要这种模拟。';
		};
		{	cvar = 'GamePadOverlapMouseMs';
			type = Number(2000, 100);
			name = '多重输入设备的重叠之间';
			desc = '同时使用游戏手柄和鼠标后，再切换到其中一个的持续时间，单位为毫秒。';
		};
	};
	--------------------------------------------------------------------------------------------------------
	Interact = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'SoftTargetInteract';
			type = Map(0, SOFT_TARGET_DEVICE_OPTS);
			name = '启用交互键';
			desc = '启用交互键，与游戏世界中的物体和生物进行交互。';
			note = ('要与目标交互，请使用绑定按键 %s.'):format(BLUE_FONT_COLOR:WrapTextInColorCode(BINDING_NAME_INTERACTTARGET));
		};
		{	cvar = 'SoftTargetInteractArc';
			type = Map(0, SOFT_TARGET_ARC_ALLOWANCE);
			name = '响应角度容错';
			desc = '互动键能够响应目标的有效区域。';
		};
		{	cvar = 'SoftTargetInteractRange';
			type = Range(10, 1, 1, 45);
			name = '目标范围';
			desc = '控制可交互目标或物体被发现的范围。';
			note = '不影响与目标互动的实际范围，不同目标可能有不同的范围。';
		};
		{	cvar = 'SoftTargetInteractRangeIsHard';
			type = Bool(false);
			name = '目标范围硬截断';
			desc = '设置范围是否应该是一个硬性的范围，即使你可以在更大的范围与之互动。';
		};
		{	cvar = 'SoftTargetIconInteract';
			type = Bool(true);
			name = '显示目标图标';
			desc = '在当前可交互目标上方显示图标。';
		};
		{	cvar = 'SoftTargetIconGameObject';
			type = Bool(true);
			name = '显示对象图标';
			desc = '在当前可交互对象上方显示图标。';
		};
		{	cvar = 'SoftTargetTooltipInteract';
			type = Bool(false);
			name = '显示提示';
			desc = '可交互对象显示提示。';
		};
	};
	--------------------------------------------------------------------------------------------------------
	Targeting = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'SoftTargetEnemy';
			type = Map(0, SOFT_TARGET_DEVICE_OPTS);
			name = '启用软敌对目标锁定';
			desc = '只需注视敌对目标，便可自动锁定目标。';
			note = '使用瞄准按键，将软目标变成硬目标。';
		};
		{	cvar = 'SoftTargetFriend';
			type = Map(0, SOFT_TARGET_DEVICE_OPTS);
			name = '启用软友善目标锁定';
			desc = '只需注视友善目标，便可自动锁定目标。';
			note = '在锁定一个敌对硬目标的同时，也可以获取一个友善软目标。';
		};
		{	cvar = 'SoftTargetForce';
			type = Map(0, {[0] = OFF, [1] = ENEMY, [2] = FRIEND});
			name = '强制硬目标';
			desc = '自动设置目标以匹配软目标。';
		};
		{	cvar = 'SoftTargetMatchLocked';
			type = Map(0, {[0] = OFF, [1] = '显性', [2] = '隐性'});
			name = '目标匹配锁定';
			desc = '将适当的软目标匹配至锁定目标。';
			note = '显性仅匹配硬锁定目标，而隐性匹配你攻击的目标。';
		};
		{	cvar = 'SoftTargetNameplateEnemy';
			type = Bool(true);
			name = '显示软敌对目标姓名板';
			desc = '始终显示软敌对目标的姓名板。';
		};
		{	cvar = 'SoftTargetNameplateFriend';
			type = Bool(false);
			name = '显示软友善目标姓名板';
			desc = '始终显示软友善目标的姓名板。';
		};
		{	cvar = 'SoftTargetIconEnemy';
			type = Bool(false);
			name = '显示敌对目标图标';
			desc = '在当前软敌对目标上方显示图标。';
		};
		{	cvar = 'SoftTargetIconFriend';
			type = Bool(false);
			name = '显示友善目标图标';
			desc = '在当前软友善目标上方显示图标。';
		};
		{	cvar = 'SoftTargetTooltipEnemy';
			type = Bool(false);
			name = '显示敌对目标提示';
			desc = '显示软敌对目标的提示。';
		};
		{	cvar = 'SoftTargetTooltipFriend';
			type = Bool(false);
			name = '显示友善目标提示';
			desc = '显示软友善目标的提示';
		};
	};
	--------------------------------------------------------------------------------------------------------
	Tooltips = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'SoftTargetTooltipDurationMs';
			type = Number(2000, 250, true);
			name = '自动提示持续时间';
			desc = '自动获取的目标显示提示的持续时间，单位为毫秒。';
		};
		{	cvar = 'SoftTargetTooltipLocked';
			type = Bool(false);
			name = '锁定自动提示';
			desc = '只要自动获取的目标存在，就始终显示其提示。';
		};
	};
	--------------------------------------------------------------------------------------------------------
	Touchpad = {
	--------------------------------------------------------------------------------------------------------
		{	cvar = 'GamePadTouchCursorEnable';
			type = Bool(false);
			name = '启用触摸板光标';
			desc = '允许使用触摸板控制光标移动。';
		};
		{	cvar = 'GamePadTouchCursorMoveThreshold';
			type = Number(0.042, 0.002, true);
			name = '光标移动阈值';
			desc = '在触摸板移动光标前进行更改。';
			note = '更大的值以便于更容易地点击。';
		};
		{	cvar = 'GamePadTouchCursorAccel';
			type = Number(1.0, 0.25, true);
			name = '光标加速';
			desc = '为触摸板控制提供光标加速功能。';
		};
		{	cvar = 'GamePadTouchCursorSpeed';
			type = Number(1.0, 0.25, true);
			name = '光标速度';
			desc = '用于触摸板控制的光标速度。';
		};
		{	cvar = 'GamePadTouchTapButtons';
			type = Bool(false);
			name = '轻触按键';
			desc = '启用触控点击功能，按下按键。';
			note = '启用后，轻点触摸板会像按下按键一样。';
		};
		{	cvar = 'GamePadTouchTapMaxMs';
			type = Number(200, 50, true);
			name = '触摸点击最长时间';
			desc = '触摸点击的最长时间，单位为毫秒。';
		};
		{	cvar = 'GamePadTouchTapOnlyClick';
			type = Bool(false);
			name = '尽可轻触点击';
			desc = '仅使用轻触进行光标点击，不要使用按压操作。';
			note = '如果禁用，按下触摸板也会起到点击光标的效果。';
		};
		{	cvar = 'GamePadTouchTapRightClick';
			type = Bool(false);
			name = '轻触点击右键';
			desc = '轻触点击时进行光标右键操作，而不是左键。';
		};
	};
}, Console))

function Console:GetMetadata(key)
	for set, cvars in pairs(self) do
		for i, data in ipairs(cvars) do
			if (data.cvar == key) then
				return data;
			end
		end
	end
end

function Console:GetEmulationForButton(button)
	if (button == 'none') then return end
	for i, data in ipairs(self.Emulation) do
		if (GetCVar(data.cvar) == button) then
			return data;
		end
	end
end

--[[ unhandled:
	
	GamePadCursorCentering = "When using GamePad, center the cursor",
	GamePadCursorOnLogin = "Enable GamePad cursor control on login and character screens",
	GamePadCursorAutoEnable = "",

	GamePadCursorCenteredEmulation = "When cursor is centered for GamePad movement, also emulate mouse clicks",
	GamePadTankTurnSpeed = "If non-zero, character turns like a tank from GamePad movement",
	GamePadForceXInput = "Force game to use XInput, rather than a newer, more advanced api",
	GamePadSingleActiveID = "ID of single GamePad device to use. 0 = Use all devices' combined input",
	GamePadAbbreviatedBindingReverse = "Display main binding button first so it's visible even if truncated on action bar",
	GamePadListDevices = "List all connected GamePad devices in the console",
]]--