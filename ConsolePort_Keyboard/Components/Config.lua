local Config, _, env, L = {}, ...;
---------------------------------------------------------------
local LAYOUT_SET_WIDTH, LAYOUT_ROW_WIDTH, NUM_FIELDS = 700, 600, 8;
local TABBUTTON_WIDTH, CONTAINER_WIDTH, FIXED_OFFSET = 284, 700, 8;
local Layout, LayoutSet, LayoutRow, LayoutField = {}, CreateFromMixins(CPFocusPoolMixin), {}, {};

---------------------------------------------------------------
-- Set
---------------------------------------------------------------
function LayoutSet:OnLoad()
	CPFocusPoolMixin.OnLoad(self)
	self:SetWidth(LAYOUT_SET_WIDTH - FIXED_OFFSET * 2)
	self:SetDrawOutline(true)
	self:CreateFramePool('IndexButton', 'ConsolePortKeyboardLayoutRow', LayoutRow)

	self.Remove:AddTooltipLine(L'移除字环设置')
	self.Remove:AddTooltipLine(L(
		'每个环状菜单代表键盘布局中的一个较小的字环，用左摇杆选择，用右摇杆导航。'..
		'点击此处移除整个字环的设置。'), HIGHLIGHT_FONT_COLOR)

	self.Add:AddTooltipLine(L'向字环中添加新行')
	self.Add:AddTooltipLine(L(
		'向字环中添加新的可选行。' ..
		'字环会自动调整，以适应新的行，均匀地间隔分布。'), HIGHLIGHT_FONT_COLOR)
end

