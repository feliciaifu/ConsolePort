local _, env, db = ...; db = env.db;
---------------------------------------------------------------
local Editor = CreateFromMixins(ScrollingEditBoxMixin);
---------------------------------------------------------------

local function Format(text) return (text or ''):gsub('\t', '  ') end;
local function Prune(text, cmp)  return text ~= cmp and text or nil end;

function Editor:SetData(current, default)
	self:SetDefaultTextEnabled(not current)
	self:SetDefaultText(Format(default))
	self:SetText(Format(current))
end

function Editor:GetData()
	return Prune(self:GetInputText(), ''), self:GetEditBox().defaultText;
end

---------------------------------------------------------------
local Advanced = Mixin({
---------------------------------------------------------------
	EditorControls = {
		{
			tooltipTitle = RESET;
			icon         = [[Interface\RAIDFRAME\ReadyCheck-NotReady]];
			iconSize     = 16;
			onClickHandler = function(self)
				local _, default = self.data.get()
				self.data.set(default)
				self.data.editor:SetData(self.data.get())
			end;
		};
		{
			tooltipTitle = SAVE;
			icon         = [[Interface\RAIDFRAME\ReadyCheck-Ready]];
			iconSize     = 16;
			onClickHandler = function(self)
				local text = self.data.editor:GetData()
				if text then
					self.data.set(text)
				end
			end;
		};
	};
	Headers = {
		Condition = {
			name   = '页面条件';
			height = 50;
			get    = function() return db('actionPageCondition'), db.Pager:GetDefaultPageCondition() end;
			set    = function(value) db('Settings/actionPageCondition', Prune(value, db.Pager:GetDefaultPageCondition())) end;
			text   = env.MakeMacroDriverDesc(
				'动作条页面的全局条件。接受宏条件与页面编号的配对，或者单一的页面编号。',
				'将生成的页面发送至响应处理器进行后续处理。',
				'actionbar', 'page', true, env.Const.PageDescription, {
					n = '转发给响应处理器的页面编号。';
					any = '一个简单的值（数字、字符串、布尔值），用于转发给响应处理器，在该处计算实际的动作条页面编号。';
				}, WHITE_FONT_COLOR);
		};
		Response = {
			name   = '页面处理';
			height = 150;
			get    = function() return db('actionPageResponse'), db.Pager:GetDefaultPageResponse() end;
			set    = function(value) db('Settings/actionPageResponse', Prune(value, db.Pager:GetDefaultPageResponse())) end;
			text   = env.MakeMacroDriverDesc(
				'在Lua中对动作条页面条件进行全局后续处理。这是所有操作栏和系统共享的。仅限受限环境API使用。',
				'将生成的页面设置到动作标题中，进而更新工作按键。',
				nil, nil, nil, {
					newstate = '来自条件处理器的结果值。';
				}, {
					newstate = '设置在动作标题中的预期页面编号。';
				}, WHITE_FONT_COLOR);
		};
		Visibility = {
			name   = '可见性条件';
			height = 30;
			get    = function() return env('Layout/visibility'), env.Const.ManagerVisibility end;
			set    = function(value) env('Layout/visibility', value) end;
			text   = env.MakeMacroDriverDesc(
				'全局动作条可见性条件。这是所有动作条共享的。',
				'根据条件结果设置所有动作条组件的可见性。',
				'actionbar', 'visibility', true, {
					['vehicleui']   = '载具界面激活。';
					['overridebar'] = '一个覆盖栏被激活，当特定场景没有载具界面时使用。';
					['petbattle']   = '玩家正在进行宠物战斗。';
				}, {
					['show'] = '显示动作条。';
					['hide'] = '隐藏动作条。';
				}, WHITE_FONT_COLOR);
		};
	};
}, env.SharedConfig.HeaderOwner);

function Advanced:OnLoad(inputHandler, headerPool)
	local sharedConfig = env.SharedConfig;
	sharedConfig.HeaderOwner.OnLoad(self, sharedConfig.Header)

	self.owner = inputHandler;
	self.headerPool = headerPool;
	self.cmdButtonPool = sharedConfig.CreateSquareButtonPool(self, sharedConfig.CmdButton)

	CPAPI.Start(self)
end

function Advanced:OnShow()
	local layoutIndex = CreateCounter()
	self.headerPool:ReleaseAll()
	self.cmdButtonPool:ReleaseAll()
	self:MarkDirty()

	local function DrawEditor(info)
		local header = self:CreateHeader(info.name)
		header.layoutIndex = layoutIndex()
		header:SetTooltipInfo(info.name, info.text)

		local editor = info.editor or Mixin(env.SharedConfig.CreateEditBox(self), Editor);
		editor:SetSize(header:GetWidth() - 8, info.height)
		editor.layoutIndex = layoutIndex()
		editor.leftPadding, editor.topPadding = 8, 8;
		editor:SetData(info.get())
		info.editor = editor;

		local left, right = math.huge, 0;
		for i, control in ipairs(self.EditorControls) do
			local button = self.cmdButtonPool:Acquire()
			button:SetPoint('RIGHT', header, 'RIGHT', -(32 * (i - 1)), 0)
			button:Setup(control, info)
			button:SetFrameLevel(header:GetFrameLevel() + 1)
			button:Show()
			left, right = math.min(left, button:GetLeft()), math.max(right, button:GetRight())
		end
		header:SetIndentation(-(right - left))
	end

	DrawEditor(self.Headers.Visibility)
	DrawEditor(self.Headers.Condition)
	DrawEditor(self.Headers.Response)
end

env.SharedConfig.Advanced = Advanced;