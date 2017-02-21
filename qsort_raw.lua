
-- Raw version.

-- Stack slot #1 = t.
local function set2( t , i , j , ival , jval )
   t[ i ] = ival ; -- lua_rawseti(L, 1, i);
   t[ j ] = jval ; -- lua_rawseti(L, 1, j);
end

local function sort_comp( a , b , comp )

   if comp then
       return comp( a , b )
   end

   return a < b ;
end

local auxsort ;

function auxsort( t , l , u , comp )

  while l < u do

	  local i , j ; -- /* for tail recursion */

    -- sort elements a[l], a[(l+u)/2] and a[u]
    local a = t[ l ] -- lua_rawgeti(L, 1, l);
    local b = t[ u ] -- lua_rawgeti(L, 1, u);

    if sort_comp( b , a , comp ) then
    	 set2( t , l , u , b , a ) -- /* swap a[l] - a[u] */
    else
    	 a , b = nil , nil ; -- lua_pop(L, 2);
    end

    if u - l == 1 then break end -- only 2 elements

    i = math.floor( ( l + u ) / 2 ) ;

    local a = t[ i ] -- lua_rawgeti(L, 1, i);
    local b = t[ l ] -- lua_rawgeti(L, 1, l);

    if sort_comp( a , b , comp ) then -- a[i] < a[l] ?
       set2( t , i , l , b , a )
    else
       b = nil -- remove a[l]
       b = t[ u ]
       if sort_comp( b , a , comp ) then -- a[u]<a[i] ?
          set2( t , i , u , b , a )
       else 
       	 a , b = nil , nil ; -- lua_pop(L, 2);
       end
    end

    if u - l == 2 then break end ; -- only 3 elements

    local P = t[ i ] -- Pivot.
    local P2 = P -- lua_pushvalue(L, -1);
    local b = t[ u - 1 ]

    set2( t , i , u - 1 , b , P2 )
    -- a[l] <= P == a[u-1] <= a[u], only need to sort from l+1 to u-2 */

    i = l ; j = u - 1 ;

    while true do -- for( ; ; )
    -- invariant: a[l..i] <= P <= a[j..u]
    -- repeat ++i until a[i] >= P

      i = i + 1 ; -- ++i
      local a = t[ i ] -- lua_rawgeti(L, 1, i)

      while sort_comp( a , P , comp ) do
         i = i + 1 ; -- ++i
         a = t[ i ] -- lua_rawgeti(L, 1, i)
      end

      -- repeat --j until a[j] <= P

      j = j - 1 ; -- --j
      local b = t[ j ]

      while sort_comp( P , b , comp ) do
         j = j - 1 ; -- --j
         b = t[ j ] -- lua_rawgeti(L, 1, j)
      end

      if j < i then
      	P , a , b = nil , nil , nil ;
         -- lua_pop(L, 3);  /* pop pivot, a[i], a[j] */
         break
      end

      set2( t , i , j , b , a )
    end -- End for.

    local a = t[ u - 1 ] -- lua_rawgeti(L, 1, u-1);
    local b = t[ i ] -- lua_rawgeti(L, 1, i);
    set2( t , u - 1 , i , b , a ) --  swap pivot (a[u-1]) with a[i]

    -- a[l..i-1] <= a[i] == P <= a[i+1..u] */
    -- adjust so that smaller half is in [j..i] and larger one in [l..u] */

    if ( i - l ) < ( u - i ) then
      j = l ;
      i = i - 1 ;
      l = i + 2 ;
    else
      j = i + 1 ;
      i = u ;
      u = j - 2 ;
    end

     auxsort( t , j , i , comp ) ;  -- call recursively the smaller one */

	end
	-- end of while
   -- repeat the routine for the larger one

end

-- sort function.
return function( t , comp )

    assert( type( t ) == "table" )

    if comp then
       assert( type( comp ) == "function" )
    end

    auxsort( t , 1 , #t , comp )
end
