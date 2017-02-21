/*
** Table library.
** Copyright (C) 2005-2015 Mike Pall. See Copyright Notice in luajit.h
**
** Major portions taken verbatim or adapted from the Lua interpreter.
** Copyright (C) 1994-2008 Lua.org, PUC-Rio. See Copyright Notice in lua.h
*/

// Taken from: lib_table.c -- LuaJIT 2.1.0 Beta.

static void set2(lua_State *L, int i, int j)
{
  lua_rawseti(L, 1, i);
  lua_rawseti(L, 1, j);
}

static int sort_comp(lua_State *L, int a, int b)
{
  if (!lua_isnil(L, 2)) 
  {  /* function? */
    int res;
    lua_pushvalue(L, 2);
    lua_pushvalue(L, a-1);  /* -1 to compensate function */
    lua_pushvalue(L, b-2);  /* -2 to compensate function and `a' */
    lua_call(L, 2, 1);
    res = lua_toboolean(L, -1);
    lua_pop(L, 1);
    return res;
  } 
  else 
  {  /* a < b? */
    return lua_lessthan(L, a, b);
  }
}

static void auxsort(lua_State *L, int l, int u)
{
  while (l < u) 
  {  /* for tail recursion */
    int i, j;
    /* sort elements a[l], a[(l+u)/2] and a[u] */
    lua_rawgeti(L, 1, l);
    lua_rawgeti(L, 1, u);
    if (sort_comp(L, -1, -2))  /* a[u] < a[l]? */
      set2(L, l, u);  /* swap a[l] - a[u] */
    else
      lua_pop(L, 2);
    if (u-l == 1) break;  /* only 2 elements */
    i = (l+u)/2;
    lua_rawgeti(L, 1, i);
    lua_rawgeti(L, 1, l);
    if (sort_comp(L, -2, -1)) 
    {  /* a[i]<a[l]? */
      set2(L, i, l);
    } 
    else 
    {
      lua_pop(L, 1);  /* remove a[l] */
      lua_rawgeti(L, 1, u);
      if (sort_comp(L, -1, -2))  /* a[u]<a[i]? */
	set2(L, i, u);
      else
	lua_pop(L, 2);
    }
    if (u-l == 2) break;  /* only 3 elements */
    lua_rawgeti(L, 1, i);  /* Pivot */
    lua_pushvalue(L, -1);
    lua_rawgeti(L, 1, u-1);
    set2(L, i, u-1);
    /* a[l] <= P == a[u-1] <= a[u], only need to sort from l+1 to u-2 */
    i = l; j = u-1;
    for (;;) 
    {  /* invariant: a[l..i] <= P <= a[j..u] */
      /* repeat ++i until a[i] >= P */
      while (lua_rawgeti(L, 1, ++i), sort_comp(L, -1, -2)) 
      {
	if (i>=u) lj_err_caller(L, LJ_ERR_TABSORT);
	lua_pop(L, 1);  /* remove a[i] */
      }
      /* repeat --j until a[j] <= P */
      while (lua_rawgeti(L, 1, --j), sort_comp(L, -3, -1)) 
      {
	if (j<=l) lj_err_caller(L, LJ_ERR_TABSORT);
	lua_pop(L, 1);  /* remove a[j] */
      }
      if (j<i) {
	lua_pop(L, 3);  /* pop pivot, a[i], a[j] */
	break;
      }
      set2(L, i, j);
    }
    lua_rawgeti(L, 1, u-1);
    lua_rawgeti(L, 1, i);
    set2(L, u-1, i);  /* swap pivot (a[u-1]) with a[i] */
    /* a[l..i-1] <= a[i] == P <= a[i+1..u] */
    /* adjust so that smaller half is in [j..i] and larger one in [l..u] */
    if (i-l < u-i) 
    {
      j=l; i=i-1; l=i+2;
    } 
    else 
    {
      j=i+1; i=u; u=j-2;
    }
    auxsort(L, j, i);  /* call recursively the smaller one */
  }  /* repeat the routine for the larger one */
}

LJLIB_CF(table_sort)
{
  GCtab *t = lj_lib_checktab(L, 1);
  int32_t n = (int32_t)lj_tab_len(t);
  lua_settop(L, 2);
  if (!tvisnil(L->base+1))
    lj_lib_checkfunc(L, 2);
  auxsort(L, 1, n);
  return 0;
}


