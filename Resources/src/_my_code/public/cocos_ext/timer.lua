
-- 全局定时器，timer的二次封装
function delay_call(delay, func, ...)
    assert(delay >= 0)

    local scheduler = cc.Director:getInstance():getScheduler()
    local timer_arg = {...}
    local n = select('#', ...)
    local timer_id = nil
    local _controlFun = nil

    local function _cancelTimer()
        if timer_id then
            scheduler:unscheduleScriptEntry(timer_id)
            timer_id = nil
        end
    end

    -- 返回一个函数用户控制当前timer
    function _controlFun(action)
        assert(action == 'cancel')
        _cancelTimer()
    end

    local function on_timer()
        local next_delay = func(unpack(timer_arg, 1, n))

        if next_delay then
            if next_delay ~= delay then
                _cancelTimer()
                timer_id = scheduler:scheduleScriptFunc(on_timer, next_delay, false)
                delay = next_delay
            end
        else
            _controlFun('cancel')
        end
    end

    timer_id = scheduler:scheduleScriptFunc(on_timer, delay, false)

    return _controlFun
end