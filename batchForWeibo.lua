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
function parserANiuLine(lineTbl)
	local tCity = {
		BJ = "北京",
		SH = "上海",
		GZ = "广州",
		SZ = "深圳",
		NJ = "南京",
		WH = "武汉",
		CD = "成都",
	}
	local sParser = {
		DateInput = "(%d+)月(%d+)日",
		WeekInput = "（(周%s+)）",
		Ridership = "%%city.-(%d+%.?%d*)万",
		DateSent  = "(%d%d%d%d)-(%d%d)-(%d%d)",
	}
	local sData = {
		DateInput = {
			month	= {},
			day		= {},
		},
		WeekInput = {},
		Riderships = {},
		DateSent = {
			year	= {},
			month	= {},
			day		= {},
		}
	}
	local str = lineTbl[1]
	sData.DateInput.month, sData.DateInput.day = string.match(str, sParser.DateInput)
	sData.WeekInput = string.match(str, sParser.WeekInput)
	for k, v in ipairs(tCity) do
		sData.Riderships.k = string.match(str, string.gsub(sParser.Ridership, "%city", v ))
	end
	str = lineTbl[2]
	sData.DateSent.year, sData.DateSent.month, sData.DateSent.day = string.match(str, sParser.DateSent)

	return sData
	
end

function parserANiuTbl(rawTbl)
	local fullTbl = {}
	local lineData = {}
	for k, lineTbl in ipairs(rawTbl) do
		lineData = parserANiuLine(lineTbl)
		table.insert(fullTbl, lineData)
	end
	return fullTbl
end

function parserTableForRidership()
	local t = {}
	local s = {}
	t = table.load(tUser.luaFile)

	-- from 阿牛
	s = parserANiuTbl(t)
	table.save( s, tUser.tableTestFile );
	--saveCsvTest( t, filename )
end

--csv2table();
--saveTableTest();
saveCsvTest()
parserTableForRidership();