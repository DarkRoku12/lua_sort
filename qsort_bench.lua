
local jit = require "jit"

local qsort = require "qsort_op"

local function newBench()
   return
   {
     prev = os.clock() ,
     get = function( self , msg )
        self.prev = os.clock() - self.prev ;
        print( ("%s done in: %f seconds"):format( msg or "" , self.prev ) )
        self.prev = os.clock()
     end
   }
end

local function doBench( iterations )

   print( ("Table lenght: %d"):format( iterations ) )

   local A , B , C , D = {} , {} , {} , {} ;

   for i = 1 , iterations do
      A[ i ] = math.random( 1 , 100 )
      B[ i ] = A[ i ]
      C[ i ] = A[ i ]
      D[ i ] = A[ i ]
   end

   local bench = newBench()

   qsort( A )

   bench:get( "JIT sort - Test #1" )

   qsort( B )

   bench:get( "JIT sort - Test #2" )

   table.sort( C )

   bench:get( "Built-in sort - Test #1" )

   table.sort( D )

   bench:get( "Built-in sort - Test #2" )

   collectgarbage()

end

-- defulat JIT state is ON on most devices.
print( "----- JIT ON -----" )

doBench( 1000 )
doBench( 2e5 ) -- 20,000.
doBench( 3e5 ) -- 30,000.
doBench( 1e6 ) -- 1 million.

jit.off()
jit.flush()

print( "----- JIT OFF -----" )

doBench( 1000 )
doBench( 2e5 ) -- 20,000.
doBench( 3e5 ) -- 30,000.
doBench( 1e6 ) -- 1 million.
