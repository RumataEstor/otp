%%
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 2008-2013. All Rights Reserved.
%% 
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% %CopyrightEnd%
%%

-module(dict_test_lib).

-export([new/2]).

new(Mod, Eq) ->
    fun (enter, {K,V,D}) -> enter(Mod, K, V, D);
	(empty, []) -> empty(Mod);
	(equal, {D1,D2}) -> Eq(D1, D2);
	(from_list, L) -> from_list(Mod, L);
	(module, []) -> Mod;
	(size, D) -> Mod:size(D);
	(is_empty, D) -> Mod:is_empty(D);
	(to_list, D) -> to_list(Mod, D)
    end.

empty(Mod) ->
    case erlang:function_exported(Mod, new, 0) of
	false -> Mod:empty();
	true -> Mod:new()
    end.

to_list(Mod, D) ->
    Mod:to_list(D).

from_list(Mod, L) ->
    case erlang:function_exported(Mod, from_orddict, 1) of
	false ->
	    Mod:from_list(L);
	true ->
	    %% The gb_trees module has no from_list/1 function.
	    %%
	    %% The keys in S are not unique. To make sure
	    %% that we pick the same key/value pairs as
	    %% dict/orddict, first convert the list to an orddict.
	    Orddict = orddict:from_list(L),
	    Mod:from_orddict(Orddict)
    end.

%% Store new value into dictionary or update previous value in dictionary.
enter(Mod, Key, Val, Dict) ->
    case erlang:function_exported(Mod, store, 3) of
	false ->
	    Mod:enter(Key, Val, Dict);
	true ->
	    Mod:store(Key, Val, Dict)
    end.
