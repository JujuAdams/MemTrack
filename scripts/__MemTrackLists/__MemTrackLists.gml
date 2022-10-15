#macro ds_list_create      __MemTrackListCreate
#macro __ds_list_create__  ds_list_create

function __MemTrackListCreate()
{
    var _list = __ds_list_create__();
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackLists[? _list] = __MemTrackDataCreate(_list, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Created list ", _list, "          ", debug_get_callstack());
    }
    
    return _list;
}

#macro ds_list_destroy      __MemTrackListDestroy
#macro __ds_list_destroy__  ds_list_destroy

function __MemTrackListDestroy(_list)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        __MemTrackRecursiveListDestroy(_list, debug_get_callstack());
    }
    
    return __ds_list_destroy__(_list);
}

#macro ds_map_add_list      __MemTrackMapAddList
#macro __ds_map_add_list__  ds_map_add_list

function __MemTrackMapAddList(_id, _key, _value)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        ds_map_delete(global.__memTrackLists, _value);
        if (MEMTRACK_VERBOSE) __MemTrackTrace("List ", _value, " added to map ", _id, " as \"", _key, "\", untracking list          ", debug_get_callstack());
    }
    
    return __ds_map_add_list__(_id, _key, _value);
}

#macro ds_list_mark_as_list      __MemTrackListMarkList
#macro __ds_list_mark_as_list__  ds_list_mark_as_list

function __MemTrackListMarkList(_id, _pos)
{
    if (MEMTRACK_ENABLED)
    {
        var _list = _id[| _pos];
        if (_list != undefined)
        {
            __MemTrackInitialize();
            ds_map_delete(global.__memTrackLists, _list);
            if (MEMTRACK_VERBOSE) __MemTrackTrace("List ", _list, " marked for binding to list ", _id, " (pos=", _pos, "), untracking list          ", debug_get_callstack());
        }
    }
    
    return __ds_list_mark_as_list__(_id, _pos);
}

function __MemTrackListExists(_list)
{
    return ds_exists(_list, ds_type_list);
}
