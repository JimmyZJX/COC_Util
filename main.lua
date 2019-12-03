
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


init(2);
vibrator();

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
	{ name = 'G 50w', mode = SearchModes['G'], value = 50 },
	{ name = 'DE 2000', mode = SearchModes['DE'], value = 2000 },
	{ name = 'DE 4000', mode = SearchModes['DE'], value = 4000 },
};

local txtReduce = "100%";
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
	tap(1683, 1095);
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
			ShowInfoText("[Loot] G: " .. G .. " E: " .. E .. " DE: " .. DE);
			local judge = SearchModeValueJudge(G, E ,DE);
			if judge then
				setVolumeLevel(0.35);
				vibrator(); mSleep(300); vibrator(); mSleep(300);
				playAudio("archer_queen_deploy_01.mp3");
				break;
			end
			
			ProcessSearchValue();
			tapNext();
			mSleep(1000);
		else
			ShowInfoText("[Searching] " .. _search_i);
			mSleep(1000);
		end
		
	end
	
	WaitInfoReset();
end



