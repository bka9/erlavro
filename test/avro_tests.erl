%%%-------------------------------------------------------------------
%%% @author tihon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. Dec 2016 10:24 AM
%%%-------------------------------------------------------------------
-module(avro_tests).
-author("tihon").

-include("erlavro.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(PRIMITIVE_VALUE(Name, Value),
  #avro_value{ type = #avro_primitive_type{name = Name}
    , data = Value}).

get_test_type(Name, Namespace) ->
  avro_fixed:type(Name, 16, [{namespace, Namespace}]).

split_type_name_test() ->
  ?assertEqual({"tname", ""},
    avro:split_type_name("tname", "", "")),
  ?assertEqual({"tname", "name.space"},
    avro:split_type_name("tname", "name.space", "enc.losing")),
  ?assertEqual({"tname", "name.space"},
    avro:split_type_name("name.space.tname", "", "name1.space1")),
  ?assertEqual({"tname", "enc.losing"},
    avro:split_type_name("tname", "", "enc.losing")).

get_type_fullname_test() ->
  ?assertEqual("name.space.tname",
    avro:get_type_fullname(get_test_type("tname", "name.space"))),
  ?assertEqual("int",
    avro:get_type_fullname(avro_primitive:int_type())).

cast_primitive_test() ->
  ?assertEqual({ok, ?PRIMITIVE_VALUE(?AVRO_STRING, "abc")},
    avro:cast(avro_primitive:string_type(), "abc")),
  ?assertEqual({ok, ?PRIMITIVE_VALUE(?AVRO_INT, 1)}, avro:cast("int", 1)),
  ?assertEqual({ok, ?PRIMITIVE_VALUE(?AVRO_LONG, 1)}, avro:cast("long", 1)).