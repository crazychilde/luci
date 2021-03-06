--[[
--macvlan configuration page. Made by 981213
--
]]--

local fs = require "nixio.fs"

local cmd = "mwan3 status | grep -c \"is online (tracking active)\""
local shellpipe = io.popen(cmd,"r")
local ifnum = shellpipe:read("*a")
shellpipe:close()


m = Map("macvlan", translate("Create virtual WAN interfaces"),
        translatef("Here you can create some virtual WAN interfaces with MACVLAN driver.Set wan metric first!<br />Connected interface count: ")..ifnum)

s = m:section(TypedSection, "macvlan", translate(" "))
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

wannum = s:option(Value, "wannum", translate("Number of virtual WAN"))
wannum.datatype = "range(0,20)"
wannum.optional = false

--[[
pppnum = s:option(Value, "pppnum", translate("Number of PPP diag"))
pppnum.datatype = "range(0,20)"
pppnum.optional = false
]]--

s:option(DummyValue,"opennewwindow" ,"<br /><p align=\"justify\"><script type=\"text/javascript\"></script><input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\""..translate("rediag").."\" onclick=\"window.open('"..luci.dispatcher.build_url("admin", "network", "macvlan_rediag").."')\" /></p>")

local apply = luci.http.formvalue("cbi.apply")
if apply then
	os.execute('/bin/genwancfg &')
end

return m


