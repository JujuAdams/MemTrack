function __MemTrackDataCreate(_assetIndex, _callstack)
{
    try
    {
        var _id = object_get_name(object_index) + ":" + string(id);
    }
    catch(_error)
    {
        //Struct
        var _id = instanceof(self);
    }
    
    return {
        assetIndex: _assetIndex,
        creationTime: current_time,
        creator: _id,
        room: room_get_name(room),
        callstack: _callstack,
    };
}

function __MemTrackDataPresentation(_data)
{
    return string(_data.assetIndex) + ": time = " + string(_data.creationTime) + ", creator = \"" + string(_data.creator) + "\", room = \"" + string(_data.room) + "\", callstack = " + string(_data.callstack);
}

function __MemTrackDataSort(_dataA, _dataB)
{
    //Force a numeric conversion here other GM freaks out with JSON map indexes
    return real(_dataA.assetIndex) - real(_dataB.assetIndex);
}
