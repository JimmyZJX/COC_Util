
local ts = require "ts"

require "TSLib"

local function starts_with(str, start)
	return str:sub(1, #start) == start
end

function tableSize(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function gaussian(mean, variance)
    return  math.sqrt(-2 * variance * math.log(math.random())) *
            math.cos(2 * math.pi * math.random()) + mean
end

function simpleGaussian(min, max)
	local r = gaussian((min + max) / 2, math.random() * (max - min));
	return math.min(max, math.max(min, r));
end

init(2);
vibrator();

local _base_x0, _base_y0, _base_x1, _base_y1 = 280, 100, 1800, 1280;
function findTHPat(pat)
	local x, y = findMultiColorInRegionFuzzy(pat[1], pat[2], 95, _base_x0, _base_y0, _base_x1, _base_y1, { main = 0x101010, list = 0x202020 });
	if x >= 0 and y >= 0 then
		if pat[3] then x = x + pat[3] end
		if pat[4] then y = y + pat[4] end
	end
	return x, y;
end
TH_pat7 = {0xd8b6a8, "-5|-13|0xffac40,5|17|0xffb446,-20|3|0xa97546,17|2|0xe5c2af", 0, 54};
TH_pat8 = {0xe0c4b8, "-23|22|0xeeccb8,-7|31|0xaf7647,8|28|0xa46e41,24|24|0xb49c95", 0, 72};
TH_pat9 = {0x393b42, "-3|-3|0xb99b83,-42|16|0x2c3139,-34|26|0x594d44,1|24|0x3c3f48,34|14|0xd1b4a1,-12|42|0x232220", 0, 66};
TH_pat10 = {0x9d3b33, "14|-16|0x8b786e,46|-6|0x816d6f,40|5|0xffe760,20|18|0x983a34,20|-4|0xffd760", 30, 50};
TH_pat11 = {0xff843a, "0|6|0xffc143,-1|10|0xff9330,-1|26|0xcf3000,25|-3|0xf9f4f2,-34|6|0xc13e00", 0, 52};
TH_pat12 = {0xfbdb6d, "9|-6|0xe1b43e,3|8|0x785410,7|19|0x111418,-36|-31|0x408ce0", -15, 35};


function findAllPat(pat)
	local found = findMultiColorInRegionFuzzyExt(pat[1], pat[2], 90, _base_x0, _base_y0, _base_x1, _base_y1, { main = 0x101010, list = 0x202020 });
	local result = {};
	
	for _, p in ipairs(found) do
		local minDist = 1000;
		for _, pr in ipairs(result) do
			local d = math.abs(p.x - pr.x) + math.abs(p.y - pr.y);
			minDist = math.min(minDist, d);
		end
		if minDist > 10 then
			table.insert(result, p);
		end
	end
	
	return result;
end
local DED_pat67 = {0x9b8686, "1|11|0xa2724b,8|17|0xedbe57,14|13|0xdfa03f,14|20|0x96837f,31|38|0xe6b858", 0, 0}; -- ,24|6|0xfef777,6|12|0x6f5722
local Elixir_pat13_60 = {0xb960d3, "3|-50|0x2a1d10,4|-46|0x614224,12|-25|0xe8b450,13|-4|0xfff878,12|12|0x805820,18|6|0x865b20,18|14|0x825620,7|14|0xfbb84f"};
local Elixir_pat13_80 = {0x985ab0, "3|-50|0x2a1d10,4|-46|0x614224,12|-25|0xe8b450,13|-4|0xfff878,12|12|0x805820,18|6|0x865b20,18|14|0x825620,7|14|0xfbb84f"};
local Elixir_pat12_80 = {0xb659cc, "0|-48|0x2b1e12,0|-43|0x5c4024,-6|14|0x6d5828,10|14|0x9e6c28,-5|-3|0xf8d060,9|-3|0xfff478"};
local Elixir_pat12_60 = {0xffacff, "0|-48|0x2b1e12,0|-43|0x5c4024,-6|14|0x6d5828,10|14|0x9e6c28,-5|-3|0xf8d060,9|-3|0xfff478"};

function hasAny60Elixir()
	local has60 = false;
	fwShowWnd("wndElixirResult", 0, 0, 2047, 1535, 0);

	for i, p in ipairs(findAllPat(Elixir_pat13_60)) do
		nLog("E13_60: " .. p.x .. ", " .. p.y);
		-- if isColor(p.x + 1, p.y - 3, 0xf6a3ff, 90) or isColor(p.x + 1, p.y - 2, 0xf6a3ff, 90) : 60+
		has60 = true;

		fwShowButton("wndElixirResult", "btnResultE1360" .. i, "E13: 60+", "FFFFFF", "FF0000", "", 12, p.x, p.y, p.x+150, p.y+30);
	end
	
	for i, p in ipairs(findAllPat(Elixir_pat13_80)) do
		nLog("E13_80: " .. p.x .. ", " .. p.y);
		has60 = true;
		fwShowButton("wndElixirResult", "btnResultE1380" .. i, "E13: 80+", "FFFFFF", "FF0000", "", 12, p.x, p.y, p.x+150, p.y+30);
	end
	
	for i, p in ipairs(findAllPat(Elixir_pat12_80)) do
		nLog("E12_80: " .. p.x .. ", " .. p.y);
		has60 = true;
		fwShowButton("wndElixirResult", "btnResultE1280" .. i, "E12: 80+", "FFFFFF", "FF0000", "", 12, p.x, p.y, p.x+150, p.y+30);
	end
	
	for i, p in ipairs(findAllPat(Elixir_pat12_60)) do
		nLog("E12_60: " .. p.x .. ", " .. p.y);
		has60 = true;
		fwShowButton("wndElixirResult", "btnResultE1260" .. i, "E12: 60+", "FFFFFF", "FF0000", "", 12, p.x, p.y, p.x+150, p.y+30);
	end

	return has60;
end

hasAny60Elixir();

function hasAny60DE()
	local has60 = false;

	local tbl_result = findAllPat(DED_pat67);

	fwShowWnd("wndDEResult", 0, 0, 2047, 1535, 0);
	for i, p in ipairs(tbl_result) do
		nLog("DE67: " .. p.x .. ", " .. p.y);
		
		local desc = "";
		if isColor(p.x - 8, p.y + 7, 0x7d7172, 80) then
			desc = "0"
		elseif isColor(p.x - 1, p.y + 8, 0x695870, 90) then
			desc = "20+"
		elseif isColor(p.x - 1, p.y + 6, 0x685169, 90) or isColor(p.x - 1, p.y + 5, 0x685169, 90) then
			desc = "40+"
		else
			desc = "60+"; has60 = true;
		end

		fwShowButton("wndDEResult", "btnResultDE" .. i, "DE67:" .. desc, "FFFFFF", "FF0000", "", 12, p.x, p.y, p.x+150, p.y+30);
	end

	return has60;
end

-- reuturns (TH_lvl, x, y)
function findTH()
	local TH_lvl, x, y;
	keepScreen(true);
	for i = 1, 1 do
		x, y = findTHPat(TH_pat12); if x >= 0 and y >= 0 then TH_lvl = 12; break; end
		x, y = findTHPat(TH_pat11); if x >= 0 and y >= 0 then TH_lvl = 11; break; end
		x, y = findTHPat(TH_pat10); if x >= 0 and y >= 0 then TH_lvl = 10; break; end
		x, y = findTHPat(TH_pat9); if x >= 0 and y >= 0 then TH_lvl = 9; break; end
		x, y = findTHPat(TH_pat8); if x >= 0 and y >= 0 then TH_lvl = 8; break; end
		x, y = findTHPat(TH_pat7); if x >= 0 and y >= 0 then TH_lvl = 7; break; end
	end
	keepScreen(false);
	return TH_lvl, x, y;
end

function L1dist(x, y)
	local cx, cy = 1005, 666;
	-- x: 200 -> 1810    y: 66 -> 1270
	local dx, dy = (1810-200) / 2, (1270-66) / 2;
	return math.abs(x - cx) / dx + math.abs(y - cy) / dy;
end

function floatTH(txt, x, y)
	fwShowWnd("wndTest", x-70, y-16, x+70, y+16, 0);
	fwShowButton("wndTest", "txtTestTH", txt, "FFFFFF", "FF0000", "", 15, 0, 0, 140, 32);
end

function showTH(TH_lvl, x, y)
	floatTH("TH" .. TH_lvl .. " " .. math.floor(L1dist(x, y) * 100), x, y);
end

function closeFloatTH()
	fwCloseWnd("wndTest");
end

--[[
while true do
	local TH_lvl, x, y = findTH();
	if TH_lvl ~= nil then
		showTH(TH_lvl, x, y);
		
		while true do
			local vid = fwGetPressedButton();
			if vid == "txtTestTH" then
				closeFloatTH();
				break;
			end
		end
	else
		dialog("TH not found", 1);
		mSleep(2000);
	end
end--]]


local COC_tab = {
	"00000081e0003f7e0003f7e0003f7e0003f7e0f03f7e0f03f7e1f03ffe1f07ffe1f07f7fff8ff7ffffff7fffffe7fffffe7fffffe3ff7ffe3ff3ffc1fe3ffc0381ff80000fc0$3$348$28$20",
	"0001f00003fe0003ff8001ffe001fff801fffe01ffff80ffffe0fffff83ffc7e0ffc1f83fc07e0fe03f83fffffffffffffffffffffffffdffffff7fffffdffffff7fffffc0007c00001f0@00$4$401$26$23",
	"0001ffdf00fff7c03ffff01ffffc0fffff03ffffc1fffff07ffffc3fffff1ff3ffc7f8fffffe3fffff0fffffc3ffffe0fffff03ffffc0fdffe03f0ff00f@10$2$368$26$19",
	"07fff803ffff81fffff8ffffff7ffffffffffffffffffffffffffffffffffc1ffff000fff8003ffe000fff8003ffe000ffff007fffffffffffffffffffffffffffffffffdffffff1fffff03ffff803fff8@00$0$524$26$25",
	"1c00001f000007ffe001ffffff7fffffdfffffffffffffffffffffffffffffffffffc00@00$1$215$26$11",
	"00ff0001ffe000fffc083fff83f7fff07fffff0fffffe1fffffc3fffbf87ffc7f1fbf87e3f7f0fc7efe1f9fdffffffbfffffe7fffffcffffff8fffffe1fffffc0fffff003fffc@000$9$429$27$21",
	"0007f8007ffffc1fffffc3fffffc3fffffe3fffffe7fffffe7fffffe7ffffff7f1f83f7e1f83f7e1f83f7e1fc3ffe1fc7ffe1fffffc1fffefc0fffefc0fffefc0fffc3c0fffc000fff80007fc0$6$448$28$22",
	"0080f801f83ff1ff8fff7ffbffeffffffdffffffbffffff7ffffffffff8fff07f0ffe0fc1ffc1f83ff83f07fffff0fffffffffffffffffffffdffffffbffffff7ff7ffe7fc7ff83e07fe00007f00000780$8$494$27$24",
	"01fe0007ffe07c7fff07f7fff07f7fff07effff07effff07effff0feffff8fefc3f8fcfc1fffcfc1fffcfc1fffcfc1fff8fc1fff8fc0fff8fc0fff0fc0fff0fc0ffe0$5$377$28$19",
	"1800001f80001bf0000f7e000fefc007fdf803ffbf01ffffe0fffffcffffdffffff3fffff87ffffc0ffffe01ffff003fff8007ffc000ffe0001ff00001f80000@0$7$290$27$19",
}
local COC_index = addTSOcrDictEx(COC_tab)

function readCOCNum(x, y)

	local _NUM_W, _NUM_H = 210, 34;
	local _NUM_MIN_W_2 = 5;
	
	local _x0, _y0, _x1, _y1 = x - 5, y - 5, x + _NUM_W + 5, y + _NUM_H + 5;
	
	-- dialog(_x0 .. ", " .. _y0 .. ", " .. _x1 .. ", " .. _y1);

	function __readCOCNum()
		local nums = {};
		for i = 0, 9 do
			local curX = _x0;
			while true do
				local imgX, imgY = findImageInRegionFuzzy("d" .. i .. ".png", 60, curX, _y0, _x1, _y1, 0, 2);
				if imgX < 0 or imgY < 0 then break end

				table.insert(nums, { x = imgX, y = imgY, d = i });
				curX = imgX + _NUM_MIN_W_2;
			end
		end
		dialog(ts.json.encode(nums));
		return 0;
	end

	function _readCOCNum()
		local ret = tsOcrText(COC_index, _x0, _y0, _x1, _y1, "DADAB2 , 5B5751", 90)
		return tonumber(ret) or 0;
	end

	keepScreen(true);
	local ret = _readCOCNum();
	keepScreen(false);
	return ret;
end

function readCOCLoot()
	local G = readCOCNum(115, 165);
	local E = readCOCNum(115, 233);
	local DE = readCOCNum(115, 302);
	return G, E, DE;
end


local SearchModes = {
	['G+E'] = {
		name = 'G+E',
		getValue = function(g,e,de) return (g + e) / 10000; end,
	},
	['DE'] = {
		name = 'DE',
		getValue = function(g,e,de) return de; end
	},
	['G'] = {
		name = 'G',
		getValue = function(g,e,de) return g / 10000; end
	},
	['E'] = {
		name = 'E',
		getValue = function(g,e,de) return e / 10000; end
	},
}

local InitDefaults = {
	{ name = 'G+E 80w', mode = SearchModes['G+E'], value = 80 },
	{ name = 'G+E 100w', mode = SearchModes['G+E'], value = 100 },
	{ name = 'G 60w', mode = SearchModes['G'], value = 60 },
	{ name = 'DE 2000', mode = SearchModes['DE'], value = 2000 },
	{ name = 'DE 4000', mode = SearchModes['DE'], value = 4000 },
};

local txtReduce = "100%";
alert404TH = false; alertDE = false; alertElixir = false;

function ProcessInitFloat()
	local MARGIN_TB = 20; local H_BTN = 60;
	
	local numDefaults = #InitDefaults;
	local height = MARGIN_TB + (MARGIN_TB + H_BTN) * (numDefaults + 2);
	
	fwShowWnd("wndInit", 350, 100, 350+380, 100+height, 0);
	fwShowTextView("wndInit","txtBg","","left","FFFFFF","54afff",10,0,0,0,380,height,0.8);
	
	local _h = MARGIN_TB;
	for i = 1, numDefaults do
		fwShowButton("wndInit", "btnDef" .. i, InitDefaults[i].name, "FFFFFF", "333399", "", 15, 20, _h, 180, _h + H_BTN);
		_h = _h + H_BTN + MARGIN_TB;
	end
	fwShowButton("wndInit", "btnSetting", "More...", "FFFFFF", "339933", "", 15, 20, _h, 180, _h + H_BTN);
	_h = _h + H_BTN + MARGIN_TB;
	fwShowButton("wndInit", "btnQuit", "Quit", "FFFFFF", "993333", "", 15, 20, _h, 180, _h + H_BTN);
	_h = _h + H_BTN + MARGIN_TB;
	
	local _h = MARGIN_TB;
	fwShowButton("wndInit", "txtReduce", txtReduce, "FFFFFF", "243f3f", "", 15, 200, _h, 360, _h + H_BTN);
	_h = _h + H_BTN + MARGIN_TB;
	fwShowButton("wndInit", "btnReduce995", "99.5%", "FFFFFF", "333399", "", 15, 200, _h, 360, _h + H_BTN);
	_h = _h + H_BTN + MARGIN_TB;
	fwShowButton("wndInit", "btnReduce9975", "99.75%", "FFFFFF", "333399", "", 15, 200, _h, 360, _h + H_BTN);
	_h = _h + H_BTN + MARGIN_TB;
	
	local b404THx0, b404THy0, b404THx1, b404THy1 = 200, _h, 360, _h + H_BTN;
	local function showBtn404TH()
		local _bg = "333333"; if alert404TH then _bg = "339933" end
		fwShowButton("wndInit", "btn404TH", "404TH", "FFFFFF", _bg, "", 15, b404THx0, b404THy0, b404THx1, b404THy1);
	end
	showBtn404TH();
	_h = _h + H_BTN + MARGIN_TB;
	
	local bDEx0, bDEy0, bDEx1, bDEy1 = 200, _h, 360, _h + H_BTN;
	local function showBtnDE()
		local _bg = "333333"; if alertDE then _bg = "339933" end
		fwShowButton("wndInit", "btnDE", "DE 60+", "FFFFFF", _bg, "", 15, bDEx0, bDEy0, bDEx1, bDEy1);
	end
	showBtnDE();
	_h = _h + H_BTN + MARGIN_TB;
	
	local bElixirx0, bElixiry0, bElixirx1, bElixiry1 = 200, _h, 360, _h + H_BTN;
	local function showBtnElixir()
		local _bg = "333333"; if alertElixir then _bg = "339933" end
		fwShowButton("wndInit", "btnElixir", "Elixir 60+", "FFFFFF", _bg, "", 15, bElixirx0, bElixiry0, bElixirx1, bElixiry1);
	end
	showBtnElixir();
	_h = _h + H_BTN + MARGIN_TB;

	local function UpdateTxtReduce(txt)
		txtReduce = txt;
		fwShowButton("wndInit", "txtReduce", txt, "FFFFFF", "243f3f", "", 15, 200, MARGIN_TB, 360, MARGIN_TB + H_BTN);
	end

	-- Btn Events
	while true do
		local vid = fwGetPressedButton();
		
		if starts_with(vid, "btnDef") then
			
			local defN = tonumber(vid:sub(7));
			local def = InitDefaults[defN];
			SearchModeValue = { mode = def.mode, value = def.value };
			break;
		
		elseif starts_with(vid, "btnReduce") then
			
			local redN = tonumber("0." .. vid:sub(10));
			UpdateTxtReduce((redN * 100) .. "%");
			SearchValueProcessor = function(v) return v * redN end
		
		elseif vid == "txtReduce" then
			
			UpdateTxtReduce("100%");
			SearchValueProcessor = function(v) return v end
			
		elseif vid == "btnSetting" then
			
			fwCloseWnd("wndInit");
			
			UINew({titles = "COC Util", orient = 2, width = 720, height = 720, config = "cocUtilConfig.dat"});

			UILabel("Mode:",15,"left","0,0,255",120,1);
			UIRadio("radioMode","G+E,DE,G,E","0",-1,0,"",1,4);

			UILabel("Value:",15,"left","0,0,255",120,1);
			UIEdit("txtModeValue","","100",15,"left","0,0,255","number", 150);

			UIShow();

			SearchModeValue.mode = SearchModes[radioMode];
			SearchModeValue.value = tonumber(txtModeValue);
			break;
		
		elseif vid == "btn404TH" then
		
			alert404TH = not alert404TH;
			showBtn404TH();
		
		elseif vid == "btnDE" then
		
			alertDE = not alertDE;
			showBtnDE();
		
		elseif vid == "btnElixir" then
		
			alertElixir = not alertElixir;
			showBtnElixir();
		
		elseif vid == "btnQuit" then
			lua_exit(); mSleep(10);
		end
		
		if deviceIsLock() ~= 0 then -- device is locked
			lua_exit(); mSleep(10);
		end
	end
	fwCloseWnd("wndInit");
end

function ShowInfoText(msg)
	fwShowTextView("wndInfo","txtInfo", "  [" .. SearchModeValueTxt() .. "] " .. msg,"left","000000","54afff",15,0,0,0,800,60,0.8);
end

function findNext()
	local imgX, imgY = findImage("next.png", 1683, 1095, 1786, 1213);
	return imgX >= 0 and imgY >= 0;
end

function tapNext()
	tap(simpleGaussian(1683, 1993), simpleGaussian(1095, 1233));
end


function ShowInfoFloat()
	fwShowWnd("wndInfo", 350, 40, 350+210, 40+60, 0);
	ShowInfoText("");
end

function WaitInfoReset()
	fwShowButton("wndInfo", "btnReset", "Reset", "FFFFFF", "993333", "", 15, 0, 0, 100, 60);
	fwShowButton("wndInfo", "btnSkip", "Skip", "FFFFFF", "339933", "", 15, 110, 0, 210, 60);
	
	local _begin_time = ts.ms(); local isSkipValid = true;
	while true do
		local btn = fwGetPressedButton();
		if btn == "btnReset" then ProcessInitFloat(); break end
		if btn == "btnSkip" then tapNext(); mSleep(1000); break end
		
		if isSkipValid and ts.ms() > _begin_time + 30 then
			isSkipValid = false;
			fwCloseView("wndInfo", "btnSkip");
		end
		
		if deviceIsLock() ~= 0 then -- device is locked
			lua_exit(); mSleep(10);
		end
	end
	fwCloseView("wndInfo", "btnReset");
	fwCloseView("wndInfo", "btnSkip");
end

SearchModeValue = { mode = SearchModes['G+E'], value = 10 };
function SearchModeValueTxt() return SearchModeValue.mode.name .. " " .. math.floor(SearchModeValue.value) end
function SearchModeValueJudge(G,E,DE) return SearchModeValue.mode.getValue(G,E,DE) > SearchModeValue.value end
SearchValueProcessor = function(v) return v end
function ProcessSearchValue() SearchModeValue.value = SearchValueProcessor(SearchModeValue.value); end

ProcessInitFloat();

while true do
	ShowInfoFloat();

	local _search_i = 0;
	setVolumeLevel(0);

	while true do
		if findNext() then
			mSleep(500);
			_search_i = _search_i + 1;
			local G, E, DE = readCOCLoot();
			local lootStr = "[Loot] G: " .. G .. " E: " .. E .. " DE: " .. DE;
			ShowInfoText(lootStr);
			local judge = SearchModeValueJudge(G, E ,DE);
			if judge then
				break;
			end
			
			local TH_lvl, x, y = findTH();
			if TH_lvl ~= nil then
				showTH(TH_lvl, x, y);
				mSleep(800);
				closeFloatTH();
				if L1dist(x, y) > 0.45 and alert404TH then
					ShowInfoText(lootStr .. " [TH too far] " .. _search_i);
					break;
				end
			elseif alert404TH then
				ShowInfoText(lootStr .. " [TH not found] " .. _search_i);
				break;
			end

			if alertDE then
				if hasAny60DE() then
					ShowInfoText(lootStr .. " [DE > 60] " .. _search_i);
					mSleep(1500);
					fwCloseWnd("wndDEResult");
					break;
				end
				mSleep(1000);
				fwCloseWnd("wndDEResult");
			end

			if alertElixir then
				if hasAny60Elixir() then
					ShowInfoText(lootStr .. " [Elixir > 60] " .. _search_i);
					mSleep(1500);
					fwCloseWnd("wndElixirResult");
					break;
				end
				mSleep(1000);
				fwCloseWnd("wndElixirResult");
			end
			
			ProcessSearchValue();
			tapNext();
			mSleep(simpleGaussian(500, 1000));
		else
			ShowInfoText("[Searching] " .. _search_i);
			mSleep(simpleGaussian(200, 2000));
		end
		
	end

	setVolumeLevel(0.25); mSleep(300);
	playAudio("archer_queen_deploy_01.mp3");
	
	WaitInfoReset();
end



