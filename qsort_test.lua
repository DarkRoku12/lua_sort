
local qsort = require "qsort_op"

local function debug( t )
	print( table.concat( t , " " ) )
end

local test1 = { 8 , 7 , 6 , 9 , -10 , 15 , 5 , 12 , 6 }

local test2 =
{
 -- 100 numbers, between 0~100.
 059,067,094,088,054,080,029,029,082,098,022,076,014,074,020,055,004,055,077,065,
 000,068,011,081,001,012,005,027,060,089,003,006,024,070,060,016,020,083,095,032,
 047,027,088,079,080,077,087,057,071,085,016,068,066,098,078,083,067,015,071,030,
 026,092,069,008,090,073,100,019,086,085,061,061,013,029,054,007,046,005,052,087,
 009,087,082,070,005,100,043,012,033,044,037,059,092,094,035,038,056,001,065,021,
}

local test3 =
{
  { k = 5 } , { k = 2 } , { k = 10 } , { k = 0 } , { k = 7 } , k = { 6 }
}

print( "Test #1:" )

qsort( test1 )

debug( test1 )

print( "Test #2:" )

qsort( test2 )

debug( test2 )

print( "Test #3: (Callback) " )

qsort( test3 , function( a , b ) return a.k < b.k end )

local r = {}

for k , v in ipairs( test3 ) do
   r[ k ] = v.k ;
end

debug( r )
