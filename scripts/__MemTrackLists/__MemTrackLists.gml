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

function __MemTrackListExists(_list)
{
    return ds_exists(_list, ds_type_list);
}
