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

function parserTableForRidership()
	local t = {}
	t = table.load(tUser.luaFile)
	saveCsvTest( t, filename )
end

--csv2table();
--saveTableTest();
saveCsvTest()