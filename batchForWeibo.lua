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
function parserANiu(rawTbl)
	local tCity = {
		["����"]	= true;
		["�Ϻ�"]	= true;
		["����"]	= true;
		["����"]	= true;
		["�Ͼ�"]	= true;
		["�人"]	= true;
		["�ɶ�"]	= true;
	}
	local sParser = {
		DateInput = "[%d+]��[%d+]��";
		WeekInput = "����[%s+]��";
		Ridership = "%%city.+[%d+.?%d+]��";
		DateSend  = "[%d%d%d%d-%d%d-%d%d]"
	}

	
end

function parserTableForRidership()
	local t = {}
	t = table.load(tUser.luaFile)

	-- from ��ţ
	--saveCsvTest( t, filename )
end

--csv2table();
--saveTableTest();
saveCsvTest()