function LayoutSet:SetData(data)
	self:ReleaseAll()
	local prev;
	for rowID, rowData in ipairs(data) do
		local widget, newObj = self:Acquire(rowID)
		if newObj then
			widget:OnLoad()
		end
		widget:Show()
		widget:SetID(rowID)
		widget:SetData(rowData)
		widget:SetPoint('TOP',
			prev or self,
			prev and 'BOTTOM' or 'TOP',
			0, prev and -4 or -8)
		prev = widget;
	end
	local newHeight = (#data * 44) + 16;
	self:SetHeight(Clamp(newHeight, 60, newHeight))
end

function LayoutSet:UpdateCell(...)
	self:GetParent():GetParent():UpdateCell(self:GetID(), ...)
end

function LayoutSet:MoveData(...)
	self:GetParent():GetParent():MoveData(self:GetID(), ...)
end

function LayoutSet:RemoveData(...)
	self:GetParent():GetParent():RemoveData(self:GetID(), ...)
end

function LayoutSet:AddData(...)
	self:GetParent():GetParent():AddData(self:GetID(), ...)
end

---------------------------------------------------------------
-- Row
---------------------------------------------------------------
function LayoutRow:OnLoad()
	self.Remove:AddTooltipLine(L'移除行')
	self.Remove:AddTooltipLine(L'从字环中移除该行。', HIGHLIGHT_FONT_COLOR)
	self:SetSize(LAYOUT_ROW_WIDTH, 40)
	self:SetDrawOutline(true)
	local prev;
	for i=1, NUM_FIELDS do
		local field = CreateFrame('EditBox', nil, self, 'ConsolePortKeyboardLayoutField')
		Mixin(field, LayoutField)
		CPAPI.Start(field)
		field:SetID(i)
		field:SetPoint('LEFT',
			prev or self,
			prev and 'RIGHT' or 'LEFT',
			prev and 8 or 32, 0)
		self[i], prev = field, field;
	end
end

function LayoutRow:SetData(rowData)
	for i=1, NUM_FIELDS do
		self[i]:SetText(rowData[i] or '')
	end
end

function LayoutRow:UpdateCell(...)
	self:GetParent():UpdateCell(self:GetID(), ...)
end

function LayoutRow:MoveData(...)
	self:GetParent():MoveData(self:GetID(), ...)
end

function LayoutRow:RemoveData(...)
	self:GetParent():RemoveData(self:GetID(), ...)
end

---------------------------------------------------------------
-- Field
---------------------------------------------------------------
local function GetRequiredStateFromID(id)
	local states, id = {}, id - 1;
	if bit.band(0x1, id) ~= 0 then tinsert(states, 'Shift') end
	if bit.band(0x2, id) ~= 0 then tinsert(states, 'Ctrl' ) end
	if bit.band(0x4, id) ~= 0 then tinsert(states, 'Alt'  ) end
	return table.concat(states, '+')
end

function LayoutField:OnEnter()
	local text = self:GetText()
	GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')
	GameTooltip:SetText(text:len() > 0 and text or L'< 空 >')
	local stateRequired = GetRequiredStateFromID(self:GetID())
	if stateRequired:len() > 0 then
		GameTooltip:AddLine(L('按住 %s 可访问。', stateRequired), 1, 1, 1)
		GameTooltip:Show()
	end
end

function LayoutField:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

function LayoutField:OnEnterPressed()
	self:ClearFocus()
end

function LayoutField:OnEscapePressed()
	self:SetText(self.cachedText)
	self:ClearFocus()
end

function LayoutField:OnEditFocusGained()
	self.cachedText = self:GetText()
end

function LayoutField:OnEditFocusLost()
	self:GetParent():UpdateCell(self:GetID(), self:GetText())
end

---------------------------------------------------------------
-- Layout display handling
---------------------------------------------------------------
function Layout:OnShow()
	local layout, prev = ConsolePort_KeyboardLayout, self.Child.Header;
	self.layoutSets:ReleaseAll()

	for setID, setData in ipairs(layout) do
		local widget, newObj = self.layoutSets:Acquire()
		if newObj then
			Mixin(widget, LayoutSet)
			widget:OnLoad()
		end
		widget:Show()
		widget:SetID(setID)
		widget:SetData(setData)
		widget:SetPoint('TOP', prev, 'BOTTOM', 0, 0)
		prev = widget;
	end

	local addSetButton = self.Child.AddSetButton;
	addSetButton:ClearAllPoints()
	addSetButton:SetPoint('TOP', prev, 'BOTTOM', 0, -8)

	self.Child:SetHeight(nil)
end

function Layout:OnLoad()
	self.layoutSets = CreateFramePool('IndexButton', self.Child, 'ConsolePortKeyboardLayoutSet')

	local header = self.Child.Header;
	header:SetText(L'布局')
	header:SetPoint('TOP', 0, -8)

	Mixin(self.Child, env.config.ScaleToContentMixin)
	self.Child:SetAllPoints()
	self.Child:SetMeasurementOrigin(self, self.Child, CONTAINER_WIDTH, 40)
end

function Layout:OnLayoutChanged()
	ConsolePortKeyboard:OnLayoutChanged()
	self:OnShow()
end

---------------------------------------------------------------
-- Layout data handling
---------------------------------------------------------------
function Layout:UpdateCell(...)
	local set, n = ConsolePort_KeyboardLayout, select('#', ...);
	local newText = select(n, ...);
	for i=1, (n - 2) do
		local key = select(i, ...);
		if not set[key] then
			set[key] = {};
		end
		set = set[key];
	end
	set[select(n - 1, ...)] = newText:len() > 0 and newText or nil;
	self:OnLayoutChanged()
end

function Layout:MoveData(...)
	local set, n = ConsolePort_KeyboardLayout, select('#', ...);
	local oldIndex, delta = select(n - 1, ...);
	for i=1, (n - 2) do
		set = set[select(i, ...)];
	end
	local data = tremove(set, oldIndex)
	tinsert(set, Clamp(oldIndex + delta, 1, #set + 1), data)
	self:OnLayoutChanged()
end

function Layout:RemoveData(...)
	local set, n = ConsolePort_KeyboardLayout, select('#', ...);
	for i=1, (n - 1) do
		set = set[select(i, ...)];
	end
	tremove(set, select(n, ...))
	self:OnLayoutChanged()
end

function Layout:AddData(...)
	local set, n = ConsolePort_KeyboardLayout, select('#', ...);
	for i=1, (n - 1) do
		set = set[select(i, ...)];
	end
	tinsert(set, select(n, ...))
	self:OnLayoutChanged()
end

---------------------------------------------------------------
-- Tabs
---------------------------------------------------------------
local Tab, Tabs = {}, CreateFromMixins(CPFocusPoolMixin)

function Tabs:OnLoad()
	CPFocusPoolMixin.OnLoad(self)
	env.config.OpaqueMixin.OnLoad(self)
	self:CreateFramePool('IndexButton',
		'CPIndexButtonBindingHeaderTemplate', Tab, nil, self.Child)
	Mixin(self.Child, env.config.ScaleToContentMixin)
	self.Child:SetAllPoints()
	self.Child:SetMeasurementOrigin(self, self.Child, TABBUTTON_WIDTH, FIXED_OFFSET)
end

function Tabs:OnShow()
	self.Child:SetHeight(nil)
end

---------------------------------------------------------------
-- Container
---------------------------------------------------------------
function Config:OnFirstShow()
	local tabs, layoutEditor;
	tabs = self:CreateScrollableColumn('Tabs', {
		_Mixin = Tabs;
		_Width = TABBUTTON_WIDTH;
		_Setup = {'CPSmoothScrollTemplate', 'BackdropTemplate'};
		_Backdrop = CPAPI.Backdrops.Opaque;
		_Points = {
			{'TOPLEFT', 0, 1};
			{'BOTTOMLEFT', 0, -1};
		};
		{
			Child = {
				{
					LayoutBlock = {
						_Type  = 'Frame';
						_Setup = 'BackdropTemplate';
						_Size  = {TABBUTTON_WIDTH - FIXED_OFFSET * 2, 300};
						_Backdrop = CPAPI.Backdrops.Frame;
						_Point = {'TOP', 0, -16};
						_OnLoad = function(self)
							env.config.OpaqueMixin.OnLoad(self)
						end;
						{
							Header = {
								_Type  = 'FontString';
								_Setup = {'ARTWORK', 'GameFontNormal'};
								_Text  = '布局';
								_Point = {'TOP', 0, -16}; 
							};
							HelpButton = {
								_Type = 'Button';
								_Size = {50, 50};
								_SetNormalTexture = 'Interface\\common\\help-i';
								_Point = {'TOPLEFT', 4, -16};
							};
							HelpText = {
								_Type = 'FontString';
								_Setup = {'ARTWORK', 'GameTooltipText'};
								_Text = L(
									'游戏手柄键盘由嵌套的环状菜单（简称字环）组成。' ..
									'在右侧，你可以根据自己的需要和个人语言定制这些字环。\n\n' ..
									'使用左摇杆指向并选择一套字环，' ..
									'然后使用右摇杆选择字符或短语。\n\n' ..
									'按住指定的控制键可将键盘切换到不同的列。');
								_Points = {
									{'TOPLEFT', '$parent.HelpButton', 'TOPRIGHT', -4, -16};
									{'BOTTOMRIGHT', -24, 64};
								};
							};
							ResetButton = {
								_Type  = 'IndexButton';
								_Setup = 'CPIndexButtonBindingHeaderTemplate';
								_Width = TABBUTTON_WIDTH - FIXED_OFFSET * 6;
								_Point = {'BOTTOM', 0, 16};
								_Text  = L'重置键盘布局为默认';
								_OnClick = function(self)
									CPAPI.Popup('ConsolePort_Keyboard_ResetLayout', {
										text = L'你确定要重新设置键盘布局吗？';
										button1 = OKAY;
										button2 = CANCEL;
										timeout = 0;
										whileDead = 1;
										showAlert = 1;
										OnHide = function()
											self:Uncheck()
										end;
										OnAccept = function()
											ConsolePort_KeyboardLayout = CopyTable(env.DefaultLayout)
											layoutEditor:OnLayoutChanged()
										end;
									})
								end;
							};
						}
					};
					DictBlock = {
						_Type  = 'Frame';
						_Setup = 'BackdropTemplate';
						_Size  = {TABBUTTON_WIDTH - FIXED_OFFSET * 2, 400};
						_Backdrop = CPAPI.Backdrops.Frame;
						_Point = {'TOP', '$parent.LayoutBlock', 'BOTTOM', 0, 0};
						_OnLoad = function(self)
							env.config.OpaqueMixin.OnLoad(self)
						end;						
						_OnShow = function(self)
							local count = 0;
							for k, v in pairs(ConsolePort_KeyboardDictionary) do
								count = count + 1;
							end
							self.HelpText:SetText(L(self.HelpText.text:format(count)))
						end;
						{
							Header = {
								_Type  = 'FontString';
								_Setup = {'ARTWORK', 'GameFontNormal'};
								_Text  = '词典';
								_Point = {'TOP', 0, -16}; 
							};
							HelpButton = {
								_Type = 'Button';
								_Size = {50, 50};
								_SetNormalTexture = 'Interface\\common\\help-i';
								_Point = {'TOPLEFT', 4, -16};
							};
							HelpText = {
								_Type = 'FontString';
								_Setup = {'ARTWORK', 'GameTooltipText'};
								text =
									'你的字典当前包含 |CFF00FF00%d|r 个单词。\n\n' ..
									'字典用于根据你当前的输入推荐可能的单词，' ..
									'这样你就可以省略大量的手动输入过程。\n\n' ..
									'随着时间的推移，词典会自动改进， ' ..
									'因为它会学习你的打字行为。\n\n' ..
									'最初的词典以游戏中的短语为基础。\n\n' ..
									'如果你希望得到完全基于你本土语言的建议，请擦除你的词典，' ..
									'重新创建本土语言的词典。';
								_Points = {
									{'TOPLEFT', '$parent.HelpButton', 'TOPRIGHT', -4, -16};
									{'BOTTOMRIGHT', -24, 110};
								};
							};
							WipeButton = {
								_Type  = 'IndexButton';
								_Setup = 'CPIndexButtonBindingHeaderTemplate';
								_Width = TABBUTTON_WIDTH - FIXED_OFFSET * 6;
								_Point = {'BOTTOM', 0, 16};
								_Text  = L'擦除字典';
								_OnClick = function(self)
									CPAPI.Popup('ConsolePort_Keyboard_WipeDictionary', {
										text = L'你确定要擦除键盘字典吗？';
										button1 = OKAY;
										button2 = CANCEL;
										timeout = 0;
										whileDead = 1;
										showAlert = 1;
										OnHide = function()
											self:Uncheck()
										end;
										OnAccept = function()
											ConsolePort_KeyboardDictionary = wipe(ConsolePort_KeyboardDictionary);
											self:GetParent():Hide()
											self:GetParent():Show()
										end;
									})
								end;
							};
							ResetButton = {
								_Type  = 'IndexButton';
								_Setup = 'CPIndexButtonBindingHeaderTemplate';
								_Width = TABBUTTON_WIDTH - FIXED_OFFSET * 6;
								_Point = {'BOTTOM', '$parent.WipeButton', 'TOP', 0, 8};
								_Text  = L'重置词典';
								_OnClick = function(self)
									CPAPI.Popup('ConsolePort_Keyboard_ResetDictionary', {
										text = L'你确定要重置键盘字典吗？';
										button1 = OKAY;
										button2 = CANCEL;
										timeout = 0;
										whileDead = 1;
										showAlert = 1;
										OnHide = function()
											self:Uncheck()
										end;
										OnAccept = function()
											ConsolePort_KeyboardDictionary = env.DictHandler:Generate();
											env.Dictionary = ConsolePort_KeyboardDictionary;
											self:GetParent():Hide()
											self:GetParent():Show()
										end;
									})
								end;
							};
						}
					};
				};
			};
		};
	})
	layoutEditor = self:CreateScrollableColumn('Layout', {
		_Mixin = Layout;
		_Width = CONTAINER_WIDTH;
		_Setup = {'CPSmoothScrollTemplate', 'BackdropTemplate'};
		_Backdrop = CPAPI.Backdrops.Opaque;
		_Points = {
			{'TOPLEFT', '$parent.Tabs', 'TOPRIGHT', 0, 0};
			{'BOTTOMLEFT', '$parent.Tabs', 'BOTTOMRIGHT', 0, 0};
		};
		{
			Child = {
				{
					Header = {
						_Type  = 'Frame';
						_Setup = 'CPConfigHeaderTemplate';
					};
					AddSetButton = {
						_Type  = 'IndexButton';
						_Setup = 'CPIndexButtonBindingHeaderTemplate';
						_Width = CONTAINER_WIDTH - FIXED_OFFSET * 2;
						_Text  = ('%s %s'):format(
							'|TInterface\\PaperDollInfoFrame\\Character-Plus:0|t',
							'新增字环');
						_OnClick = function(self)
							self:Uncheck()
							self:GetParent():GetParent():AddData({{}})
						end;
					};
				};
			};
		};
	})
	env.config.OpaqueMixin.OnLoad(layoutEditor)
end

function Config:OnShow()
	env:ToggleObserver(false)
	ConsolePortKeyboard:OnFocusChanged(nil)
end

function Config:OnHide()
	if env.config.db('keyboardEnable') then
		env:ToggleObserver(true)
	end
end

local function OnConfigLoaded(localEnv, config, env)
	localEnv.config, localEnv.panel, L = env, config, env.L;
	env.Keyboard = config:CreatePanel({
		name = L'键盘';
		mixin = Config;
		scaleToParent = true;
		forbidRecursiveScale = true;
	})
	env.db:RegisterCallback('Settings/keyboardEnable', function(localEnv, enabled)
		localEnv:ToggleObserver(enabled)
	end, localEnv)
end

if CPAPI.IsAddOnLoaded('ConsolePort_Config') then
	OnConfigLoaded(env, ConsolePortConfig, ConsolePortConfig:GetEnvironment())
else
	ConsolePort:DB():RegisterCallback('OnConfigLoaded', OnConfigLoaded, env)
end