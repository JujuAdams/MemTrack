#macro json_decode      __MemTrackJSONDecode
#macro __json_decode__  json_decode

function __MemTrackJSONDecode(_string)
{
    var _json = __json_decode__(_string);
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Processing JSON...");
        __MemTrackRecursiveMapCreate(_json, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __MemTrackTrace("...JSON processed");
    }
    
    return _json;
}

function __MemTrackRecursiveMapCreate(_map, _callstack)
{
    global.__memTrackMaps[? _map] = __MemTrackDataCreate(_map, _callstack);
    if (MEMTRACK_VERBOSE) __MemTrackTrace("Created map ", _map, "          ", debug_get_callstack());
    
    var _keyArray   = ds_map_keys_to_array(_map);
    var _valueArray = ds_map_values_to_array(_map);
    
    if (is_array(_keyArray) && is_array(_valueArray))
    {
        var _i = 0;
        repeat(array_length(_keyArray))
        {
            var _key = _keyArray[_i];
            
            if (ds_map_is_map(_map, _key))
            {
                __MemTrackRecursiveMapCreate(_valueArray[_i], _callstack);
            }
            else if (ds_map_is_list(_map, _key))
            {
                __MemTrackRecursiveListCreate(_valueArray[_i], _callstack);
            }
            
            ++_i;
        }
    }
}

function __MemTrackRecursiveListCreate(_list, _callstack)
{
    global.__memTrackLists[? _list] = __MemTrackDataCreate(_list, _callstack);
    if (MEMTRACK_VERBOSE) __MemTrackTrace("Created list ", _list, "          ", debug_get_callstack());
    
    var _i = 0;
    repeat(ds_list_size(_list))
    {
        if (ds_list_is_map(_list, _i))
        {
            __MemTrackRecursiveMapCreate(_list[| _i], _callstack);
        }
        else if (ds_list_is_list(_list, _i))
        {
            __MemTrackRecursiveListCreate(_list[| _i], _callstack);
        }
        
        ++_i;
    }
}

function __MemTrackRecursiveMapDestroy(_map, _callstack)
{
    ds_map_delete(global.__memTrackMaps, _map);
    if (MEMTRACK_VERBOSE) __MemTrackTrace("Destroyed map ", _map, "          ", _callstack);
    
    var _keyArray   = ds_map_keys_to_array(_map);
    var _valueArray = ds_map_values_to_array(_map);
    
    if (is_array(_keyArray) && is_array(_valueArray))
    {
        var _i = 0;
        repeat(array_length(_keyArray))
        {
            var _key = _keyArray[_i];
            
            if (ds_map_is_map(_map, _key))
            {
                __MemTrackRecursiveMapDestroy(_valueArray[_i], _callstack);
            }
            else if (ds_map_is_list(_map, _key))
            {
                __MemTrackRecursiveListDestroy(_valueArray[_i], _callstack);
            }
            
            ++_i;
        }
    }
}

function __MemTrackRecursiveListDestroy(_list, _callstack)
{
    ds_map_delete(global.__memTrackLists, _list);
    if (MEMTRACK_VERBOSE) __MemTrackTrace("Destroyed list ", _list, "          ", _callstack);
    
    var _i = 0;
    repeat(ds_list_size(_list))
    {
        if (ds_list_is_map(_list, _i))
        {
            __MemTrackRecursiveMapDestroy(_list[| _i], _callstack);
        }
        else if (ds_list_is_list(_list, _i))
        {
            __MemTrackRecursiveListDestroy(_list[| _i], _callstack);
        }
        
        ++_i;
    }
}
