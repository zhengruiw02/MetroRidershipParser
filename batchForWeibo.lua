local userConstant = {};
userConstant.csvFile = "csvtest.csv";
userConstant.luaFile = "csvtest.lua";
userConstant.tableTestFile = "tabletest.lua";

dofile( "table.save-1.0.lua" );
dofile( "csv2table.lua" );

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
    t = LoadCsv(userConstant.csvFile);
    table.save( t, userConstant.luaFile );
end

function saveTableTest()
	local t = { {1},{2,},{5}}
	table.save( t, userConstant.tableTestFile );
end

-- Used to escape "'s by toCSV
function escapeCSV (s)
  if string.find(s, '[,"]') then
    s = '"' .. string.gsub(s, '"', '""') .. '"'
  end
  return s
end

-- Convert from table to CSV string
function toCSV (tt)
  local s = ""
-- ChM 23.02.2014: changed pairs to ipairs 
-- assumption is that fromCSV and toCSV maintain data as ordered array
  for _,p in ipairs(tt) do  
    s = s .. "," .. escapeCSV(p)
  end
  return string.sub(s, 2)      -- remove first comma
end

function parserTableForRidership()
	local t = {}
	t = table.load(userConstant.luaFile)
	
end

--csv2table();
saveTableTest();