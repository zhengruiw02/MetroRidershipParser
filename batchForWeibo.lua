local tUser = {
	csvFile = "csvtest.csv";
	luaFile = "csvtest.lua";
	tableTestFile = "tabletest.lua";
	csvTestFile = "tabletest.csv";
};


dofile( "table.save-1.0.lua" );
-- include module Csv
local mCsv = require "csv2table"

-- do
	-- table.getn = function (t)
        -- if t.n then
            -- return t.n
        -- else
            -- local n = 0
            -- for i in pairs(t) do
                -- if type(i) == "number" then
                    -- n = math.max(n, i)
                -- end
            -- end
        -- return n
        -- end
    -- end
-- end

function csv2table()
    local t = {}
    t = mCsv.load(tUser.csvFile);
    table.save( t, tUser.luaFile );
end

function saveTableTest()
	local t = { {1},{2,},{5}}
	table.save( t, tUser.tableTestFile );
end

function saveCsvTest()
	local t = {}
	t = table.load(tUser.luaFile)
	mCsv.save( t, tUser.csvTestFile )
end

--[[ #地铁客流排行榜# 3月31日（周四），北京地铁路网客运量1168.62万，上海地铁客运量1019.8万，广州地铁客运量为720.8万， 深圳地铁路网客运量346.68万，南京地铁客运量为231.6万，武汉地铁客运量206.36万，成都地铁客运量139.33万。,
	2016-04-01 12:39:00 来自 微博 weibo.com]]
-- row one have date,week,city,ridership, 
-- row two have date time of sent
function parserANiu(rawTbl)
	local tCity = {
		["北京"]	= true;
		["上海"]	= true;
		["深圳"]	= true;
		["广州"]	= true;
		["南京"]	= true;
		["武汉"]	= true;
		["成都"]	= true;
	}
	local sParser = {
		DateInput = "[%d+]月[%d+]日";
		WeekInput = "（周[%s+]）";
		Ridership = "%%city.+[%d+.?%d+]万";
		DateSend  = "[%d%d%d%d-%d%d-%d%d]"
	}

	
end

function parserTableForRidership()
	local t = {}
	t = table.load(tUser.luaFile)

	-- from 阿牛
	--saveCsvTest( t, filename )
end

--csv2table();
--saveTableTest();
saveCsvTest()