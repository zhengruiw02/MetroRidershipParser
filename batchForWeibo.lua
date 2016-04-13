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
		CD = "�ɶ�",
	}
	local sParser = {
		DateInput = "(%d+)��(%d+)��",
		WeekInput = "��(��%s+)��",
		Ridership = "%%city.-(%d+%.?%d*)��",
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

	-- from ��ţ
	s = parserANiuTbl(t)
	table.save( s, tUser.tableTestFile );
	--saveCsvTest( t, filename )
end

--csv2table();
--saveTableTest();
saveCsvTest()
parserTableForRidership();