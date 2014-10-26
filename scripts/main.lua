require("config")
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback(">>>", 4))
    print("----------------------------------------")
end

require("app.MyApp").new():run()

