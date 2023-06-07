#macro ds_priority_create      __MemTrackPQueueCreate
#macro __ds_priority_create__  ds_priority_create

function __MemTrackPQueueCreate()
{
    var _pqueue = __ds_priority_create__();
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackPQueues[? _pqueue] = __MemTrackDataCreate(_pqueue, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Created priority queue ", _pqueue, "          ", debug_get_callstack());
    }
    
    return _pqueue;
}

#macro ds_priority_destroy      __MemTrackPQueueDestroy
#macro __ds_priority_destroy__  ds_priority_destroy

function __MemTrackPQueueDestroy(_pqueue)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        ds_map_delete(global.__memTrackPQueues, _pqueue);
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Destroyed priority queue ", _pqueue, "          ", debug_get_callstack());
    }
    
    return __ds_priority_destroy__(_pqueue);
}

function __MemTrackPQueueExists(_pqueue)
{
    return ds_exists(_pqueue, ds_type_priority);
}