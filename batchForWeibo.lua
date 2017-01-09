local tUser = {
	csvFile = "ANiu\\csvInput.csv";
	--luaFile = "csvtest.lua";
	--tableTestFile1 = "tabletest1.lua";
	--tableTestFile2 = "tabletest2.lua";
	--csvTestFile = "tabletest.csv";
	csvOutputFile = "Outputs\\ANiuOutput.csv";
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

-- function csv2table()
    -- local t = {}
    -- t = mCsv.load(tUser.csvFile);
    -- table.save( t, tUser.luaFile );
-- end

-- function saveCsvTest()
	-- local t = {}
	-- t = table.load(tUser.luaFile)
	-- mCsv.save( t, tUser.csvTestFile )
-- end

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
		CQ = "重庆",
		CD = "成都",
		ZZ = "郑州",
		CS = "长沙",
		SZ1 = "苏州",
		XA = "西安",
	}
	local sParser = {
		TopicKW = "地铁客流排行榜",
		DateInput = "(%d+)月(%d+)日",
		WeekInput = "（(周.-)）",
		WeekInput2 = "（(.-)）",
		Ridership = "%%city.-(%d+%.?%d*)万",
		RidershipSZ = "深圳.-(%d+%.?%d*)万",
		DateSent  = "(%d%d%d%d%-%d%d%-%d%d)",
	}
	local sData = {
		-- DateInput = {
			-- month	= {},
			-- day		= {},
		-- },
		--WeekInput = {},
		--Riderships = {},
		-- DateSent = {
			-- year	= {},
			-- month	= {},
			-- day		= {},
		-- }
	}
	local str = lineTbl[1]
	local isValid
	
	-- find out if we have TopicKW or not first!
	
	isValid = string.find(str, sParser.TopicKW)
	if isValid == nil then
		return nil
	end
	
	
	-- sData.DateInput.month, sData.DateInput.day = string.match(str, sParser.DateInput)
	sData.InputMonth, sData.InputDay = string.match(str, sParser.DateInput)
	sData.InputWeek = string.match(str, sParser.WeekInput) or string.match(str, sParser.WeekInput2)
	for k, v in pairs(tCity) do
		sData[v] = string.match(str, string.gsub(sParser.Ridership, "%%city", v ))
	end
	str = lineTbl[2]
	-- sData.DateSent.year, sData.DateSent.month, sData.DateSent.day = string.match(str, sParser.DateSent)
	sData.DateSent = string.match(str, sParser.DateSent)
	sData.RawMsg = lineTbl[1]

	return sData
end

function kvTbl2ivTbl(Tbl)
	local ret = {}
	local header = {}
	local headerT = {}
	for index, subTbl in ipairs(Tbl) do
		if type(subTbl) == "table" then
			local subTableRet = {}
			for name, value in pairs(subTbl) do
				if not headerT[name] then
					table.insert(header, name)
					headerT[name] = #header
				end
				local num = headerT[name]
				subTableRet[num] = value
			end
			table.insert(ret, subTableRet)
		else
			table.insert(ret, subTbl)
		end
	end
	for index, subTbl in ipairs(ret) do
		if type(subTbl) == "table" then
			--if (#subTbl ~= #header) then
				for subIndex, value in pairs(header) do
					if not subTbl[subIndex] then subTbl[subIndex] = " " end
				end
			--end
		end
	end
	table.insert(ret, 1, header)
	return ret
end

function parserANiuTbl(rawTbl)
	local fullTbl = {}
	local lineData = {}
	for k, lineTbl in ipairs(rawTbl) do
		lineData = parserANiuLine(lineTbl)
		if lineData ~= nil then
			table.insert(fullTbl, lineData)
		end
	end
	return fullTbl
end

function parserTableForRidership()
	local t = {}
	local s = {}
	-- t = table.load(tUser.luaFile)
	
	-- from 阿牛
	t = mCsv.load(tUser.csvFile);
	s = parserANiuTbl(t)
	--table.save( s, tUser.tableTestFile1 );
	local ss = kvTbl2ivTbl(s)
	--table.save( ss, tUser.tableTestFile2 );
	mCsv.save( ss, tUser.csvOutputFile )
end

--csv2table();
--saveCsvTest()
parserTableForRidership();