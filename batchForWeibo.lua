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

--[[ #�����������а�# 3��31�գ����ģ�����������·��������1168.62���Ϻ�����������1019.8�򣬹��ݵ���������Ϊ720.8�� ���ڵ���·��������346.68���Ͼ�����������Ϊ231.6���人����������206.36�򣬳ɶ�����������139.33��,
	2016-04-01 12:39:00 ���� ΢�� weibo.com]]
-- row one have date,week,city,ridership, 
-- row two have date time of sent
function parserANiuLine(lineTbl)
	local tCity = {
		BJ = "����",
		SH = "�Ϻ�",
		GZ = "����",
		SZ = "����",
		NJ = "�Ͼ�",
		WH = "�人",
		CQ = "����",
		CD = "�ɶ�",
		ZZ = "֣��",
		CS = "��ɳ",
		SZ1 = "����",
		XA = "����",
	}
	local sParser = {
		TopicKW = "�����������а�",
		DateInput = "(%d+)��(%d+)��",
		WeekInput = "��(��.-)��",
		WeekInput2 = "��(.-)��",
		Ridership = "%%city.-(%d+%.?%d*)��",
		RidershipSZ = "����.-(%d+%.?%d*)��",
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
	
	-- from ��ţ
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