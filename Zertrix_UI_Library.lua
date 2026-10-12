-- Zertrix UI Library v1.0 | presentation only, no game features
-- Usage: local UI = loadstring(game:HttpGet(URL))()
--        local win = UI.new({tabs={...}, settings=S, onTab=function(name) ... end})
local Library = {}
function Library.new(options)
 options=options or {}
 local S=options.settings or {}
 local connections={}
local C={bg=Color3.fromRGB(17,18,26),panel=Color3.fromRGB(25,27,39),button=Color3.fromRGB(38,41,58),accent=Color3.fromRGB(146,105,255),text=Color3.fromRGB(236,235,246),muted=Color3.fromRGB(155,157,178)}

local function link(sig,fn) local c=sig:Connect(fn); connections[#connections+1]=c; return c end
local function corner(o,n) local c=Instance.new('UICorner'); c.CornerRadius=UDim.new(0,n); c.Parent=o end
local function create(class,parent,props)
 local o=Instance.new(class)
 for k,v in pairs(props or {}) do o[k]=v end
 o.Parent=parent
 return o
end
local gui=create('ScreenGui',nil,{Name='ZertrixHub_CoreGui',ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999990})
local coreGui=game:GetService('CoreGui')
local ok,err=pcall(function() gui.Parent=coreGui end)
if not ok or gui.Parent~=coreGui then
 gui:Destroy()
 error('[Zertrix Hub] CoreGui unavailable: '..tostring(err))
end
local overlay=create('Folder',gui,{Name='ESP_Objects'})
local main=create('Frame',gui,{Size=UDim2.fromOffset(800,540),Position=UDim2.new(.5,-400,.5,-270),BackgroundColor3=C.bg,BorderSizePixel=0,Active=true,Draggable=true})
corner(main,13)
create('UIStroke',main,{Color=Color3.fromRGB(75,64,107),Thickness=1})
local top=create('Frame',main,{Size=UDim2.new(1,0,0,59),BackgroundTransparency=1})
create('TextLabel',top,{Text=options.title or 'ZERTRIX  HUB',Size=UDim2.fromOffset(230,42),Position=UDim2.fromOffset(22,8),Font=Enum.Font.GothamBold,TextSize=22,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=C.accent,BackgroundTransparency=1})
create('TextLabel',top,{Text=options.subtitle or 'CLIENT  •  UI LIBRARY',Size=UDim2.fromOffset(180,36),Position=UDim2.fromOffset(241,12),Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=C.muted,BackgroundTransparency=1})
local close=create('TextButton',top,{Text='×',Position=UDim2.new(1,-50,0,11),Size=UDim2.fromOffset(33,32),BackgroundColor3=C.button,TextColor3=C.text,Font=Enum.Font.GothamBold,TextSize=23,BorderSizePixel=0}); corner(close,7)
create('Frame',main,{Position=UDim2.fromOffset(16,58),Size=UDim2.new(1,-32,0,1),BorderSizePixel=0,BackgroundColor3=Color3.fromRGB(51,52,70)})
local content=create('Frame',main,{Position=UDim2.fromOffset(170,73),Size=UDim2.new(1,-187,1,-90),BackgroundColor3=C.panel,BorderSizePixel=0}); corner(content,10)
local scroll=create('ScrollingFrame',content,{Size=UDim2.new(1,-12,1,-12),Position=UDim2.fromOffset(6,6),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.accent,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
create('UIPadding',scroll,{PaddingTop=UDim.new(0,9),PaddingBottom=UDim.new(0,12),PaddingLeft=UDim.new(0,11),PaddingRight=UDim.new(0,12)})
create('UIListLayout',scroll,{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
local sidebar=create('Frame',main,{Position=UDim2.fromOffset(17,73),Size=UDim2.new(0,137,1,-90),BackgroundColor3=C.panel,BorderSizePixel=0}); corner(sidebar,10)
create('UIPadding',sidebar,{PaddingTop=UDim.new(0,12),PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9)})
create('UIListLayout',sidebar,{Padding=UDim.new(0,9),SortOrder=Enum.SortOrder.LayoutOrder})
local tabs=options.tabs or {'Movement','Player ESP','Vehicle','Visuals','Ammo Info','Settings'}
local selected=tabs[1]
local tabButtons={}
local function tabButton(text)
 local b=create('TextButton',sidebar,{Size=UDim2.new(1,0,0,43),Text=text,BackgroundColor3=C.button,TextColor3=C.text,TextSize=13,Font=Enum.Font.GothamSemibold,BorderSizePixel=0}); corner(b,8)
 tabButtons[text]=b
 return b
end
for _,name in ipairs(tabs) do tabButton(name) end
local function clear() for _,o in ipairs(scroll:GetChildren()) do if o:IsA('GuiObject') then o:Destroy() end end end
local function header(text)
 create('TextLabel',scroll,{Size=UDim2.new(1,-10,0,31),BackgroundTransparency=1,Text=text,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=15})
end
local function description(text)
 create('TextLabel',scroll,{Size=UDim2.new(1,-10,0,34),BackgroundTransparency=1,TextWrapped=true,Text=text,TextColor3=C.muted,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12})
end
local function row(label,value,onClick)
 local b=create('TextButton',scroll,{Size=UDim2.new(1,-10,0,38),BackgroundColor3=C.button,TextColor3=C.text,TextSize=12,Font=Enum.Font.GothamMedium,TextXAlignment=Enum.TextXAlignment.Left,Text='   '..label..'     '..value,BorderSizePixel=0}); corner(b,7)
 b.MouseButton1Click:Connect(onClick)
 return b
end
local function toggle(label,key)
 local b
 local function paint() b.Text='   '..label..'      ['..(S[key] and 'ON' or 'OFF')..']'; b.TextColor3=S[key] and Color3.fromRGB(201,179,255) or C.text end
 b=row(label,'',function() S[key]=not S[key]; paint() end); paint()
end
local function cycle(label,key,options)
 local b
 local function paint() b.Text='   '..label..'      ‹ '..tostring(S[key])..' ›' end
 b=row(label,'',function() local i=table.find(options,S[key]) or 1; S[key]=options[i%#options+1]; paint() end); paint()
end
local function number(label,key,options,suffix)
 local b
 local function paint() b.Text='   '..label..'      ‹ '..tostring(S[key])..(suffix or '')..' ›' end
 b=row(label,'',function() local i=table.find(options,S[key]) or 1; S[key]=options[i%#options+1]; paint() end); paint()
end

 local api={gui=gui,main=main,top=top,close=close,overlay=overlay,colors=C,create=create,corner=corner,link=link,
  header=header,description=description,row=row,toggle=toggle,cycle=cycle,number=number}
 function api.getSelected() return selected end
 function api.render()
  clear()
  for name,b in pairs(tabButtons) do b.BackgroundColor3=name==selected and Color3.fromRGB(87,64,142) or C.button end
  if options.onTab then options.onTab(selected,api) end
 end
 function api.select(name) if tabButtons[name] then selected=name; api.render() end end
 function api.destroy()
  for _,connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
  gui:Destroy()
 end
 for name,b in pairs(tabButtons) do link(b.MouseButton1Click,function() api.select(name) end) end
 return api
end
return Library
